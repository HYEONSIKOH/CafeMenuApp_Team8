<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background: #ddd; }
        .card { margin: auto; max-width: 950px; width: 90%; box-shadow: 0 6px 20px 0 rgba(0, 0, 0, 0.19); border-radius: 1rem; border: transparent; }
        .summary { background-color: #ddd; border-top-right-radius: 1rem; border-bottom-right-radius: 1rem; padding: 4vh; color: rgb(65, 65, 65); }
        @media (max-width: 767px) { .summary { border-top-right-radius: unset; border-bottom-left-radius: 1rem; } }
        .products { width: 100%; }
        .products .price, .products .action { line-height: 38px; }
    </style>
    <title>CoffeeProject</title>
</head>
<body class="container-fluid">
<div class="row justify-content-center m-4">
    <h1 class="text-center">Grids & Circle</h1>
</div>
<div class="card">
    <div class="row">
        <!-- 상품 목록 -->
        <div class="col-md-8 mt-4 d-flex flex-column align-items-start p-3 pt-0">
            <h5 class="flex-grow-0"><b>상품 목록</b></h5>
            <ul id="product-list" class="list-group products">
                <!-- 상품 항목을 동적으로 추가할 부분 -->
            </ul>
        </div>

        <!-- 요약 섹션 -->
        <div class="col-md-4 summary p-4">
            <div>
                <h5 class="m-0 p-0"><b>Summary</b></h5>
            </div>
            <hr>
            <div class="row" id="summary-list">
                <!-- 상품별 수량 요약을 동적으로 추가할 부분 -->
            </div>
            <form>
                <div class="mb-3">
                    <label for="email" class="form-label">이메일</label>
                    <input type="email" class="form-control mb-1" id="email">
                </div>
                <div class="mb-3">
                    <label for="address" class="form-label">주소</label>
                    <input type="text" class="form-control mb-1" id="address">
                </div>
                <div class="mb-3">
                    <label for="postal" class="form-label">우편번호</label>
                    <input type="text" class="form-control" id="postal">
                </div>
                <div>당일 오후 2시 이후의 주문은 다음날 배송을 시작합니다.</div>
            </form>
            <hr>
            <div class="row">
                <h5 class="col">총금액</h5>
                <h5 id="total-price" class="col text-end">0원</h5>
            </div>
            <button class="btn btn-dark col-12">결제하기</button>
        </div>
    </div>
</div>

<script>
    window.onload = function () {
        // 상품 목록을 AJAX로 불러오기
        const request = new XMLHttpRequest();
        const productList = document.getElementById('product-list');
        const summaryList = document.getElementById('summary-list');
        let total = 0;
        const cart = {};  // 장바구니 객체, 상품 ID를 키로 수량을 저장

        // GET 요청 전송
        request.open("GET", "http://221.149.143.92:8080/api/coffeeList", true); // 실제 상품 API 경로로 수정

        request.onreadystatechange = function () {
            if (request.readyState === 4) {
                if (request.status === 200) {
                    const products = JSON.parse(request.responseText);
                    renderProductList(products);

                    // 상품 목록이 없으면 알림
                    if (products.length === 0) {
                        productList.innerHTML = '<li class="list-group-item">상품이 없습니다.</li>';
                    }

                    // 상품 항목 생성
                    products.forEach(product => {
                        const listItem = document.createElement('li');
                        listItem.className = 'list-group-item d-flex mt-3';
                        listItem.innerHTML = `
                            <div class="col-2"><img class="img-fluid" src="`+ product['img'] +`" alt=""></div>
                            <div class="col">
                                <div class="row">`+ product['productNm'] +`</div>
                            </div>
                            <div class="col text-center price">`+ product['price'] +`원</div>
                            <div class="col text-end action">
                                <button class="btn btn-small btn-outline-dark decrease" data-id="`+ product['productId'] +`" data-price="`+ product['price'] +`">-</button>
                                <span id="quantity-`+ product['productId'] +`" class="quantity">0</span>
                                <button class="btn btn-small btn-outline-dark increase" data-id="`+ product['productId'] +`" data-price="`+ product['price'] +`">+</button>
                                <button class="btn btn-small btn-outline-danger delete" data-id="`+ product['productId'] +`">삭제</button>
                            </div>
                        `;
                        productList.appendChild(listItem);

                        // 수량 증가 버튼 이벤트
                        document.querySelector(`.increase[data-id="`+ product['productId'] +`"]`).addEventListener('click', function () {
                            const price = parseInt(this.getAttribute('data-price'), 10);
                            const productId = this.getAttribute('data-id');
                            if (!cart[productId]) cart[productId] = 0; // 처음엔 수량이 0
                            cart[productId]++;
                            updateQuantity(productId);
                            updateSummary();
                            total += price;
                            document.getElementById('total-price').innerText = `${total}원`;
                        });

                        // 수량 감소 버튼 이벤트
                        document.querySelector(`.decrease[data-id="`+ product['productId'] +`"]`).addEventListener('click', function () {
                            const price = parseInt(this.getAttribute('data-price'), 10);
                            const productId = this.getAttribute('data-id');
                            if (cart[productId] && cart[productId] > 0) {
                                cart[productId]--;
                                updateQuantity(productId);
                                updateSummary();
                                total -= price;
                                document.getElementById('total-price').innerText = `${total}원`;
                            }
                        });

                        // 삭제 버튼 이벤트
                        document.querySelector(`.delete[data-id="`+ product['productId'] +`"]`).addEventListener('click', function () {
                            const productId = this.getAttribute('data-id');
                            if (cart[productId]) {
                                total -= cart[productId] * product.price; // 수량에 맞게 총액에서 차감
                                document.getElementById('total-price').innerText = `${total}원`;
                                cart[productId] = 0;  // 장바구니에서 삭제
                                updateQuantity(productId);
                                updateSummary();
                            }
                        });
                    });

                    // 장바구니의 수량 갱신
                    function updateQuantity(productId) {
                        const quantityElement = document.getElementById(`quantity-`+ product['productId']);
                        quantityElement.innerText = cart[productId];
                    }

                    // 구매할 물품 요약 갱신
                    function updateSummary() {
                        // summary-list 영역을 초기화
                        summaryList.innerHTML = '';
                        let totalItems = 0;

                        // 장바구니에 담긴 상품을 순차적으로 업데이트
                        Object.keys(cart).forEach(productId => {
                            const product = products.find(p => p.id == productId);
                            if (cart[productId] > 0) {
                                totalItems++;
                                const itemSummary = document.createElement('div');
                                itemSummary.className = 'col-12';
                                itemSummary.innerHTML = `
                                    <div class="row">
                                        <div class="col-8">${product_nm}</div>
                                        <div class="col text-end">${cart[productId]}개</div>
                                    </div>
                                `;
                                summaryList.appendChild(itemSummary);
                            }
                        });

                        // 물품이 하나도 없으면 '장바구니가 비었습니다' 텍스트 추가
                        if (totalItems === 0) {
                            const emptySummary = document.createElement('div');
                            emptySummary.className = 'col-12';
                            emptySummary.innerText = '장바구니가 비었습니다.';
                            summaryList.appendChild(emptySummary);
                        }
                    }

                    // 결제 버튼 클릭 시 주문 정보 전송
                    document.querySelector('.btn-dark').addEventListener('click', function () {
                        const email = document.getElementById('email').value;
                        const address = document.getElementById('address').value;
                        const postal = document.getElementById('postal').value;

                        // 장바구니 데이터 생성
                        const orderData = {
                            email: email,
                            address: address,
                            postal: postal,
                            items: []  // 상품 목록
                        };

                        // 장바구니 데이터 추가
                        Object.keys(cart).forEach(productId => {
                            const product = products.find(p => p.id == productId);
                            if (cart[productId] > 0) {
                                orderData.items.push({
                                    product_id: productId,
                                    quantity: cart[productId],
                                    price: product.price
                                });
                            }
                        });

                        // 서버로 주문 데이터 전송
                        const orderRequest = new XMLHttpRequest();
                        orderRequest.onreadystatechange = function () {
                            if (orderRequest.readyState === 4) {
                                if (orderRequest.status === 200) {
                                    alert('주문이 완료되었습니다.');
                                } else {
                                    alert('주문을 처리하는 데 실패했습니다.');
                                }
                            }
                        };

                        orderRequest.open("POST", "/api/orders", true);  // 실제 API 경로로 수정
                        orderRequest.setRequestHeader("Content-Type", "application/json");
                        orderRequest.send(JSON.stringify(orderData));
                    });
                } else {
                    alert("상품 데이터를 불러오는 데 실패했습니다.");
                }
            }
        };
        request.send();

        // 상품 목록 렌더링
        function renderProductList(products) {
            productList.innerHTML = ''; // 기존 목록 초기화

            products.forEach(product => {
                const listItem = document.createElement('li');
                listItem.className = 'list-group-item d-flex mt-2';
                listItem.innerHTML = `
                    <div class="col-2">
                        <img class="img-fluid" src="${product.img}" alt="${product.productNm}">
                    </div>
                    <div class="col">
                        <div class="row">${product.productNm}</div>
                    </div>
                    <button class="btn btn-outline-dark col-2" data-id="${product.productId}">추가</button>
                `;
                productList.appendChild(listItem);

                listItem.querySelector('button').addEventListener('click', function () {
                    addToSummary(product);
                });
            });
        }

        // 요약에 추가
        function addToSummary(product) {
            if (!cart[product.productId]) {
                cart[product.productId] = { ...product, quantity: 1 };

                const summaryItem = document.createElement('div');
                summaryItem.className = 'row mb-2';
                summaryItem.setAttribute('data-id', product.productId);
                summaryItem.innerHTML = `
                    <div class="col-8">${product.productNm}</div>
                    <div class="col-4 text-end">
                        <span class="badge bg-dark">${cart[product.productId].quantity}개</span>
                    </div>
                `;
                summaryList.appendChild(summaryItem);
            } else {
                cart[product.productId].quantity++;
                const existingItem = summaryList.querySelector(`[data-id="${product.productId}"]`);
                existingItem.querySelector('.badge').innerText = `${cart[product.productId].quantity}개`;
            }

            updateTotal(product.price);
        }

        // 총금액 업데이트
        function updateTotal(price) {
            total += price;
            document.getElementById('total-price').innerText = `${total}원`;
        }
    };
</script>

</body>
</html>
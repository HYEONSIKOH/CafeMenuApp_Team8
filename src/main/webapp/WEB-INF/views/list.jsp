<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background: #F9F9F9; }
        .card { margin: auto; max-width: 950px; width: 90%; box-shadow: 0 6px 20px rgba(0, 0, 0, 0.15); border-radius: 1rem; border: none; }
        .summary { background-color: #fff; border-radius: 1rem; padding: 4vh; color: #333; }
        .products { width: 100%; }
        .products .price, .products .action { line-height: 38px; }
        .error-message { color: red; font-size: 0.9rem; }
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
                <!-- 동적으로 상품 항목이 추가됩니다. -->
            </ul>
            <div id="error-message" class="error-message mt-3"></div>
        </div>
        <!-- 요약 섹션 -->
        <div class="col-md-4 summary">
            <h5><b>주문 목록</b></h5>
            <hr>
            <div id="summary-list">
                <!-- 상품 요약 정보가 동적으로 추가됩니다. -->
            </div>
            <hr>
            <div class="d-flex justify-content-between">
                <h5>총금액</h5>
                <h5 id="total-price">0원</h5>
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
            <button id="checkout-button" class="btn btn-dark w-100 mt-3">결제하기</button>
        </div>
    </div>
</div>
<script>
    const URL = "http://220.76.86.103:8080"
    window.onload = function () {
        const API_URL =  URL + "/api/coffeeList"; // 실제 API 경로로 변경 필요
        const productList = document.getElementById("product-list");
        const summaryList = document.getElementById("summary-list");
        const totalPriceElement = document.getElementById("total-price");
        const errorMessage = document.getElementById("error-message");
        let cart = {}; // 장바구니 저장소
        let total = 0;
        // 상품 목록 가져오기
        fetch(API_URL)
            .then(response => {
                if (!response.ok) throw new Error("상품 데이터를 불러오는 데 실패했습니다.");
                return response.json();
            })
            .then(products => {
                renderProductList(products);
            })
            .catch(error => {
                errorMessage.textContent = error.message;
            });
        // 상품 목록 렌더링
        function renderProductList(products) {
            productList.innerHTML = ""; // 초기화
            if (products.length === 0) {
                productList.innerHTML = '<li class="list-group-item">상품이 없습니다.</li>';
                return;
            }
            products.forEach(product => {
                const listItem = document.createElement("li");
                listItem.className = "list-group-item d-flex align-items-center mt-2";
                listItem.innerHTML = `
                    <div class="col-3">
                        <img class="img-fluid" style="width: 80px; height: 80px; border-radius: 5px; margin-right: 10px;" src="`+ product['img'] +`" alt="`+ product['productNm'] +`">
                    </div>
                    <div class="col-5">
                        <b>`+ product['productNm'] +`</b>
                        <p>`+ product['price'] +`원</p>
                    </div>
                    <div class="col-4 text-end">
                        <button class="btn btn-outline-dark btn-sm increase" data-id="`+ product['productId'] +`" data-name="`+ product['productNm'] +`" data-price="`+ product['price'] +`">추가</button>
                        <button class="btn btn-outline-dark btn-sm decrease" data-id="`+ product['productId'] +`" data-name="`+ product['productNm'] +`" data-price="`+ product['price'] +`">빼기</button>
                    </div>
                `;
                productList.appendChild(listItem);
                listItem.querySelector(".increase").addEventListener("click", () => {
                    addToCart(product);
                });
                listItem.querySelector(".decrease").addEventListener("click", () => {
                    removeFromCart(product);
                });
            });
        }
        // 장바구니에 상품 추가
        function addToCart(product) {
            if (!cart[product['productId']]) {
                cart[product['productId']] = { ...product, quantity: 0 };
            }
            cart[product['productId']].quantity++;
            updateSummary();
        }
        // 장바구니에 상품 빼기
        function removeFromCart(product) {
            if (cart[product['productId']].quantity===1) {
                delete cart[product['productId']];
            }
            else{
                cart[product['productId']].quantity--;
            }
            updateSummary();
        }
        // 요약 섹션 업데이트
        function updateSummary() {
            summaryList.innerHTML = ""; // 초기화
            total = 0; // 총금액 초기화
            Object.values(cart).forEach(item => {
                if (item.quantity > 0) {
                    const summaryItem = document.createElement("div");
                    summaryItem.className = "d-flex justify-content-between mb-2";
                    summaryItem.innerHTML = `
                        <span>`+ item['productNm']+`(`+ item['quantity'] +`개)</span>
                        <span>`+ item['price'] * item['quantity'] +`원</span>
                    `;
                    summaryList.appendChild(summaryItem);
                    total += item.price * item.quantity;
                }
            });
            totalPriceElement.textContent = total+`원`;
            if (Object.keys(cart).length === 0) {
                summaryList.innerHTML = '<p>장바구니가 비었습니다.</p>';
            }
        }
        // 결제 버튼 클릭 이벤트
        document.querySelector('.btn-dark').addEventListener("click", () => {
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
                orderData.items.push({
                    productId: productId,
                    quantity: cart[productId].quantity
                });
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
            console.log(orderData);
            orderRequest.open("POST", URL + "/order/create", true);  // 실제 API 경로로 수정
            orderRequest.setRequestHeader("Content-Type", "application/json");
            orderRequest.send(JSON.stringify(orderData));
        });
    };
</script>
</body>
</html>
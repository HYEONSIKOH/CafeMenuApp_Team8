<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Dynamic Product List</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.0/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-KyZXEAg3QhqLMpG8r+8fhAXLRk2vvoC2f3B09zVXn8CA5QIVfZOJ3BCsw2P0p/We" crossorigin="anonymous">
    <style>
        body {
            background: #ddd;
        }

        .card {
            margin: auto;
            max-width: 950px;
            width: 90%;
            box-shadow: 0 6px 20px 0 rgba(0, 0, 0, 0.19);
            border-radius: 1rem;
            border: transparent;
        }

        .summary {
            background-color: #ddd;
            border-top-right-radius: 1rem;
            border-bottom-right-radius: 1rem;
            padding: 4vh;
            color: rgb(65, 65, 65);
        }

        @media (max-width: 767px) {
            .summary {
                border-top-right-radius: unset;
                border-bottom-left-radius: 1rem;
            }
        }

        .row {
            margin: 0;
        }

        img {
            width: 3.5rem;
        }

        hr {
            margin-top: 1.25rem;
        }
    </style>
</head>
<body class="container-fluid">
<div class="row justify-content-center m-4">
    <h1 class="text-center">Product List</h1>
</div>
<div class="card">
    <div class="row">
        <!-- Left: Product List -->
        <div class="col-md-8 mt-4 d-flex flex-column align-items-start p-3 pt-0">
            <h5 class="flex-grow-0"><b>상품 목록</b></h5>
            <ul class="list-group products"></ul>
        </div>

        <!-- Right: Summary -->
        <div class="col-md-4 summary p-4">
            <h5><b>Summary</b></h5>
            <hr>
            <div class="product-summary"></div>
            <div class="row pt-2 pb-2 border-top">
                <h5 class="col">총금액</h5>
                <h5 class="col text-end total-price">0원</h5>
            </div>
            <button class="btn btn-dark col-12">결제하기</button>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        fetchProducts();

        function fetchProducts() {
            const xhr = new XMLHttpRequest();
            xhr.open('GET', 'http://localhost:8080/api/coffeeList'); // 서버의 상품 API 경로
            xhr.onreadystatechange = function () {
                if ((xhr.readyState === XMLHttpRequest.DONE) && xhr.status === 200) {
                    const products = JSON.parse(xhr.responseText);
                    renderProducts(products);
                }
            };
            xhr.send();
        }

        function renderProducts(products) {
            const productContainer = document.querySelector('.products');

            productContainer.innerHTML = ''; // 초기화

            products.forEach(product => {
                const productItem = document.createElement('li');
                productItem.className = 'list-group-item d-flex mt-2';
                productItem.innerHTML = `
            <div class="col-2">
              <img class="img-fluid" src="`+ product['img'] +`" alt="`+ product['productNm'] +`">
            </div>
            <div class="col">
              <div class="row text-muted">`+ product['description'] +`</div>
              <div class="row">`+ product['productNm'] +`</div>
            </div>
            <div class="col text-center price">`+ product['price'] +`원</div>
            <div class="col text-end action">
              <button class="btn btn-small btn-outline-dark" data-product-id=" `+ product['productId'] +` ">추가</button> <!-- product_id에서 productId로 수정 -->
            </div>
          `;
                productContainer.appendChild(productItem);
            });

            attachEventListeners();
        }

        function attachEventListeners() {
            document.querySelectorAll('.action button').forEach(button => {
                button.addEventListener('click', function () {
                    const productId = this.getAttribute('data-product-id');
                    addProductToSummary(productId);
                });
            });
        }

        function addProductToSummary(productId) {
            const xhr = new XMLHttpRequest();
            xhr.open('GET', `/api/product/${productId}`); // 상품 상세 정보 API 경로
            xhr.onreadystatechange = function () {
                if (xhr.readyState === XMLHttpRequest.DONE && xhr.status === 200) {
                    const product = JSON.parse(xhr.responseText);
                    updateSummary(product);
                }
            };
            xhr.send();
        }

        function updateSummary(product) {
            const summaryContainer = document.querySelector('.product-summary');
            let summaryItem = summaryContainer.querySelector(`[data-product-id="${product.product_id}"]`);
            if (summaryItem) {
                const quantityBadge = summaryItem.querySelector('.badge');
                quantityBadge.innerText = parseInt(quantityBadge.innerText) + 1;
            } else {
                const newItem = document.createElement('div');
                newItem.className = 'row';
                newItem.setAttribute('data-product-id', product.id);
                newItem.innerHTML = `
            <h6 class="p-0">${product.product_nm} <span class="badge bg-dark">1개</span></h6>
          `;
                summaryContainer.appendChild(newItem);
            }

            updateTotalPrice(product.price);
        }

        function updateTotalPrice(price) {
            const totalPriceElement = document.querySelector('.total-price');
            const currentTotal = parseInt(totalPriceElement.innerText.replace('원', '')) || 0;
            totalPriceElement.innerText = (currentTotal + price) + '원';
        }
    });
</script>
</body>
</html>
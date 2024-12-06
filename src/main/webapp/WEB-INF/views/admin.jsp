<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!doctype html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
        body {
            background: #ddd;
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
        }

        .container {
            max-width: 950px;
            margin: auto;
            padding: 20px;
        }

        .card {
            background: white;
            border-radius: 10px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.19);
            padding: 20px;
            margin-bottom: 20px;
        }

        .title {
            text-align: center;
            margin: 20px 0;
        }

        .products {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .product-item {
            display: flex;
            align-items: center;
            background: #f9f9f9;
            margin-bottom: 10px;
            padding: 10px;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }

        .product-item img {
            width: 50px;
            height: 50px;
            border-radius: 5px;
            margin-right: 10px;
        }

        .product-state {
            border: 2px solid #565555;
            border-radius: 8px;
            padding: 4px 8px;
            font-size: 0.7rem;
            color: #565555;
            background-color: #f9f9f9;
            margin-right: 10px;
            width: 38.4px;
            height: 13.5px;
            text-align: center;
        }

        .product-info {
            flex-grow: 1;
        }

        .product-info .description {
            color: #888;
            font-size: 14px;
            margin-bottom: 5px;
        }

        .product-info .name {
            font-size: 16px;
            font-weight: bold;
        }

        .product-price {
            margin-right: 20px;
            font-size: 16px;
            font-weight: bold;
        }

        .product-action button {
            background: none;
            border: 1px solid #333;
            padding: 5px 10px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
        }

        .product-action button:hover {
            background: #333;
            color: white;
        }

        .change-state {
            text-align: right;
            margin-top: 20px;
        }

        .change-state button {
            background: black;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        .change-state button:hover {
            background: #444;
        }
    </style>
    <title>Admin Page</title>
</head>

<body>
<div class="container">
    <div class="title">
        <h1>Admin Page</h1>
    </div>

    <div class="card">
        <h2>오늘 배송 목록</h2>
        <p>당일 오후 2시 이후의 주문은 다음날 배송을 시작합니다.</p>

        <ul class="products">
            <li class="product-item">
                <img src="https://i.imgur.com/HKOFQYa.jpeg" alt="커피콩">
                <div class="product-info">
                    <div class="description">커피콩</div>
                    <div class="name">Columbia Nariñó</div>
                </div>
                <div class="product-price">5000원</div>
                <div class="product-action">
                    <button>추가</button>
                </div>
            </li>
        </ul>
    </div>

    <div class="change-state">
        <button onclick="changeState()">배송 상태 변경</button>
    </div>
</div>

<script>
    const URL = "http://220.76.86.103:8080"

    // Ajax 요청 예제
    function showList() {
        const API_URL = URL + "/admin/todayOrderList";

        fetch(API_URL)
            .then(response => response.json())
            .then(data => {
                showListHTML(data);
            })
            .catch(error => {
                console.error("Error fetching data:", error);
                alert("리스트를 불러오는 중 오류가 발생했습니다.");
            });
    }

    function showListHTML(testData) {
        // 데이터 렌더링
        const productContainer = document.querySelector('.products');
        productContainer.innerHTML = ''; // 기존 리스트 초기화

        testData.forEach(order => {
            const productLength = order.orderItems.length - 1;
            if (productLength >= 0) {
                const costomerMail = order.mail;
                const product = order.orderItems[0]['product'];
                const productImg = product.img;
                const orderId = order['orderId'];
                var productNm = product.productNm;
                const state = order.orderStatus === "PENDING" ? "배송 전" : "배송 중.."
                var sumPrice = 0;
                const checkboxeAble = order.orderStatus !== "PENDING" ? 'disabled' : '';


                for (var i = 0; i < productLength + 1; i++) {
                    sumPrice += order.orderItems[i]['product'].price * order.orderItems[i].quantity;
                }

                if (productLength > 0) {
                    productNm += ' 외 ' + productLength + '건';
                }

                const productItem = `
        <li class="product-item">
          <img src="`+ productImg + `" alt="productNm">
          <div class="product-info">
            <div class="description">`+ productNm + `</div>
            <div class="name">`+ costomerMail + `<a style="font-weight: normal;">님이 주문</a></div>
          </div>
          <div class="product-price">총 `+ sumPrice + `원</div>
          <div class="product-state">`+ state + `</div>
          <div class="product-action">
            <input type="checkbox" id="`+ orderId + `"` + checkboxeAble + `>
          </div>
        </li>`;
                productContainer.innerHTML += productItem;
            }

        });
    }

    function changeState() {
        const checkedOrders = [];
        const checkboxes = document.querySelectorAll('.product-action input[type="checkbox"]');

        checkboxes.forEach(checkbox => {
            if (checkbox.checked) {
                const orderId = checkbox.id;  // 체크박스의 ID에서 orderId를 추출
                checkedOrders.push(orderId);
                console.log('체크된 주문 ID:', checkedOrders);
            }
        });

        if (checkedOrders.length == 0) {
            alert('변경할 주문을 선택해주세요.');
            return;
        }

        // 서버로 POST 요청 보내기
        fetch( URL + "/admin/changeOrderStatus", {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ orderIds: checkedOrders })
        })
            .then(response => {
                if (!response.ok) {
                    throw new Error('서버 응답에 실패했습니다.');
                }
            })
            .then(data => {
                alert('배송 상태가 성공적으로 변경되었습니다.');
                window.location.reload();
            })
            .catch(error => {
                console.error('오류 발생:', error);
                alert('배송 상태 변경 중 오류가 발생했습니다.');
            });
    }

    window.onload = showList;
</script>
</body>

</html>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Product Grid</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            display: flex;
        }
        .grid-container {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
            padding: 20px;
            width: 70%;
        }
        .grid-item {
            border: 1px solid #ccc;
            border-radius: 5px;
            padding: 10px;
            text-align: center;
            background-color: #f9f9f9;
        }
        .grid-item img {
            max-width: 100%;
            height: auto;
        }
        .grid-item p {
            margin: 10px 0 0;
        }
        .selection-list {
            width: 30%;
            padding: 20px;
            border-left: 1px solid #ccc;
            display: flex;
            flex-direction: column;
        }
        .selection-list ul {
            list-style-type: none;
            padding: 0;
        }
        .selection-list li {
            margin: 5px 0;
        }
        .done-button {
            margin-top: auto;
            padding: 10px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .done-button:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>
<div class="grid-container">
    <div class="grid-item" data-name="Columbia Nariño">
        <img src="./upload/img.jpg" alt="Columbia Nariño">
        <p>Columbia Nariño</p>
    </div>
    <div class="grid-item" data-name="Brazil Serra Do Caparaó">
        <img src="./upload/img.jpg" alt="Brazil Serra Do Caparaó">
        <p>Brazil Serra Do Caparaó</p>
    </div>
    <div class="grid-item" data-name="Columbia Quindío">
        <img src="./upload/img.jpg" alt="Columbia Quindío">
        <p>Columbia Quindío</p>
    </div>
    <div class="grid-item" data-name="Ethiopia Sidamo">
        <img src="./upload/img.jpg" alt="Ethiopia Sidamo">
        <p>Ethiopia Sidamo</p>
    </div>
</div>
<div class="selection-list">
    <h3>Selected Products</h3>
    <ul id="selected-items"></ul>
    <button class="done-button" onclick="completeSelection()">Done</button>
</div>

<script>
    document.querySelectorAll('.grid-item').forEach(item => {
        item.addEventListener('click', () => {
            const productName = item.getAttribute('data-name');
            const selectedItems = document.getElementById('selected-items');

            // Add the product to the selected list
            const listItem = document.createElement('li');
            listItem.textContent = productName;
            selectedItems.appendChild(listItem);
        });
    });

    function completeSelection() {
        const selectedItems = Array.from(document.querySelectorAll('#selected-items li')).map(li => li.textContent);

        // Send selected items to the server via AJAX
        const xhr = new XMLHttpRequest();
        xhr.open('POST', 'processSelection.jsp', true);
        xhr.setRequestHeader('Content-Type', 'application/json');
        xhr.onload = () => {
            if (xhr.status === 200) {
                // Redirect to another page
                window.location.href = 'successPage.jsp';
            } else {
                alert('Error processing selection');
            }
        };
        xhr.send(JSON.stringify({ selectedItems }));
    }
</script>
</body>
</html>
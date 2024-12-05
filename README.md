## 🎤 프로젝트 소개

·  [데브코스] Team8 1차 프로젝트 - 카페 메뉴 관리 서비스 제작 (CRUD)

·  인원: 5명

·  개발기간: 24.12.02 ~ 2024.12.05

<br/><br/>
## 🧾 Main 페이지
<img width="600" alt="MainPage" src="https://github.com/user-attachments/assets/a354fc7e-de0f-47f3-85a1-e965d6ea3d3e">

#### JSP
- 상품 리스트를 AJAX를 이용해 API 통신으로 상품 목록을 가져옴
- 장바구니에 담긴 상품들을 Email, Address, Postal과 함께 AJax로 보내서 결제기능 구현

#### Spring Boot
- Spring JPA를 사용
- DB의 상품정보들을 List로 가져온 후, @RestController로 Get 방식으로 Json 형식으로 보내주는 API
- JSP에서 요청한 Order를 DB에 저장
- 회원은 Email로 구분

<br>

## 🔐 Admin 페이지
<img width="600" alt="AdminPage" src="https://github.com/user-attachments/assets/26dab948-2e12-4e1f-96ea-ffbce4851843">

#### JSP
- 오늘 배송 목록을 출력
- 배송 상태를 PENDING -> IN_TRANSIT으로 변경 요청하는 버튼

#### Spring Boot
- 배송목록을 전날 14시 ~ 당일 14시까지의 주문목록들만 Get 방식으로 JSON 형식으로 보내주는 API
- 배송 상태를 변경 희망하는 OrderId 값들을 Post 방식으로 받은 후, PENDING -> IN_TRANSIT으로 변경하는 기능 구현

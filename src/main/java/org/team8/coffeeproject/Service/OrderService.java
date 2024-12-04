package org.team8.coffeeproject.Service;

import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.team8.coffeeproject.Dto.OrderRes;
import org.team8.coffeeproject.Entity.OrderItem;
import org.team8.coffeeproject.Entity.OrderList;
import org.team8.coffeeproject.Entity.Product;
import org.team8.coffeeproject.Entity.User;
import org.team8.coffeeproject.Respository.OrderItemRepository;
import org.team8.coffeeproject.Respository.OrderListRepository;
import org.team8.coffeeproject.Respository.ProductRepository;
import org.team8.coffeeproject.Respository.UserRepository;

import java.util.Map;

@Service
public class OrderService {
    @Autowired
    private UserRepository userRepository;

    @Autowired
    private OrderListRepository orderListRepository;

    @Autowired
    private OrderItemRepository orderItemRepository;

    @Autowired
    private ProductRepository productRepository;

    @Transactional
    public ResponseEntity<?> createOrder(OrderRes resDto) {

        // Email 기준으로 User 가입 확인 및 정보 조회
        String email = resDto.getEmail();
        String address = resDto.getAddress();
        String postal = resDto.getPostal();

        User userInfo = new User();
        userInfo.setEmail(email);
        userInfo.setAddress(address);
        userInfo.setPostal(postal);

//        System.out.println("Email: " + email);
//        System.out.println("Address: " + address);
//        System.out.println("Postal: " + postal);
//        System.out.println("Items: " + lists);

        User user = userRepository.findByEmail(userInfo.getEmail());
        if (user == null) {

            user = new User();
            user.setEmail(userInfo.getEmail());
            user.setAddress(userInfo.getAddress());
            user.setPostal(userInfo.getPostal());
            userRepository.save(user);
        }

        // Order(주문) 생성
        OrderList orderList = new OrderList();
        orderList.setUser(user);
        orderListRepository.save(orderList);

        // Order(주문)에 대한 주문 상품 등록
        for (Map<String, Object> item : resDto.getItems()) {
            String product_nm = (String) item.get("product_nm");
            Integer quantity = (Integer) item.get("quantity");

            // System.out.println("product_nm : " + product_nm);

            Product product = productRepository.findByProductNm(product_nm);
            if (product == null) {
                return ResponseEntity.badRequest().body("[에러]: " + "No Product Id");
            }

            OrderItem orderItem = new OrderItem();
            orderItem.setProduct(product);
            orderItem.setOrderList(orderList);
            orderItem.setQuantity(quantity != null ? quantity : 1);
            orderItemRepository.save(orderItem);
        }

        return ResponseEntity.ok("success");
    }
}

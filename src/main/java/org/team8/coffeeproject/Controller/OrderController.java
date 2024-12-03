package org.team8.coffeeproject.Controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.http.ResponseEntity;
import org.team8.coffeeproject.Dto.OrderResDto;
import org.team8.coffeeproject.Entity.User;
import org.team8.coffeeproject.Service.OrderService;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/order")
public class OrderController {

    @Autowired
    private OrderService orderService;


    // {"고양이똥커피" : 2}, {"고양이 똥같은커피" : 30억개}
    @PostMapping("/create")
    public ResponseEntity<String> createOrder(@RequestBody OrderResDto requestData) {
//        try {
//            // System.out.println(requestData);
//            orderService.createOrder(requestData.getItems());
//            return ResponseEntity.ok("success");
//        } catch (Exception e) {
//            return ResponseEntity.badRequest().body("[에러]: " + e.getMessage());
//        }

        orderService.createOrder(requestData);
    }
}

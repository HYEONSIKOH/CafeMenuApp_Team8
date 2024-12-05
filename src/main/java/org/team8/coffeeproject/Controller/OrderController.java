package org.team8.coffeeproject.Controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.http.ResponseEntity;
import org.team8.coffeeproject.Dto.OrderRes;
import org.team8.coffeeproject.Service.OrderService;

@RestController
@RequestMapping("/order")
@CrossOrigin(origins = "http://221.149.143.92:8080/")
public class OrderController {

    @Autowired
    private OrderService orderService;

    // {"고양이똥커피" : 2}, {"고양이 똥같은커피" : 30억개}
    @PostMapping("/create")
    public ResponseEntity<?> createOrder(@RequestBody OrderRes requestData) {
        return orderService.createOrder(requestData);
    }
}

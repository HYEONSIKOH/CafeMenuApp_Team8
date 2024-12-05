package org.team8.coffeeproject.Controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.team8.coffeeproject.Dto.ProductListRes;
import org.team8.coffeeproject.Service.ProductService;

import java.util.List;

//@Tag(name = "판매 상품 목록 조회")
@RestController
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class ListController {

    private final ProductService productService;

    @GetMapping(("/api/coffeeList"))
    public ResponseEntity<?> coffeeList() {

        List<ProductListRes> productItems = productService.list();
        return ResponseEntity.ok().body(productItems);
    }
}

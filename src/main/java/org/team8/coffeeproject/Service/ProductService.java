package org.team8.coffeeproject.Service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.team8.coffeeproject.Dto.ProductListRes;
import org.team8.coffeeproject.Respository.ProductRepository;

import java.util.List;
import java.util.stream.Collectors;

@RequiredArgsConstructor
@Service
public class ProductService {

    private final ProductRepository productRepository;

    public List<ProductListRes> list(){

        List<ProductListRes> productList = productRepository.findAll()
                .stream()
                .map(product->ProductListRes.builder()
                        .productId(product.getId())
                        .productNm(product.getProductNm())
                        .price(product.getPrice())
                        .description(product.getDescription())
                        .img(product.getImg())
                        .build()
                ).collect(Collectors.toList());

        return productList;
    }

}

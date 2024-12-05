package org.team8.coffeeproject.Dto;


import lombok.*;

@Data
@Builder
public class ProductListRes {
    private Long productId;
    private String productNm;
    private int price;
    private String img;
    private String description;
}

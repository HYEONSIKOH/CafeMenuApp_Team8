package org.team8.coffeeproject.Dto;


import lombok.*;

@Getter
@Setter
@Builder
public class ProductListRes {
    private Long productId;
    private String productNm;
    private int price;
    private String img;
    private String description;
}

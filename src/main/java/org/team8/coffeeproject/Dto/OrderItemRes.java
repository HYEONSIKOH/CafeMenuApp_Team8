package org.team8.coffeeproject.Dto;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class OrderItemRes {
    private int quantity;
    private ProductListRes product;
}
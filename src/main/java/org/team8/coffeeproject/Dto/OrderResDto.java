package org.team8.coffeeproject.Dto;

import lombok.Data;

import java.util.List;
import java.util.Map;

@Data
public class OrderResDto {
    String email;
    String postal;
    String address;
    List<Map<String, Object>> items;
}

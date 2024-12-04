package org.team8.coffeeproject.Entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.ArrayList;
import java.util.List;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Product {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;
    @Column(nullable = false, length = 100)
    private String productNm;
    @Column(nullable = false, length = 16)
    private int price;
    @Column(columnDefinition = "VARCHAR(255) DEFAULT '기본이미지'")
    private String img;
    @Column
    private String description;

    @OneToMany(fetch = FetchType.LAZY, mappedBy = "product")
    private List<OrderItem> orderItems = new ArrayList<>();

}

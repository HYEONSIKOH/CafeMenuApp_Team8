package org.team8.coffeeproject.Entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

// 한 주문에 포함되어 있는 상품들 리스트
@Entity
@Getter
@Setter
public class OrderItem {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    @Column(nullable = false)
    private int quantity;

    @ManyToOne(fetch = FetchType.LAZY)
    private OrderList orderList;

    @ManyToOne(fetch = FetchType.LAZY)
    private Product product;
}

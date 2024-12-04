package org.team8.coffeeproject.Entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "OrderList")
public class OrderList {
    @Id
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    private User user;

    @CreationTimestamp
    private Date createdAt;

    private String state;

    @OneToMany(mappedBy = "orderList")
    private List<OrderItem> orderItems = new ArrayList<>();
}

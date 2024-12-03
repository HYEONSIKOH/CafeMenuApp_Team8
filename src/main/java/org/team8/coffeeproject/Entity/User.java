package org.team8.coffeeproject.Entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

@Entity
@Getter @Setter
public class User {
    @Id
    private Long id;

    @Column(length = 60, nullable = false)
    private String email;

    @Column(length = 140,nullable = false)
    private String address;

    @Column(length = 6,nullable = false)
    private String postal;

    @OneToMany(mappedBy = "user")
    private List<OrderList> orderLists = new ArrayList<>();


    public User(Long userId, String email, String address, String postal) {
        this.id = userId;
        this.email = email;
        this.address = address;
        this.postal = postal;
    }

    public User() {

    }
}

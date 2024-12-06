package org.team8.coffeeproject.Respository;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.springframework.stereotype.Repository;
import org.team8.coffeeproject.Entity.OrderItem;

@Repository
public class OrderItemRepository {

    @PersistenceContext
    private EntityManager em;

    public void save(OrderItem orderItem) {
        em.persist(orderItem);
    }
}

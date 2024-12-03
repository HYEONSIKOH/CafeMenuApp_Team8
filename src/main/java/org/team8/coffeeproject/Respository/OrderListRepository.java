package org.team8.coffeeproject.Respository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.team8.coffeeproject.Entity.OrderList;

@Repository
public interface OrderListRepository extends JpaRepository<OrderList, Long> {
}
package org.team8.coffeeproject.Respository;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.springframework.stereotype.Repository;
import org.team8.coffeeproject.Entity.OrderList;
import org.team8.coffeeproject.Enum.DeliveryState;

import java.util.Date;
import java.util.List;
import java.util.Optional;

@Repository
public class OrderListRepository {
    @PersistenceContext
    private EntityManager em;

    public Optional<OrderList> findById(Long orderId) {
        OrderList orderList = em.find(OrderList.class, orderId);

        return Optional.ofNullable(orderList);
    }

    public Integer updateStateByIds(DeliveryState state, List<Long> orderIds) {
        Integer result = em.createQuery("UPDATE OrderList o SET o.state = :state WHERE o.id IN :orderIds")
                .setParameter("state", state)
                .setParameter("orderIds", orderIds)
                .executeUpdate();

        return result;
    }

    public List<OrderList> findAll(){
        List<OrderList> orderLists = em.createQuery("select o from OrderList o", OrderList.class)
                .getResultList();

        return orderLists;
    }

    public List<OrderList> findOrderList14And14(Date startTime, Date endTime) {
        List<OrderList> result = em.createQuery("SELECT o FROM OrderList o WHERE o.createdAt BETWEEN :startTime AND :endTime")
                .setParameter("startTime", startTime)
                .setParameter("endTime", endTime)
                .getResultList();

        return result;
    }

    public void save (OrderList orderList) {
        em.persist(orderList);
    }
}

package org.team8.coffeeproject.Respository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.team8.coffeeproject.Entity.OrderList;
import org.team8.coffeeproject.Enum.DeliveryState;

import java.util.Date;
import java.util.List;
import java.util.Optional;

@Repository
public interface OrderListRepository extends JpaRepository<OrderList, Long> {
    Optional<OrderList> findById(Long orderId);

    @Modifying
    @Query("UPDATE OrderList o SET o.state = :state WHERE o.id IN :orderIds")
    int updateStateByIds(@Param("state") DeliveryState state, @Param("orderIds") List<Long> orderIds);

    List<OrderList> findAll();

    // 어제 14시부터 오늘 14시까지의 범위로 OrderList 조회
    @Query("SELECT o FROM OrderList o WHERE o.createdAt BETWEEN :startTime AND :endTime")
    List<OrderList> findOrderList14And14(
            @Param("startTime") Date startTime,
            @Param("endTime") Date endTime
    );
}
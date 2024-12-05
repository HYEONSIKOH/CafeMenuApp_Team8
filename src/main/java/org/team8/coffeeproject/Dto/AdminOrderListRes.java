package org.team8.coffeeproject.Dto;

import lombok.Builder;
import lombok.Data;
import org.team8.coffeeproject.Enum.DeliveryState;

import java.util.Date;
import java.util.List;

@Builder
@Data
public class AdminOrderListRes {
    private Long orderId;
    private String mail;
    private DeliveryState orderStatus;
    private Date createdAt;
    private List<OrderItemRes> orderItems;
}

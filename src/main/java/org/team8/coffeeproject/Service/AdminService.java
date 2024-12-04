package org.team8.coffeeproject.Service;


import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.team8.coffeeproject.Dto.TodayOrderListRes;
import org.team8.coffeeproject.Enum.DeliveryState;
import org.team8.coffeeproject.Entity.OrderList;
import org.team8.coffeeproject.Enum.DeliveryState;
import org.team8.coffeeproject.Respository.OrderListRepository;

import java.util.List;

@RequiredArgsConstructor
@Service
public class AdminService {

    private final OrderListRepository orderListRepository;

    @Transactional
    public ResponseEntity<?> updateStatus(TodayOrderListRes todayOrderListRes){
        List<Long> orderIds = todayOrderListRes.getOrderIds();

        try {
            orderListRepository.updateStateByIds(DeliveryState.IN_TRANSIT, orderIds);
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }

        return ResponseEntity.ok().build();
    }

    @Transactional
    public ResponseEntity<?> updateState(Long orderId){

        OrderList orderList = orderListRepository.findById(orderId)
                .orElseThrow(()-> new IllegalArgumentException("OrderList Not Found"));

        orderList.setState(DeliveryState.IN_TRANSIT);

        return ResponseEntity.ok().build();
    }
}

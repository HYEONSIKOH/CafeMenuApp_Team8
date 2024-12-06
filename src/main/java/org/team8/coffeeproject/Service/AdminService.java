package org.team8.coffeeproject.Service;


import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.team8.coffeeproject.Dto.AdminOrderListRes;
import org.team8.coffeeproject.Dto.OrderItemRes;
import org.team8.coffeeproject.Dto.ProductListRes;
import org.team8.coffeeproject.Dto.TodayOrderListRes;
import org.team8.coffeeproject.Entity.OrderItem;
import org.team8.coffeeproject.Entity.Product;
import org.team8.coffeeproject.Entity.User;
import org.team8.coffeeproject.Enum.DeliveryState;
import org.team8.coffeeproject.Entity.OrderList;
import org.team8.coffeeproject.Respository.OrderListRepository;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
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

    @Transactional
    public ResponseEntity<?> list() {

        // 어제 14시 ~ 오늘 14시 Data 변수
        Calendar calendar = Calendar.getInstance();

        calendar.add(Calendar.DAY_OF_MONTH, -1);
        calendar.set(Calendar.HOUR_OF_DAY, 14);
        calendar.set(Calendar.MINUTE, 0);
        calendar.set(Calendar.SECOND, 0);
        calendar.set(Calendar.MILLISECOND, 0);
        Date startTime = calendar.getTime();

        calendar.set(Calendar.DAY_OF_MONTH, Calendar.getInstance().get(Calendar.DAY_OF_MONTH)); // 오늘
        Date endTime = calendar.getTime();
        // ================================

        List<OrderList> orderLists = orderListRepository.findOrderList14And14(startTime, endTime);
        List<AdminOrderListRes> adminOrderListResList = new ArrayList<>();

        for (OrderList orderList : orderLists) {
            User user = orderList.getUser();

            // 배송할 상품들 정보 담기
            List<OrderItemRes> orderItemDtos = new ArrayList<>();
            for (OrderItem orderItem : orderList.getOrderItems()) {
                Product product = orderItem.getProduct();
                ProductListRes productDto = null;
                if (product != null) {
                    productDto = ProductListRes.builder()
                            .productId(product.getId())
                            .productNm(product.getProductNm())
                            .price(product.getPrice())
                            .img(product.getImg())
                            .description(product.getDescription())
                            .build();
                }

                OrderItemRes orderItemDto = OrderItemRes.builder()
                        .quantity(orderItem.getQuantity())
                        .product(productDto)
                        .build();

                orderItemDtos.add(orderItemDto);
            }

            // Order에 대한 DTO 초기화
            AdminOrderListRes adminOrderListRes = AdminOrderListRes.builder()
                    .orderId(orderList.getId())
                    .mail(user.getEmail())
                    .orderStatus(orderList.getState())
                    .createdAt(orderList.getCreatedAt())
                    .orderItems(orderItemDtos)
                    .build();

            adminOrderListResList.add(adminOrderListRes);
        }

        return ResponseEntity.ok().body(adminOrderListResList);
    }
}

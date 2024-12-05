package org.team8.coffeeproject.Dto;

import lombok.Data;

import java.util.List;

@Data
public class TodayOrderListRes {
    List<Long> OrderIds;

    @Override
    public String toString() {
        String str = "";

        for (Long orderId : OrderIds) {
            str += orderId + " ";
        }

        return str;
    }
}

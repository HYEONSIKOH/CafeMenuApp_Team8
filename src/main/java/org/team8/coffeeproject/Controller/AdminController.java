package org.team8.coffeeproject.Controller;


import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;
import org.team8.coffeeproject.Dto.TodayOrderListRes;
import org.team8.coffeeproject.Service.AdminService;


@RestController
@RequiredArgsConstructor
public class AdminController {

    private final AdminService adminService;

    @PostMapping("/admin/changeOrderStatus")
    public ResponseEntity<?> changeOrderStatus(TodayOrderListRes todayOrderListRes) {
        return adminService.updateStatus(todayOrderListRes);
    }

}

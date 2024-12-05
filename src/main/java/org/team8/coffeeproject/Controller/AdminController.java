package org.team8.coffeeproject.Controller;


import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.team8.coffeeproject.Dto.AdminOrderListRes;
import org.team8.coffeeproject.Dto.TodayOrderListRes;
import org.team8.coffeeproject.Service.AdminService;

import java.util.List;


@RestController
@RequiredArgsConstructor
@RequestMapping("/admin")
@CrossOrigin(origins = "*")
public class AdminController {

    private final AdminService adminService;

    @PostMapping("/changeOrderStatus")
    public ResponseEntity<?> changeOrderStatus(@RequestBody TodayOrderListRes todayOrderListRes) {
        System.out.println(todayOrderListRes.toString());
        return adminService.updateStatus(todayOrderListRes);
    }

    @GetMapping("/todayOrderList")
    public ResponseEntity<?> getAdminList() { return adminService.list(); }

}

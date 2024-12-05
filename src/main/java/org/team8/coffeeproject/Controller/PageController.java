package org.team8.coffeeproject.Controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.ui.Model;

@Controller
@CrossOrigin(origins = "http://221.149.143.92:8080/")
public class PageController {
    @RequestMapping("/")
    public String showList(Model model) {
        return "list";  // list.jsp를 반환
    }

    @RequestMapping("/order")
    public String showOrder(Model model) {
        return "order";  // order.jsp를 반환
    }

    @RequestMapping("/order_ok")
    public String showOrderOk(Model model) {
        return "order_ok";  // order_ok.jsp를 반환
    }

    @RequestMapping("/admin")
    public String showTestPage(Model model) {
        return "admin";  // coffee.jsp 반환를 반환
    }
}
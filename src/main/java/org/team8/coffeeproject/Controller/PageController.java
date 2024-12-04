package org.team8.coffeeproject.Controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.ui.Model;

@Controller
public class PageController {
    @RequestMapping("/list")
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

    @RequestMapping("/test")
    public String showTestPage(Model model) {
        return "coffee";  // coffee.jsp 반환를 반환
    }
}
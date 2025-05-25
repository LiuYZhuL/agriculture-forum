package com.agriculture.controller;

import com.agriculture.model.dto.LoginUser;
import com.agriculture.model.po.User;
import com.agriculture.service.impl.UserServiceImpl;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import javax.validation.Valid;
import java.util.Objects;

@Controller
@RequestMapping("/api/user")
public class UserController {
    @Autowired
    private UserServiceImpl userService;
    @GetMapping("/login")
    public ModelAndView login() {
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("redirect:/api/user/login");
        return modelAndView;
    }
    @PostMapping("/login")
    public ModelAndView login(@Valid LoginUser loginUser,
                              BindingResult bindingResult,
                              HttpSession session){
        ModelAndView modelAndView = new ModelAndView();
        if (bindingResult.hasErrors()) {
            modelAndView.setViewName("redirect:/api/user/login");
            String errorMsg = Objects.requireNonNull(bindingResult.getFieldError()).getDefaultMessage();
            modelAndView.addObject("error", errorMsg);
            modelAndView.addObject("loginUser", loginUser);
            return modelAndView;
        }
        User user;
        try {
            user = userService.login(loginUser);
        } catch (RuntimeException runtimeException) {
            modelAndView.setViewName("redirect:/api/user/login");
            modelAndView.addObject("error", runtimeException.getMessage());
            modelAndView.addObject("loginUser", loginUser);
            return modelAndView;
        }
        session.setAttribute("user", user);
        modelAndView.setViewName("redirect:/api/dashboard");
        return modelAndView;
    }
}

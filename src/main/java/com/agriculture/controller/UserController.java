package com.agriculture.controller;

import com.agriculture.model.dto.LoginUser;
import com.agriculture.model.dto.RegisterUser;
import com.agriculture.model.po.User;
import com.agriculture.service.UserService;
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
    private UserService userService;
    @GetMapping("/login")
    public ModelAndView login() {
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("login");
        return modelAndView;
    }
    /*
     * 登录
     * @param loginUser 登录用户名和密码
     * @param bindingResult 验证结果
     * @param session 会话
     * @return ModelAndView
     * @throws RuntimeException 运行时异常
     */
    @PostMapping("/login")
    public ModelAndView login(@Valid LoginUser loginUser,
                              BindingResult bindingResult,
                              HttpSession session){
        ModelAndView modelAndView = new ModelAndView();
        if (bindingResult.hasErrors()) {
            modelAndView.setViewName("redirect:/api/user/login");
            if (bindingResult.getFieldError() == null){
                modelAndView.addObject("error", "用户名或密码错误");
                modelAndView.addObject("loginUser", loginUser);
                return modelAndView;
            }
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
    @GetMapping("/register")
    public ModelAndView register() {
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("register");
        return modelAndView;
    }
    /*
     * 注册
     * @param registerUser 注册用户名、密码、邮箱
     * @param bindingResult 验证结果
     * @param session 会话
     * @return ModelAndView
     * @throws RuntimeException 运行时异常
     */
    @PostMapping("/register")
    public ModelAndView register(@Valid RegisterUser registerUser,
                                BindingResult bindingResult,
                                HttpSession session){
        ModelAndView modelAndView = new ModelAndView();
        if (bindingResult.hasErrors()) {
            modelAndView.setViewName("redirect:/api/user/register");
            String errorMsg = Objects.requireNonNull(bindingResult.getFieldError()).getDefaultMessage();
            modelAndView.addObject("error", errorMsg);
            modelAndView.addObject("registerUser", registerUser);
            return modelAndView;
        }
        try {
            userService.register(registerUser);
        } catch (RuntimeException runtimeException) {
            modelAndView.setViewName("redirect:/api/user/register");
            modelAndView.addObject("error", runtimeException.getMessage());
            modelAndView.addObject("registerUser", registerUser);
            return modelAndView;
        }
        LoginUser loginUser = new LoginUser();
        loginUser.setUsername(registerUser.getUsername());
        loginUser.setPassword(registerUser.getPassword());
        modelAndView.addObject("loginUser", loginUser);

        modelAndView.setViewName("redirect:/api/user/login");
        return modelAndView;
    }
    @GetMapping("/logout")
    public ModelAndView logout(HttpSession session) {
        ModelAndView modelAndView = new ModelAndView();
        try {
            User user = (User) session.getAttribute("user");
            userService.logout(user);
        } catch (RuntimeException runtimeException) {
            modelAndView.setViewName("redirect:/api/dashboard");
            modelAndView.addObject("error", runtimeException.getMessage());
            return modelAndView;
        }
        session.invalidate();
        modelAndView.setViewName("redirect:/api/dashboard");
        return modelAndView;
    }
    @GetMapping("/home")
    public ModelAndView home(HttpSession session) {
        ModelAndView modelAndView = new ModelAndView();
        User user = (User) session.getAttribute("user");
        if(user==null){
            modelAndView.setViewName("redirect:/api/user/login");
            return modelAndView;
        }
        modelAndView.addObject("user", user);
        modelAndView.setViewName("home");
        return modelAndView;
    }
}

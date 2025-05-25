package com.agriculture.controller;

import com.agriculture.model.dto.LoginUser;
import com.agriculture.model.dto.RegisterUser;
import com.agriculture.model.po.User;
import com.agriculture.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
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
                              HttpSession session){
        ModelAndView modelAndView = new ModelAndView();
        User user;
        try {
            user = userService.login(loginUser);
        } catch (RuntimeException runtimeException) {
            modelAndView.setViewName("login");
            modelAndView.addObject("error", runtimeException.getMessage());
            modelAndView.addObject("loginUser", loginUser);
            return modelAndView;
        }
        session.setAttribute("user", user);
        modelAndView.setViewName("dashboard");
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
                                HttpSession session){
        ModelAndView modelAndView = new ModelAndView();
        try {
            userService.register(registerUser);
        } catch (RuntimeException runtimeException) {
            modelAndView.setViewName("register");
            modelAndView.addObject("error", runtimeException.getMessage());
            System.out.println(registerUser);
            modelAndView.addObject("registerUser", registerUser);
            System.out.println(modelAndView.getModel().get("registerUser"));
            return modelAndView;
        }
        LoginUser loginUser = new LoginUser();
        loginUser.setUsername(registerUser.getUsername());
        loginUser.setPassword(registerUser.getPassword());
        modelAndView.addObject("loginUser", loginUser);

        modelAndView.setViewName("login");
        return modelAndView;
    }
    @GetMapping("/logout")
    public ModelAndView logout(HttpSession session) {
        ModelAndView modelAndView = new ModelAndView();
        try {
            User user = (User) session.getAttribute("user");
            userService.logout(user);
        } catch (RuntimeException runtimeException) {
            modelAndView.setViewName("dashboard");
            modelAndView.addObject("error", runtimeException.getMessage());
            return modelAndView;
        }
        session.invalidate();
        modelAndView.setViewName("dashboard");
        return modelAndView;
    }
    @GetMapping("/home")
    public ModelAndView home(HttpSession session) {
        ModelAndView modelAndView = new ModelAndView();
        User user = (User) session.getAttribute("user");
        if(user==null){
            modelAndView.setViewName("login");
            return modelAndView;
        }
        modelAndView.addObject("user", user);
        modelAndView.setViewName("home");
        return modelAndView;
    }
    //  重置密码
    @GetMapping("/reset")
    public ModelAndView reset() {
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("reset");
        return modelAndView;
    }
    @PostMapping("/reset")
    public ModelAndView reset(
            @RequestParam("username") String username,
            @RequestParam("email") String email)
    {
       ModelAndView  modelAndView = new ModelAndView();
       try {
           String newPassword = userService.resetPassword(username, email);
           modelAndView.addObject("newPassword", "新密码是"+newPassword);
           modelAndView.setViewName("reset");
           return modelAndView;
       }catch (RuntimeException runtimeException){
           modelAndView.setViewName("reset");
           modelAndView.addObject("error", runtimeException.getMessage());
           return modelAndView;
       }
    }
}

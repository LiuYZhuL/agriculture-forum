package com.agriculture.controller;
import com.github.pagehelper.PageInfo;
import com.agriculture.model.po.User;
import com.agriculture.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import java.util.List;

@Controller
@RequestMapping("/api/admin")
public class AdminController {
    @Autowired
    private UserService userService;
    @GetMapping("/manage")
    public ModelAndView manage(){
        ModelAndView mv = new ModelAndView();
        mv.setViewName("manage");
        PageInfo<User> pageInfo = userService.listUsers(1, 5, new User());
        mv.addObject("pageInfo", pageInfo);
        return mv;
    }
    //修改用户状态
    @PostMapping("/manage")
    public ModelAndView updateUserStatus(
            @RequestParam("userId") Integer userId,
            @RequestParam("status") Integer status){
        ModelAndView mv = new ModelAndView();
        try{
            userService.updateUserStatus(userId,status);
            mv.addObject("success", true);
            mv.addObject("message", "用户状态更新成功");
            mv.setViewName("manage");
            return mv;
        }catch (RuntimeException e) {
            mv.addObject("success", false);
            mv.addObject("message", e.getMessage());
            mv.setViewName("manage");
            return mv;
        }
    }
    //获取用户列表
    @GetMapping("/manage/user")
    public ModelAndView listUsers(
            @RequestParam(value = "pageNum", defaultValue = "1") Integer pageNum,
            @RequestParam(value = "pageSize", defaultValue = "5") Integer pageSize,
            User user){
        ModelAndView mv = new ModelAndView();
        mv.addObject("activeSection","userMgt");
        try{
            PageInfo<User> pageInfo = userService.listUsers(pageNum, pageSize, user);
            mv.addObject("pageInfo", pageInfo);
            mv.addObject("success", true);
            mv.addObject("message", "用户列表获取成功");
            mv.setViewName("manage");
            return mv;
        }catch (RuntimeException e) {
            mv.addObject("success", false);
            mv.addObject("message", e.getMessage());
            mv.setViewName("manage");
            return mv;
        }
    }

}

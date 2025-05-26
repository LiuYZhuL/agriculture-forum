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
public ModelAndView getAllUsers(){
    ModelAndView mv = new ModelAndView("manage");
    try {
        List<User> userList = userService.AllUsers();
        mv.addObject("userList", userList);
        mv.addObject("success", true);
        mv.addObject("message", "获取所有用户成功");
    } catch (RuntimeException e) {
        mv.addObject("success", false);
        mv.addObject("message", e.getMessage());
    }
    return mv;
}
    //获取用户信息


    //修改用户角色
}

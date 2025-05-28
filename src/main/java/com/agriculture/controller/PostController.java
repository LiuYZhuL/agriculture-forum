package com.agriculture.controller;

import com.agriculture.model.po.Post;
import com.agriculture.model.po.User;
import com.agriculture.service.PostService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping("/api/post")
public class PostController {
    @Autowired
    private PostService postService;
    @PostMapping("/selectUserById")
    public ModelAndView selectUserById(
            @RequestParam("userId") Integer userId) {
        ModelAndView mv = new ModelAndView();
        try {
            User user = postService.selectUserById(userId);
            mv.addObject("user", user);
            mv.setViewName("userDetails");
        } catch (RuntimeException e) {
            mv.setViewName("error");
            mv.addObject("errorMsg", "查询用户失败，用户ID：" + userId);
        }
        return mv;
    }

}

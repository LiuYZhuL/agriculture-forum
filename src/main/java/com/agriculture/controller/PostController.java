package com.agriculture.controller;

import com.agriculture.model.dto.AddPost;
import com.agriculture.model.po.Post;
import com.agriculture.model.po.User;
import com.agriculture.service.PostService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import javax.validation.Valid;

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
    @PostMapping("/add")
    public ModelAndView add(
            @Valid AddPost addPost,
            @RequestParam(name = "images", required = false) MultipartFile[] images,
            @RequestParam(name = "videos", required = false) MultipartFile videos,
            HttpSession session) {
        ModelAndView mv = new ModelAndView();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            mv.setViewName("redirect:/api/user/login");
            mv.addObject("error", "请先登录");
            return mv;
        }
        addPost.setUserId(user.getId());
        try {
            Post post = postService.add(addPost);
            mv.setViewName("redirect:/");
            return mv;
        }catch (RuntimeException e) {
            mv.setViewName("dashboard");
            mv.addObject("errorMsg", "发布失败，请检查输入内容");
            mv.addObject("error", e.getMessage());
            return mv;
        }
    }
}

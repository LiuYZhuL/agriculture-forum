package com.agriculture.controller;
import com.agriculture.model.po.Comment;
import com.agriculture.model.po.User;
import com.agriculture.service.CommentService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.validation.Valid;

@Controller
@RequestMapping("/api/comment")
public class CommentController {
    @Autowired
    private CommentService commentService;
    @PostMapping("/add")
    public ModelAndView add(@RequestParam("postId") Integer postId,
                            @RequestParam("userId") Integer userId,
                            @RequestParam ("content") String content,
                            @RequestParam(name = "parentId", required = false)  Integer parentId,
                            HttpSession session) {
         ModelAndView mv = new ModelAndView();
         mv.setViewName("redirect:/api/post/detail?postId=" + postId);
         User user = (User) session.getAttribute("user");
         if (user == null) {
             mv.setViewName("redirect:api/user/login");
         }
         try {
             Comment comment = new Comment();
             comment.setPostId(postId);
             comment.setUserId(userId);
             comment.setContent(content);
             comment.setParentId(parentId);
             commentService.addComment(comment);

         } catch (RuntimeException e) {
             mv.addObject("error", e.getMessage());
         }
         return mv;
    }
}

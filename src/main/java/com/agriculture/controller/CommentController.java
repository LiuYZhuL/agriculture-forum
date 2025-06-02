package com.agriculture.controller;
import com.agriculture.model.po.Comment;
import com.agriculture.model.po.User;
import com.agriculture.model.vo.CommentVO;
import com.agriculture.service.CommentService;
import com.agriculture.service.UserService;
import com.github.pagehelper.PageInfo;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.validation.Valid;
import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping("/api/comment")
public class CommentController {
    @Autowired
    private CommentService commentService;
    @Autowired
    private UserService userService;
    @PostMapping("/add")
    public ModelAndView add(@RequestParam("postId") Integer postId,
                            @RequestParam("userId") Integer userId,
                            @RequestParam ("content") String content,
                            @RequestParam(name = "parentId", required = false)  Integer parentId,
                            HttpSession session) {
         ModelAndView mv = new ModelAndView();
         mv.setViewName("redirect:/api/post/detail?postId=" + postId);
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
    // CommentController.java新增方法
    @GetMapping("/page")
    public ModelAndView getCommentPage(
            @RequestParam("postId") Integer postId,
            @RequestParam(name = "page", defaultValue = "1") Integer page,
            @RequestParam(name = "size", defaultValue = "5") Integer size
            ) {
        ModelAndView model = new ModelAndView("/element/comment_fragment");
        try {
            PageInfo<Comment> pcs = commentService.getCommentsByPage(postId, page, size);
            List<CommentVO> rootComments = new ArrayList<>(); // 存放顶级评论
            for (Comment comment : pcs.getList()) {
                if (comment.getParentId() == null) {
                    CommentVO vo = new CommentVO();
                    User pu = userService.getUserById(comment.getUserId());
                    vo.setComment(comment);
                    vo.setUsername(pu.getUsername());
                    vo.setAvatar(pu.getAvatar());
                    List<Comment> children = commentService.getCCommentsByPostId(comment.getId());
                    for (Comment child : children) {
                        CommentVO cvo = new CommentVO();
                        User cu = userService.getUserById(child.getUserId());
                        cvo.setComment(child);
                        cvo.setUsername(cu.getUsername());
                        cvo.setAvatar(cu.getAvatar());
                        vo.getChildren().add(cvo);
                    }
                    rootComments.add(vo);
                }
            }
            model.addObject("comments", rootComments);
            model.addObject("hasMore", pcs.isHasNextPage());
        } catch ( Exception e){
            e.printStackTrace();
        }

        return model;
    }


}

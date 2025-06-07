package com.agriculture.controller;
import com.agriculture.model.po.Comment;
import com.agriculture.model.po.Post;
import com.agriculture.model.po.User;
import com.agriculture.model.vo.CommentVO;
import com.agriculture.service.CommentService;
import com.agriculture.service.PostService;
import com.agriculture.service.UserService;
import com.github.pagehelper.PageInfo;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.validation.Valid;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/api/comment")
public class CommentController {
    @Autowired
    private CommentService commentService;
    @Autowired
    private UserService userService;
    @Autowired
    private PostService postService;
    @PostMapping("/add")
    public ModelAndView add(@RequestParam("postId") Integer postId,
                            @RequestParam("userId") Integer userId,
                            @RequestParam ("content") String content,
                            @RequestParam(name = "parentId", required = false)  Integer parentId,
                            HttpSession session) {
         ModelAndView mv = new ModelAndView();
         mv.setViewName("comment");
         try {
             Comment comment = new Comment();
             comment.setPostId(postId);
             comment.setUserId(userId);
             comment.setContent(content);
             comment.setParentId(parentId);
             commentService.addComment(comment);

             mv.addObject("comment", comment);
             mv.addObject("success", "评论成功");
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
        ModelAndView model = new ModelAndView("comment-frag");
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

    @DeleteMapping("/delete/{commentId}")
    @ResponseBody
     public ResponseEntity<Map<String, Object>> delete(@PathVariable("commentId") Integer commentId) {
        Map<String, Object> response = new HashMap<>();
        try {
            Comment comment = commentService.selectCommentById(commentId);
            response.put("success", true);
            response.put("message", "删除成功");
            commentService.deleteComment(commentId);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "删除失败");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }
    @GetMapping("/detail/{postId}")
    public ModelAndView detail(@PathVariable("postId") Integer postId) {
        ModelAndView model = new ModelAndView();
        try {
            Post post = postService.getbyId(postId);
            if (post.getStatus() >= Post.STATUS_KNOWLEDGE_WAITING_AUDIT){
                model.setViewName("redirect:/api/knowledge/detail?postId=" + postId);
            }else{
                model.setViewName("redirect:/api/post/detail?postId=" + postId);
            }
            return model;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return model;
    }

}

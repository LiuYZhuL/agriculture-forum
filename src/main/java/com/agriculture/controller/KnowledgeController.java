package com.agriculture.controller;

import com.agriculture.model.po.*;
import com.agriculture.model.vo.CommentVO;
import com.agriculture.model.vo.PostVO;
import com.agriculture.service.*;
import com.github.pagehelper.PageInfo;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping("/api/knowledge")
public class KnowledgeController {
    @Autowired
    private PostService postService;
    @Autowired
    private UserService userService;
    @Autowired
    private CommentService commentService;
    @Autowired
    private CategoryService categoryService;
    @Autowired
    private AttachmentService attachmentService;
    @Autowired
    private InteractionService interactionService;


    @GetMapping("/detail")
    public ModelAndView detail(
            @RequestParam("postId") Integer postId,
            HttpSession session) {
        ModelAndView mv = new ModelAndView();
        User user = (User) session.getAttribute("user");
        if (user == null){
            mv.setViewName("login");
            return mv;
        }
        try {
            Post post = postService.getbyId(postId);
            User postUser = userService.getUserById(post.getUserId());
            Category category = categoryService.getCategoryById(post.getCategoryId());
            List<Attachment> attachments = attachmentService.getAttachmentByPostId(postId);
            postService.updatePostViewCount(postId);

            List<Comment> pcs = commentService.getPCommentsByPostId(postId);
            List<CommentVO> rootComments = new ArrayList<>(); // 存放顶级评论
            for (Comment comment : pcs) {
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
            mv.addObject("category", category);
            mv.addObject("postUser", postUser);
            mv.addObject("post", post);
            mv.addObject("attachments", attachments);
            mv.addObject("comments", rootComments);
            mv.addObject("isLiked", interactionService.isLiked(postId, user.getId()));
            mv.addObject("likeCount", postService.getPostLikeCount(postId));
            mv.addObject("isCollected", interactionService.isCollected(postId, user.getId()));
            mv.addObject("collectionCount", postService.getPostCollectionCount(postId));
            mv.addObject("commentCount", commentService.getCommentCountByPostId(postId));
            mv.setViewName("knowledge");
        } catch (RuntimeException e) {
            mv.addObject("error", e.getMessage());
            mv.setViewName("redirect:/");
            mv.addObject("errorMsg", "查询知识失败，帖子ID：" + postId);
        }
        return mv;
    }
    @GetMapping("/more")
    public ModelAndView more(
            HttpSession session) {
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("more_knowledge");
        try {
            List<Category> categories = categoryService.listCategories();
            modelAndView.addObject("categories", categories);
        }catch (RuntimeException e){
            modelAndView.addObject("error", e.getMessage());
            return modelAndView;
        }
        return modelAndView;
    }
    @GetMapping("/search")
    public ModelAndView search(
            @RequestParam(name = "page", defaultValue = "1") Integer page,
            @RequestParam(name = "size", defaultValue = "5") Integer size,
            @RequestParam(name = "keyword", required = false) String keyword,
            @RequestParam(name = "categoryId", required = false) Integer categoryId) {
        ModelAndView model = new ModelAndView("knowledge_fragment");
        Post searchPost = new Post();
        searchPost.setTitle(keyword);
        searchPost.setCategoryId(categoryId);
        searchPost.setStatus(Post.STATUS_KNOWLEDGE_PUBLISHED);
        PageInfo<Post> postList = postService.searchKnowledges(page, size, searchPost);
        List<PostVO> postVOs = new ArrayList<>();
        for (Post p : postList.getList()) {
            PostVO postVO = new PostVO(p,
                    userService.getUserById(p.getUserId()).getUsername(),
                    categoryService.getCategoryById(p.getCategoryId()).getName(),
                    attachmentService.getAttachmentByPostId(p.getId()).isEmpty() ? null : attachmentService.getAttachmentByPostId(p.getId()).get(0),
                    commentService.getCommentCountByPostId(p.getId()),
                    p.getViewCount(),
                    postService.getPostLikeCount(p.getId()),
                    postService.getPostCollectionCount(p.getId()));
            postVOs.add(postVO);
        }
        model.addObject("knowledgeVOs", postVOs);
        model.addObject("hasMore", postList.isHasNextPage());
        return model;

    }
}

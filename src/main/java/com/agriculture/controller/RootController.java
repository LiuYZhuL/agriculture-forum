package com.agriculture.controller;

import com.agriculture.model.po.Category;
import com.agriculture.model.po.Post;
import com.agriculture.model.vo.KnowledgeVO;
import com.agriculture.model.vo.PostVO;
import com.agriculture.service.*;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.servlet.ModelAndView;

import java.util.ArrayList;
import java.util.List;

@Controller
public class RootController {
    @Autowired
    private CategoryService categoryService;
    @Autowired
    private PostService postService;
    @Autowired
    private UserService  userService;
    @Autowired
    private AttachmentService attachmentService;
    @Autowired
    private CommentService  commentService;

    @GetMapping({"/", "/api/dashboard"})
    public ModelAndView root() {
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("dashboard");
        try {
            List<Category> categories = categoryService.listCategories();
            List<PostVO> postVOs = new ArrayList<>();
            Post post = new Post();
            post.setStatus(Post.STATUS_PUBLISHED);
            post.setIsEssence(Post.IS_ESSENCE);
            PageInfo<Post> postList = postService.searchPosts(1,6, post);
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
            Post known = new Post();
            known.setStatus(Post.STATUS_KNOWLEDGE_PUBLISHED);
            known.setIsEssence(Post.IS_ESSENCE);
            PageInfo<Post> knowledgeList = postService.searchKnowledges(1, 6, known);
            List<KnowledgeVO> knowledgeVOs = new ArrayList<>();
            for (Post k : knowledgeList.getList()) {
                KnowledgeVO knowledgeVO = new KnowledgeVO(k,
                        userService.getUserById(k.getUserId()).getUsername(),
                        categoryService.getCategoryById(k.getCategoryId()).getName(),
                        attachmentService.getAttachmentByPostId(k.getId()).isEmpty() ? null : attachmentService.getAttachmentByPostId(k.getId()).get(0),
                        k.getViewCount(),
                        postService.getPostLikeCount(k.getId()),
                        postService.getPostCollectionCount(k.getId()));
                knowledgeVOs.add(knowledgeVO);
            }
            modelAndView.addObject("postVOs", postVOs);
            modelAndView.addObject("knowledgeVOs", knowledgeVOs);
            modelAndView.addObject("categories", categories);
        }catch (RuntimeException e){
            modelAndView.addObject("error", e.getMessage());
            return modelAndView;
        }
        return modelAndView;
    }
}

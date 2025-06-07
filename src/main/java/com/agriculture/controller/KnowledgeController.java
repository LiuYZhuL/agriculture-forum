package com.agriculture.controller;

import com.agriculture.model.dto.AddPost;
import com.agriculture.model.po.*;
import com.agriculture.model.vo.CommentVO;
import com.agriculture.model.vo.PostVO;
import com.agriculture.service.*;
import com.github.pagehelper.PageInfo;
import jakarta.servlet.http.HttpSession;
import org.apache.commons.io.FilenameUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import javax.validation.Valid;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.*;

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


    @PostMapping("/add")
    public ModelAndView add(
            @Valid AddPost addPost,
            @RequestParam(name = "images", required = false) MultipartFile[] images,
            @RequestParam(name = "videos", required = false) MultipartFile videos,
            @RequestParam(name = "files", required = false) MultipartFile[] files,
            HttpSession session) {
        ModelAndView mv = new ModelAndView();
        User user = (User) session.getAttribute("user");
        addPost.setUserId(user.getId());
        try {
            Post post = postService.add(addPost);
            postService.updatePostStatus(post.getId(), Post.STATUS_KNOWLEDGE_WAITING_AUDIT);
            List<Attachment> attachments = new ArrayList<>();
            for (MultipartFile image : images){
                if (image.isEmpty()) {
                    continue;
                }
                Attachment attachment = new Attachment();
                attachment.setPostId(post.getId());
                Set<String> allowedExtensions = Set.of("jpg", "jpeg", "png", "gif");
                String extension = FilenameUtils.getExtension(image.getOriginalFilename()).toLowerCase();
                if (!allowedExtensions.contains(extension)) {
                    throw new RuntimeException("仅支持JPG/PNG/GIF格式");
                }
                attachment.setFileType("image/" + extension);
                String newFileName = post.getId() + "_" + System.currentTimeMillis() + "." + extension;
                attachment.setFilePath(newFileName);
                Path uploadDir = Paths.get(
                        session.getServletContext().getRealPath("/static/uploads/attachments/img/")
                );
                attachments.add(attachment);
                Files.createDirectories(uploadDir);
                image.transferTo(uploadDir.resolve(newFileName));
            }
            if (videos!= null &&!videos.isEmpty()){
                Attachment attachment = new Attachment();
                attachment.setPostId(post.getId());
                Set<String> allowedExtensions = Set.of("mp4", "mkv");
                String extension = FilenameUtils.getExtension(videos.getOriginalFilename()).toLowerCase();
                if (!allowedExtensions.contains(extension)) {
                    throw new RuntimeException("仅支持MP4/MKV格式");
                }
                attachment.setFileType("video/" + extension);
                String newFileName = post.getId() + "_" + System.currentTimeMillis() + "." + extension;
                attachment.setFilePath(newFileName);
                Path uploadDir = Paths.get(
                        session.getServletContext().getRealPath("/static/uploads/attachments/video/")
                );
                attachments.add(attachment);
                Files.createDirectories(uploadDir);
                videos.transferTo(uploadDir.resolve(newFileName));
            }
            for (MultipartFile file : files){
                if (file.isEmpty()) {
                    continue;
                }
                Attachment attachment = new Attachment();
                attachment.setPostId(post.getId());
                Set<String> allowedExtensions = Set.of("pdf", "doc", "docx", "xls", "xlsx", "ppt", "pptx", "zip", "7z");
                String extension = FilenameUtils.getExtension(file.getOriginalFilename()).toLowerCase();
                if (!allowedExtensions.contains(extension)) {
                    throw new RuntimeException("仅支持PDF/DOC/DOCX/XLS/XLSX/PPT/PPTX/ZIP/7Z格式");
                }
                attachment.setFileType("application/" + extension);
                attachment.setFilePath(file.getOriginalFilename());
                Path uploadDir = Paths.get(
                        session.getServletContext().getRealPath("/static/uploads/attachments/file/")
                );
                attachments.add(attachment);
                Files.createDirectories(uploadDir);
                file.transferTo(uploadDir.resolve(file.getOriginalFilename()));
            }
            if (!attachments.isEmpty()){
                attachmentService.postAttachment(attachments);
            }
            mv.setViewName("redirect:/api/knowledge/more");
            return mv;
        }catch (RuntimeException e) {
            mv.setViewName("dashboard");
            mv.addObject("errorMsg", "发布失败，请检查输入内容");
            mv.addObject("error", e.getMessage());
            mv.setViewName("redirect:/api/knowledge/more");
            return mv;
        } catch (IOException e) {
            mv.addObject("errorMsg", "上传文件失败");
            mv.setViewName("redirect:/api/knowledge/more");
            return mv;
        }
    }
    @GetMapping("/detail")
    public ModelAndView detail(
            @RequestParam("postId") Integer postId,
            HttpSession session) {
        ModelAndView mv = new ModelAndView();
        User user = (User) session.getAttribute("user");
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
    @GetMapping("/update")
    public ModelAndView update(
            @RequestParam("postId") Integer postId){
        ModelAndView mv = new ModelAndView();
        mv.setViewName("knowledge-modal");
        try {
            Post post = postService.getbyId(postId);
            mv.addObject("post", post);
            mv.addObject("attachments", attachmentService.getAttachmentByPostId(postId));
            mv.addObject("categories", categoryService.listCategories());
            return mv;
        } catch (RuntimeException e) {
            mv.addObject("error", e.getMessage());
            mv.setViewName("knowledge-modal");
            return mv;
        }
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
            @RequestParam(name = "category", required = false) Integer category) {
        ModelAndView model = new ModelAndView("more-knowledge-frag");
        Post searchPost = new Post();
        searchPost.setTitle(keyword);
        searchPost.setUsername(keyword);
        searchPost.setCategoryId(category);
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
    @GetMapping("/status")
    public ModelAndView status(
            @RequestParam("postId") Integer postId,
            @RequestParam("status") Integer status) {
        ModelAndView mv = new ModelAndView();
        mv.setViewName("manage");
        mv.addObject("activeSection", "knowledgeMgt");
        try {
            postService.updatePostStatus(postId, status);
            mv.addObject("knowledgeSuccess", true);
            mv.addObject("knowledgeMsg", "更新知识[" + postId + "]状态成功");
        } catch (RuntimeException e) {
            mv.addObject("knowledgeSuccess", false);
            mv.addObject("knowledgeMsg", e.getMessage());
        }
        return mv;
    }
    @GetMapping("/top")
    public ModelAndView top(
            @RequestParam("postId") Integer postId,
            @RequestParam("isTop") Integer top) {
        ModelAndView mv = new ModelAndView();
        mv.setViewName("manage");
        mv.addObject("activeSection", "knowledgeMgt");
        try {
            postService.updatePostTop(postId, top);
            mv.addObject("knowledgeSuccess", true);
            mv.addObject("knowledgeMsg", "更新知识[" + postId + "]置顶成功");
        } catch (RuntimeException e) {
            mv.addObject("knowledgeSuccess", false);
            mv.addObject("knowledgeMsg", e.getMessage());
        }
        return mv;
    }
    @GetMapping("/essence")
    public ModelAndView essence(
            @RequestParam("postId") Integer postId,
            @RequestParam("isEssence") Integer essence) {
        ModelAndView mv = new ModelAndView();
        mv.setViewName("manage");
        mv.addObject("activeSection", "knowledgeMgt");
        try {
            postService.updatePostEssence(postId, essence);
            mv.addObject("knowledgeSuccess", true);
            mv.addObject("knowledgeMsg", "更新知识[" + postId + "]精华成功");
        } catch (RuntimeException e) {
            mv.addObject("knowledgeSuccess", false);
            mv.addObject("knowledgeMsg", e.getMessage());
        }
        return mv;
    }
}

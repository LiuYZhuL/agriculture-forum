package com.agriculture.controller;

import com.agriculture.model.dto.AddPost;
import com.agriculture.model.po.*;
import com.agriculture.model.vo.CommentVO;
import com.agriculture.service.*;
import jakarta.servlet.http.HttpSession;
import org.apache.commons.io.FilenameUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import javax.validation.Valid;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.*;

@Controller
@RequestMapping("/api/post")
public class PostController {
    @Autowired
    private PostService postService;
    @Autowired
    private UserService userService;
    @Autowired
    private AttachmentService attachmentService;
    @Autowired
    private CategoryService categoryService;
    @Autowired
    private CommentService commentService;
    @Autowired
    private InteractionService interactionService;
    @PostMapping("/add")
    public ModelAndView add(
            @Valid AddPost addPost,
            @RequestParam(name = "images", required = false) MultipartFile[] images,
            @RequestParam(name = "videos", required = false) MultipartFile videos,
            HttpSession session) {
        ModelAndView mv = new ModelAndView();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            mv.setViewName("login");
            mv.addObject("error", "请先登录");
            return mv;
        }
        addPost.setUserId(user.getId());
        try {
            Post post = postService.add(addPost);
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
            attachmentService.postAttachment(attachments);
            mv.setViewName("redirect:/");
            return mv;
        }catch (RuntimeException e) {
            mv.setViewName("dashboard");
            mv.addObject("errorMsg", "发布失败，请检查输入内容");
            mv.addObject("error", e.getMessage());
            mv.setViewName("redirect:/");
            return mv;
        } catch (IOException e) {
            mv.addObject("errorMsg", "上传文件失败");
            mv.setViewName("redirect:/");
            return mv;
        }
    }
    @GetMapping("/delete")
    public ModelAndView delete(
            @RequestParam("postId") Integer postId,
            HttpSession session) {
        ModelAndView mv = new ModelAndView();
        mv.addObject("activeSection", "post");
        mv.setViewName("home");
        Post post = null;
        try {
            post = postService.getbyId(postId);
            List<Attachment> attachments = attachmentService.getAttachmentByPostId(postId);
            attachmentService.deleteAttachmentByPostId(postId);
            postService.deletePost(postId);
            for (Attachment attachment : attachments) {
                if (attachment.getFileType().startsWith("image")) {
                    Path filePath = Paths.get(
                            session.getServletContext().getRealPath("/static/uploads/attachments/img/" + attachment.getFilePath())
                    );
                    Files.delete(filePath);
                } else if (attachment.getFileType().startsWith("video")) {
                    Path filePath = Paths.get(
                            session.getServletContext().getRealPath("/static/uploads/attachments/video/" + attachment.getFilePath())
                    );
                    Files.delete(filePath);
                }
            }
            interactionService.deletePostInteraction(postId);
            mv.addObject("postSuccess", true);
            mv.addObject("postMsg", "删除帖子[" + post.getTitle() + "]成功");
            return mv;
        }catch (RuntimeException e){
            mv.addObject("postSuccess", false);

            mv.addObject("postMsg", e.getMessage());

            return mv;
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }
    @GetMapping("/show")
    public ModelAndView show(
            @RequestParam("postId") Integer postId) {
        ModelAndView mv = new ModelAndView();
        try {
            Post post = postService.getbyId(postId);
            User postUser = userService.getUserById(post.getUserId());
            Category category = categoryService.getCategoryById(post.getCategoryId());
            List<Attachment> attachments = attachmentService.getAttachmentByPostId(postId);
            mv.addObject("category", category);
            mv.addObject("postUser", postUser);
            mv.addObject("post", post);
            mv.addObject("attachments", attachments);
            mv.setViewName("show");
        } catch (RuntimeException e) {
            mv.addObject("error", e.getMessage());
            mv.setViewName("redirect:/");
            mv.addObject("errorMsg", "查询帖子失败，帖子ID：" + postId);
        }
        return mv;
    }
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
            mv.setViewName("post");
        } catch (RuntimeException e) {
            mv.addObject("error", e.getMessage());
            mv.setViewName("redirect:/");
            mv.addObject("errorMsg", "查询帖子失败，帖子ID：" + postId);
        }
        return mv;
    }
    @GetMapping("/status")
    public ModelAndView status(
            @RequestParam("postId") Integer postId,
            @RequestParam("status") Integer status) {
        ModelAndView mv = new ModelAndView();
        mv.setViewName("manage");
        mv.addObject("activeSection", "postMgt");
        try {
            postService.updatePostStatus(postId, status);
            mv.addObject("postSuccess", true);
            mv.addObject("postMsg", "更新帖子[" + postId + "]状态成功");
        } catch (RuntimeException e) {
            mv.addObject("postSuccess", false);
            mv.addObject("postMsg", e.getMessage());
        }
        return mv;
    }
    @GetMapping("/top")
    public ModelAndView top(
            @RequestParam("postId") Integer postId,
            @RequestParam("isTop") Integer top) {
        ModelAndView mv = new ModelAndView();
        mv.setViewName("manage");
        mv.addObject("activeSection", "postMgt");
        try {
            postService.updatePostTop(postId, top);
            mv.addObject("postSuccess", true);
            mv.addObject("postMsg", "更新帖子[" + postId + "]置顶成功");
        } catch (RuntimeException e) {
            mv.addObject("postSuccess", false);
            mv.addObject("postMsg", e.getMessage());
        }
        return mv;
    }
    @GetMapping("/essence")
    public ModelAndView essence(
            @RequestParam("postId") Integer postId,
            @RequestParam("isEssence") Integer essence) {
        ModelAndView mv = new ModelAndView();
        mv.setViewName("manage");
        mv.addObject("activeSection", "postMgt");
        try {
            postService.updatePostEssence(postId, essence);
            mv.addObject("postSuccess", true);
            mv.addObject("postMsg", "更新帖子[" + postId + "]精华成功");
        } catch (RuntimeException e) {
            mv.addObject("postSuccess", false);
            mv.addObject("postMsg", e.getMessage());
        }
        return mv;
    }
    @GetMapping("/update")
    public ModelAndView update(
            @RequestParam("postId") Integer postId){
        ModelAndView mv = new ModelAndView();
        mv.setViewName("postUD");
        try {
            Post post = postService.getbyId(postId);
            mv.addObject("post", post);
            mv.addObject("attachments", attachmentService.getAttachmentByPostId(postId));
             mv.addObject("categories", categoryService.listCategories());
             return mv;
        } catch (RuntimeException e) {
             mv.addObject("error", e.getMessage());
             mv.setViewName("redirect:/");
             return mv;
        }
    }

    @PostMapping("/update")
    public ModelAndView update(
            @RequestParam("postId") Integer postId,
            @Valid AddPost addPost,
            @RequestParam(name = "images", required = false) MultipartFile[] images,
             @RequestParam(name = "videos", required = false) MultipartFile videos,
             @RequestParam(name = "deletedAttachments", required = false) String deletedAttachments,
             HttpSession session) {
        ModelAndView mv = new ModelAndView();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            mv.setViewName("login");
            mv.addObject("error", "请先登录");
            return mv;
        }
        addPost.setUserId(user.getId());
        try {
            Post post = new Post();
            post.setId(postId);
            post.setTitle(addPost.getTitle());
            post.setContent(addPost.getContent());
            post.setCategoryId(addPost.getCategoryId());
            post.setStatus(Post.STATUS_WAITING_AUDIT);
            postService.updatePost(post);
            List<Attachment> attachments = new ArrayList<>();
            if (images != null && images.length > 0){
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
            if (!attachments.isEmpty()){
                attachmentService.postAttachment(attachments);
                for (String attachmentId : deletedAttachments.split(",")){
                    if (attachmentId != null && !attachmentId.isEmpty()){
                        Attachment attachment = attachmentService.getAttachmentById(Integer.parseInt(attachmentId));
                        attachmentService.deleteAttachmentById(Integer.parseInt(attachmentId));
                        Path filePath = Paths.get(
                                session.getServletContext().getRealPath("/static/uploads/attachments/video/" + attachment.getFilePath())
                        );
                        Files.delete(filePath);
                    }
                }
            }

            mv.setViewName("redirect:/");
            return mv;
        }catch (RuntimeException e) {
            mv.setViewName("dashboard");
            mv.addObject("errorMsg", "发布失败，请检查输入内容");
            mv.addObject("error", e.getMessage());
            mv.setViewName("redirect:/");
            return mv;
        } catch (IOException e) {
            mv.addObject("errorMsg", "上传文件失败");
            mv.setViewName("redirect:/");
            return mv;
        }
    }
    @PostMapping("/like")
    public void like(
            @RequestParam("postId") Integer postId,
            HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return;
        }
        try {
            if (interactionService.isLiked(postId, user.getId())){
                interactionService.deleteLike(postId, user.getId());
            }else {
                interactionService.addLike(postId, user.getId());
            }
        }catch (RuntimeException e){
            e.printStackTrace();
        }
    }
    @PostMapping("/collect")
    public ModelAndView collect(
            @RequestParam("postId") Integer postId,
            HttpSession session) {
        ModelAndView mv = new ModelAndView();
        mv.setViewName("redirect:detail?postId=" + postId);
        User user = (User) session.getAttribute("user");
        if (user == null) {
            mv.setViewName("login");
            mv.addObject("error", "请先登录");
            return mv;
        }
        try {
            if (interactionService.isCollected(postId, user.getId())){
                interactionService.deleteCollection(postId, user.getId());
            }else {
                interactionService.addCollection(postId, user.getId());
            }
        } catch (RuntimeException e){
            mv.addObject("error", e.getMessage());
            mv.setViewName("redirect:/");
            return mv;
        }
        return mv;
    }

}

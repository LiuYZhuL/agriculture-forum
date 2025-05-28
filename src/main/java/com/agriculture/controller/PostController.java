package com.agriculture.controller;

import com.agriculture.model.dto.AddPost;
import com.agriculture.model.po.Attachment;
import com.agriculture.model.po.Category;
import com.agriculture.model.po.Post;
import com.agriculture.model.po.User;
import com.agriculture.service.AttachmentService;
import com.agriculture.service.CategoryService;
import com.agriculture.service.PostService;
import com.agriculture.service.UserService;
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
import java.util.ArrayList;
import java.util.List;
import java.util.Set;

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
    @GetMapping("/detail")
    public ModelAndView detail(
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
            mv.setViewName("post");
        } catch (RuntimeException e) {
            mv.addObject("error", e.getMessage());
            mv.setViewName("redirect:/");
            mv.addObject("errorMsg", "查询帖子失败，帖子ID：" + postId);
        }
        return mv;
    }
}

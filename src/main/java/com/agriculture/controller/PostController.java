package com.agriculture.controller;

import com.agriculture.model.dto.AddPost;
import com.agriculture.model.po.*;
import com.agriculture.model.vo.CommentVO;
import com.agriculture.model.vo.KnowledgeVO;
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
    @ResponseBody
    public ResponseEntity<Map<String, Object>> add(
            @RequestParam("title") String title,
            @RequestParam("content") String content,
            @RequestParam("categoryId") Integer categoryId,
            @RequestParam("status") Integer status,
            @RequestParam(name = "addNewAttachments", required = false) MultipartFile[] addNewAttachments,
            HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        User user = (User) session.getAttribute("user");
        AddPost addPost = new AddPost();
        addPost.setTitle(title);
        addPost.setContent(content);
        addPost.setCategoryId(categoryId);
        addPost.setUserId(user.getId());
        try {
            Post post = postService.add(addPost);
            postService.updatePostStatus(post.getId(), status);
            if (addNewAttachments != null && addNewAttachments.length > 0){
                List<Attachment> attachments = new ArrayList<>();

                for (MultipartFile file : addNewAttachments){
                    if (file.isEmpty()) {
                        continue;
                    }
                    Attachment attachment = new Attachment();
                    attachment.setPostId(post.getId());
                    Set<String> imgExtensions = Set.of("jpg", "jpeg", "png", "gif");
                    Set<String> videoExtensions = Set.of("mp4", "mkv");
                    Set<String> allowedExtensions = Set.of("pdf", "doc", "docx", "xls", "xlsx", "ppt", "pptx", "zip", "7z");
                    String extension = FilenameUtils.getExtension(file.getOriginalFilename()).toLowerCase();
                    if (imgExtensions.contains(extension)){
                        attachment.setFileType("image/" + extension);
                        String newFileName = post.getId() + "_" + System.currentTimeMillis() + "." + extension;
                        attachment.setFilePath(newFileName);
                        Path uploadDir = Paths.get(
                                session.getServletContext().getRealPath("/static/uploads/attachments/img/")
                        );
                        attachments.add(attachment);
                        Files.createDirectories(uploadDir);
                        file.transferTo(uploadDir.resolve(newFileName));
                    }else if (videoExtensions.contains(extension)){
                        attachment.setFileType("video/" + extension);
                        String newFileName = post.getId() + "_" + System.currentTimeMillis() + "." + extension;
                        attachment.setFilePath(newFileName);
                        Path uploadDir = Paths.get(
                                session.getServletContext().getRealPath("/static/uploads/attachments/video/")
                        );
                        attachments.add(attachment);
                        Files.createDirectories(uploadDir);
                        file.transferTo(uploadDir.resolve(newFileName));
                    }else if (allowedExtensions.contains(extension)){
                        attachment.setFileType("application/" + extension);
                        String newFileName = post.getId() + "_" + System.currentTimeMillis() + "_" + file.getOriginalFilename() + "." + extension;
                        attachment.setFilePath(newFileName);
                        Path uploadDir = Paths.get(
                                session.getServletContext().getRealPath("/static/uploads/attachments/file/")
                        );
                        attachments.add(attachment);
                        Files.createDirectories(uploadDir);
                        file.transferTo(uploadDir.resolve(newFileName));
                    }else {
                        throw new RuntimeException("未知文件类型");
                    }
                }
                attachmentService.postAttachment(attachments);
            }
            response.put("success", true);
            response.put("message", "发布成功");
            return ResponseEntity.ok(response);
        }catch (RuntimeException | IOException e) {
            response.put("success", false);
            response.put("message", "发布失败: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }
    @DeleteMapping("/delete/{postId}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>>
            delete(
            @PathVariable("postId") Integer postId,
            HttpSession session) {
        Map<String, Object> response = new HashMap<>();

        Post post = null;
        try {
            post = postService.getbyId(postId);
            List<Attachment> attachments = attachmentService.getAttachmentByPostId(postId);
            if (attachments != null && !attachments.isEmpty()) {
                attachmentService.deleteAttachmentByPostId(postId);
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
                    } else if (attachment.getFileType().startsWith("application")){
                        Path filePath = Paths.get(
                                session.getServletContext().getRealPath("/static/uploads/attachments/file/" + attachment.getFilePath())
                        );
                        Files.delete(filePath);
                    }
                }
            }
            if (commentService.getCommentCountByPostId(postId) > 0) {
                commentService.deleteCommentsByPostId(postId);
            }
            if (interactionService.getLikeCount(postId) > 0 || interactionService.getCollectionCount(postId) > 0){
                interactionService.deletePostInteraction(postId);
            }
            postService.deletePost(postId);
            response.put("success", true);
            response.put("message", "删除[" + post.getTitle() + "]成功");
            return ResponseEntity.ok(response);
        } catch (RuntimeException | IOException e) {
            response.put("success", false);
            response.put("message", "删除失败: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }

    }
    @GetMapping("/show/{postId}")
    public ModelAndView show(
            @PathVariable("postId") Integer postId) {
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
        try {
            Post post = postService.getbyId(postId);
            User postUser = userService.getUserById(post.getUserId());
            Category category = categoryService.getCategoryById(post.getCategoryId());
            List<Attachment> attachments = attachmentService.getAttachmentByPostId(postId);
            if(Objects.equals(post.getStatus(), Post.STATUS_PUBLISHED)){
                postService.updatePostViewCount(postId);
            }


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
    @PostMapping("/status")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> status(
            @RequestParam("postId") Integer postId,
            @RequestParam("status") Integer status) {
        Map<String, Object> response = new HashMap<>();
        try {
            postService.updatePostStatus(postId, status);
            response.put("success", true);
            response.put("message", "更新帖子[" + postId + "]状态成功");
            return ResponseEntity.ok(response);
        } catch (RuntimeException e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }
    @PostMapping("/top")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> top(
            @RequestParam("postId") Integer postId,
            @RequestParam("isTop") Integer top) {
        Map<String, Object> response = new HashMap<>();
        try {
            postService.updatePostTop(postId, top);
            response.put("success", true);
            response.put("message", "更新帖子[" + postId + "]置顶成功");
            return ResponseEntity.ok(response);
        } catch (RuntimeException e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }
    @PostMapping("/essence")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> essence(
            @RequestParam("postId") Integer postId,
            @RequestParam("isEssence") Integer essence) {
        Map<String, Object> response = new HashMap<>();
        try {
            postService.updatePostEssence(postId, essence);
            response.put("success", true);
            response.put("message", "更新帖子[" + postId + "]精华成功");
            return ResponseEntity.ok(response);
        } catch (RuntimeException e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }
    @GetMapping("/update")
    public ModelAndView update(
            @RequestParam("postId") Integer postId){
        ModelAndView mv = new ModelAndView();
        mv.setViewName("post-modal");
        try {
            Post post = postService.getbyId(postId);
            mv.addObject("post", post);
            mv.addObject("attachments", attachmentService.getAttachmentByPostId(postId));
             mv.addObject("categories", categoryService.listCategories());
             return mv;
        } catch (RuntimeException e) {
             mv.addObject("error", e.getMessage());
             mv.setViewName("post-modal");
             return mv;
        }
    }

    @PostMapping("/update")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> update(
            @RequestParam("postId") Integer postId,
            @RequestParam("title") String title,
            @RequestParam("content") String content,
            @RequestParam("categoryId") Integer categoryId,
            @RequestParam(name = "newAttachments", required = false) MultipartFile[] newAttachments,
            @RequestParam(name = "deletedAttachments", required = false) String[] deletedAttachments,
            HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        User user = (User) session.getAttribute("user");
        try {

            Post post = new Post();
            post.setId(postId);
            post.setTitle(title);
            post.setContent(content);
            post.setCategoryId(categoryId);
            if(postService.getbyId(postId).getStatus() >= Post.STATUS_KNOWLEDGE_WAITING_AUDIT){
                post.setStatus(Post.STATUS_KNOWLEDGE_WAITING_AUDIT);
            }else{
                post.setStatus(Post.STATUS_WAITING_AUDIT);
            }
            if (newAttachments != null && newAttachments.length > 0){
                List<Attachment> attachments = new ArrayList<>();

                for (MultipartFile file : newAttachments){
                    if (file.isEmpty()) {
                        continue;
                    }
                    Attachment attachment = new Attachment();
                    attachment.setPostId(post.getId());
                    Set<String> imgExtensions = Set.of("jpg", "jpeg", "png", "gif");
                    Set<String> videoExtensions = Set.of("mp4", "mkv");
                    Set<String> allowedExtensions = Set.of("pdf", "doc", "docx", "xls", "xlsx", "ppt", "pptx", "zip", "7z");
                    String extension = FilenameUtils.getExtension(file.getOriginalFilename()).toLowerCase();
                    if (imgExtensions.contains(extension)){
                        attachment.setFileType("image/" + extension);
                        String newFileName = post.getId() + "_" + System.currentTimeMillis() + "." + extension;
                        attachment.setFilePath(newFileName);
                        Path uploadDir = Paths.get(
                                session.getServletContext().getRealPath("/static/uploads/attachments/img/")
                        );
                        attachments.add(attachment);
                        Files.createDirectories(uploadDir);
                        file.transferTo(uploadDir.resolve(newFileName));
                    }else if (videoExtensions.contains(extension)){
                        attachment.setFileType("video/" + extension);
                        String newFileName = post.getId() + "_" + System.currentTimeMillis() + "." + extension;
                        attachment.setFilePath(newFileName);
                        Path uploadDir = Paths.get(
                                session.getServletContext().getRealPath("/static/uploads/attachments/video/")
                        );
                        attachments.add(attachment);
                        Files.createDirectories(uploadDir);
                        file.transferTo(uploadDir.resolve(newFileName));
                    }else if (allowedExtensions.contains(extension)){
                        attachment.setFileType("application/" + extension);
                        String newFileName = post.getId() + "_" + System.currentTimeMillis() + "_" + file.getOriginalFilename() + "." + extension;
                        attachment.setFilePath(newFileName);
                        Path uploadDir = Paths.get(
                                session.getServletContext().getRealPath("/static/uploads/attachments/file/")
                        );
                        attachments.add(attachment);
                        Files.createDirectories(uploadDir);
                        file.transferTo(uploadDir.resolve(newFileName));
                    }else {
                        throw new RuntimeException("未知文件类型");
                    }
                }
                attachmentService.postAttachment(attachments);
            }

            postService.updatePost(post);
            if (deletedAttachments != null){
                for (String attachmentId : deletedAttachments){
                    if (attachmentId != null && !attachmentId.isEmpty()){
                        Attachment attachment = attachmentService.getAttachmentById(Integer.parseInt(attachmentId));
                        attachmentService.deleteAttachmentById(Integer.parseInt(attachmentId));
                        if (attachment.getFileType().startsWith("image")) {
                            Path filePath = Paths.get(
                                    session.getServletContext().getRealPath("/static/uploads/attachments/img/" + attachment.getFilePath())
                            );
                            Files.delete(filePath);
                        }
                        if ( attachment.getFileType().startsWith("video")){
                            Path filePath = Paths.get(
                                    session.getServletContext().getRealPath("/static/uploads/attachments/video/" + attachment.getFilePath())
                            );
                            Files.delete(filePath);
                        }
                        if (attachment.getFileType().startsWith("application")){
                            Path filePath = Paths.get(
                                    session.getServletContext().getRealPath("/static/uploads/attachments/file/" + attachment.getFilePath())
                            );
                            Files.delete(filePath);
                        }
                    }
                }
            }
            response.put("success", true);
            response.put("msg", "更新成功");
            return ResponseEntity.ok(response);
        }catch (RuntimeException | IOException e) {
            response.put("success", false);
            response.put("msg", e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }
    @PostMapping("/like")
    public void like(
            @RequestParam("postId") Integer postId,
            HttpSession session) {
        User user = (User) session.getAttribute("user");
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

    @GetMapping("/more")
     public ModelAndView more(
            HttpSession session) {
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("more_posts");
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
        ModelAndView model = new ModelAndView("more-post-frag");
        Post searchPost = new Post();
        searchPost.setTitle(keyword);
        searchPost.setUsername(keyword);
        searchPost.setCategoryId(category);
        searchPost.setStatus(Post.STATUS_PUBLISHED);
        PageInfo<Post> postList = postService.searchPosts(page, size, searchPost);
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
        model.addObject("postVOs", postVOs);
        model.addObject("hasMore", postList.isHasNextPage());
        return model;

    }
}

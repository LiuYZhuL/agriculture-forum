package com.agriculture.controller;

import com.agriculture.model.dto.LoginUser;
import com.agriculture.model.dto.RegisterUser;
import com.agriculture.model.dto.SelectPost;
import com.agriculture.model.dto.UpdateUser;
import com.agriculture.model.po.Attachment;
import com.agriculture.model.po.Category;
import com.agriculture.model.po.Post;
import com.agriculture.model.po.User;
import com.agriculture.model.vo.KnowledgeVO;
import com.agriculture.model.vo.PostVO;
import com.agriculture.service.*;
import com.github.pagehelper.PageInfo;
import com.mysql.cj.Session;
import jakarta.servlet.http.HttpSession;
import org.apache.commons.io.FilenameUtils;
import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
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
import java.util.Objects;
import java.util.Set;

@Controller
@RequestMapping("/api/user")
public class UserController {
    @Autowired
    private UserService userService;
    @Autowired
    private PostService postService;
    @Autowired
    private CategoryService categoryService;
    @Autowired
    private AttachmentService attachmentService;
    @Autowired
    private CommentService commentService;



    /**
     * 登录页面
     * @return ModelAndView
     */
    @GetMapping("/login")
    public ModelAndView login() {
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("login");
        return modelAndView;
    }
    /**
     * 登录
     * @param loginUser 登录用户名和密码
     * @param session 会话
     * @return ModelAndView
     * @throws RuntimeException 运行时异常
     */
    @PostMapping("/login")
    public ModelAndView login(@Valid LoginUser loginUser,
                              HttpSession session){
        ModelAndView modelAndView = new ModelAndView();
        User user;
        try {
            user = userService.login(loginUser);
        } catch (RuntimeException runtimeException) {
            modelAndView.setViewName("login");
            modelAndView.addObject("error", runtimeException.getMessage());
            modelAndView.addObject("loginUser", loginUser);
            return modelAndView;
        }
        session.setAttribute("user", user);
        //重定向到首页
        modelAndView.setViewName("redirect:/");
        return modelAndView;
    }
    /**
     * 注册页面
     * @return ModelAndView
     */
    @GetMapping("/register")
    public ModelAndView register() {
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("register");
        return modelAndView;
    }
    /**
     * 注册
     * @param registerUser 注册用户名、密码、邮箱
     * @param session 会话
     * @return ModelAndView
     * @throws RuntimeException 运行时异常
     */
    @PostMapping("/register")
    public ModelAndView register(@Valid RegisterUser registerUser,
                                HttpSession session){
        ModelAndView modelAndView = new ModelAndView();
        try {
            userService.register(registerUser);
        } catch (RuntimeException runtimeException) {
            modelAndView.setViewName("register");
            modelAndView.addObject("error", runtimeException.getMessage());
            System.out.println(registerUser);
            modelAndView.addObject("registerUser", registerUser);
            System.out.println(modelAndView.getModel().get("registerUser"));
            return modelAndView;
        }
        LoginUser loginUser = new LoginUser();
        loginUser.setUsername(registerUser.getUsername());
        loginUser.setPassword(registerUser.getPassword());
        modelAndView.addObject("loginUser", loginUser);

        modelAndView.setViewName("login");
        return modelAndView;
    }

    /**
     * 注销
     * @param session 会话
     * @return ModelAndView
     */
    @GetMapping("/logout")
    public ModelAndView logout(HttpSession session) {
        ModelAndView modelAndView = new ModelAndView();
        try {
            User user = (User) session.getAttribute("user");
            userService.logout(user);
        } catch (RuntimeException runtimeException) {
            modelAndView.setViewName("dashboard");
            modelAndView.addObject("error", runtimeException.getMessage());
            return modelAndView;
        }
        session.invalidate();
        modelAndView.setViewName("redirect:/");
        return modelAndView;
    }

    /**
     * 个人中心页面
     * @param session 会话
     * @return ModelAndView
     */
    @GetMapping("/home")
    public ModelAndView home(HttpSession session) {
        ModelAndView modelAndView = new ModelAndView();
        User user = (User) session.getAttribute("user");
        List<PostVO> postVOs = new ArrayList<>();
        List<Post> postList = postService.getCollectPostsByUser(user.getId());
        for (Post p : postList) {
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
        List<KnowledgeVO>  knowledgeVOs = new ArrayList<>();
        List<Post> knowledgeList = postService.getCollectKnowledgeByUser(user.getId());
        for (Post k : knowledgeList) {
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
        modelAndView.addObject("user", user);
        modelAndView.setViewName("home");
        return modelAndView;
    }

    /**
     * 忘记密码页面
     * @return ModelAndView
     */
    @GetMapping("/reset")
    public ModelAndView reset() {
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("reset");
        return modelAndView;
    }

    /**
     * 忘记密码
     * @param username 用户名
     * @param email 邮箱
     * @return ModelAndView
     */
    @PostMapping("/reset")
    public ModelAndView reset(
            @RequestParam("username") String username,
            @RequestParam("email") String email)
    {
        ModelAndView  modelAndView = new ModelAndView();
        try {
            String newPassword = userService.resetPassword(username, email);
            modelAndView.addObject("newPassword", "新密码是"+newPassword);
            modelAndView.setViewName("reset");
            return modelAndView;
        }catch (RuntimeException runtimeException){
            modelAndView.setViewName("reset");
            modelAndView.addObject("error", runtimeException.getMessage());
            return modelAndView;
        }
    }
    /**
     * 修改头像
     * @param avatar 头像文件
     *              头像文件上传到服务器
     * @param session 会话
     * @return ModelAndView
     * @throws RuntimeException 运行时异常
     */
    @PostMapping("/avatar")
    public ModelAndView avatar(@RequestParam("avatar") MultipartFile avatar,
                               HttpSession session) {
        ModelAndView modelAndView = new ModelAndView();
        User user = (User) session.getAttribute("user");
        modelAndView.addObject("activeSection", "avatar");
        modelAndView.setViewName("home");
        try {
            if (avatar.isEmpty()) {
                modelAndView.addObject("msgAvatar", "请选择上传文件");
                return modelAndView;
            }
             // 添加文件大小校验（最大10MB）
            if (avatar.getSize() > 10 * 1024 * 1024) {
                modelAndView.addObject("msgAvatar", "文件大小超过10MB限制");
                return modelAndView;
            }
            Set<String> allowedExtensions = Set.of("jpg", "jpeg", "png", "gif");
            String extension = FilenameUtils.getExtension(avatar.getOriginalFilename()).toLowerCase();

            if (!allowedExtensions.contains(extension)) {
                modelAndView.addObject("msgAvatar", "仅支持JPG/PNG/GIF格式");
                return modelAndView;
            }

             // 3. 生成唯一文件名
            String newFileName = user.getId() + "_" + System.currentTimeMillis() + "." + extension;
             // 4. 保存文件
             // 修改文件保存路径为服务器部署路径
            Path uploadDir = Paths.get(
                    session.getServletContext().getRealPath("/static/uploads/img")
            );

            Files.createDirectories(uploadDir);
            avatar.transferTo(uploadDir.resolve(newFileName));
            String oldFileName = user.getAvatar();
             // 5. 更新用户头像路径（需实现UserService
            userService.updateAvatar(user.getId(), newFileName);
            // 6. 更新会话中的用户信息
            user = userService.getUserById(user.getId());
            // 7. 删除旧头像文件
            if (!oldFileName.equals("default_avatar.png")){
                Path oldFilePath = Paths.get(
                        session.getServletContext().getRealPath("/static/uploads/img"),
                        oldFileName
                );
                if (Files.exists(oldFilePath)) {
                    Files.delete(oldFilePath);
                }
            }
            session.setAttribute("user", user);
            modelAndView.addObject("msgAvatar", "上传成功");
        } catch (IOException e) {
            throw new RuntimeException(e);
        } catch (RuntimeException runtimeException) {
            modelAndView.addObject("msgAvatar", runtimeException.getMessage());
            return modelAndView;
        }
        return modelAndView;

    }
    /**
     * 修改个人信息
     * @Param username  用户名
     * @Param email 邮箱
     * @Param session 会话
     * @return ModelAndView
     */
     @PostMapping("/update")
     public ModelAndView update(
             @RequestParam("username") String username,
             @RequestParam("email") String email,
             HttpSession session){
         ModelAndView modelAndView = new ModelAndView();
         User user = (User) session.getAttribute("user");
         modelAndView.addObject("activeSection", "info");
         modelAndView.setViewName("home");
         UpdateUser updateUser = new UpdateUser();
         updateUser.setId(user.getId());
         updateUser.setUsername(username);
         updateUser.setEmail(email);
         try {
             userService.updateUserInfo(updateUser);
             modelAndView.addObject("msgUpdate", "修改成功");
             return modelAndView;
         }catch (RuntimeException runtimeException){
             modelAndView.addObject("msgUpdate", runtimeException.getMessage());
             return modelAndView;
         }
     }

    /**
     * 修改个人密码
     * @param password 旧密码
     * @param newPassword 新密码
     * @param session 会话
     * @return ModelAndView
     * msgChange: 修改成功/失败信息
     */
    @PostMapping("/change")
    public ModelAndView change(

            @RequestParam("password") String password,
            @RequestParam("newPassword") String newPassword,
            HttpSession session){
        ModelAndView modelAndView = new ModelAndView();
        User user = (User) session.getAttribute("user");
        modelAndView.addObject("activeSection", "change");
        modelAndView.setViewName("home");
            try {
                userService.changePassword(new UpdateUser(user.getId(),user.getUsername(), password, newPassword,user.getEmail()));
                modelAndView.addObject("msgChange", "修改成功");
                return modelAndView;
            }catch (RuntimeException runtimeException){
                modelAndView.addObject("msgChange", runtimeException.getMessage());
                return modelAndView;
            }
    }
    /**
     * 获取用户列表
     * @param pageNum 页码
     * @param pageSize 每页数量
     * @param selectPost 查询条件
     * @return ModelAndView
     */
    @GetMapping("/post")
    public ModelAndView ListPosts(
            @RequestParam(value = "pageNum", defaultValue = "1")Integer pageNum,
            @RequestParam(value = "pageSize", defaultValue = "5") Integer pageSize,
            @Valid SelectPost selectPost,
            HttpSession   session )
    {
        ModelAndView mv = new ModelAndView();
        mv.addObject("activeSection","post");
        mv.addObject("selectPost", selectPost);
        User user = (User) session.getAttribute("user");
        Post post = new Post();
        post.setUserId(user.getId());
        post.setId(selectPost.getPostId());
        post.setTitle(selectPost.getTitle());
        post.setUsername(selectPost.getUser());
        post.setCategoryId(selectPost.getCategoryId());
        post.setStatus(selectPost.getSts());
        post.setIsTop(selectPost.getIsTop());
        post.setIsEssence(selectPost.getIsEssence());
        PageInfo<Post> pagePost;
        try {
            pagePost = postService.searchPosts(pageNum, pageSize, post);
            List<Category> categories = categoryService.listCategories();
            mv.addObject("categories", categories);
            mv.addObject("postSuccess", true);
            mv.addObject("postMsg", "帖子列表获取成功");
            mv.addObject("pagePost", pagePost);
            mv.setViewName("home");
            return mv;
        } catch (RuntimeException e) {
            e.printStackTrace();
            mv.addObject("postSuccess", false);
            mv.addObject("postMsg", e.getMessage());
            mv.setViewName("home");
            return mv;
        }
    }

}

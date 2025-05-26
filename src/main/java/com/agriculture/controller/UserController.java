package com.agriculture.controller;

import com.agriculture.model.dto.LoginUser;
import com.agriculture.model.dto.RegisterUser;
import com.agriculture.model.po.User;
import com.agriculture.service.UserService;
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
import java.util.Objects;
import java.util.Set;

@Controller
@RequestMapping("/api/user")
public class UserController {
    @Autowired
    private UserService userService;
    @GetMapping("/login")
    public ModelAndView login() {
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("login");
        return modelAndView;
    }
    /*
     * 登录
     * @param loginUser 登录用户名和密码
     * @param bindingResult 验证结果
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
        modelAndView.setViewName("dashboard");
        return modelAndView;
    }
    @GetMapping("/register")
    public ModelAndView register() {
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("register");
        return modelAndView;
    }
    /*
     * 注册
     * @param registerUser 注册用户名、密码、邮箱
     * @param bindingResult 验证结果
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
        modelAndView.setViewName("dashboard");
        return modelAndView;
    }
    @GetMapping("/home")
    public ModelAndView home(HttpSession session) {
        ModelAndView modelAndView = new ModelAndView();
        User user = (User) session.getAttribute("user");
        if(user==null){
            modelAndView.setViewName("login");
            return modelAndView;
        }
        modelAndView.addObject("user", user);
        modelAndView.setViewName("home");
        return modelAndView;
    }
    //  重置密码
    @GetMapping("/reset")
    public ModelAndView reset() {
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("reset");
        return modelAndView;
    }
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
        if (user == null){
            modelAndView.setViewName("login");
            return modelAndView;
        }
        modelAndView.addObject("activeSection", "avatar");
        modelAndView.setViewName("home");
        try {
            if (avatar.isEmpty()) {
                modelAndView.addObject("message", "请选择上传文件");
                return modelAndView;
            }
             // 添加文件大小校验（最大10MB）
            if (avatar.getSize() > 10 * 1024 * 1024) {
                modelAndView.addObject("message", "文件大小超过10MB限制");
                return modelAndView;
            }
            Set<String> allowedExtensions = Set.of("jpg", "jpeg", "png", "gif");
            String extension = FilenameUtils.getExtension(avatar.getOriginalFilename()).toLowerCase();

            if (!allowedExtensions.contains(extension)) {
                modelAndView.addObject("message", "仅支持JPG/PNG/GIF格式");
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
             // 5. 更新用户头像路径（需实现UserService
            userService.updateAvatar(user.getId(), newFileName);
            // 6. 更新会话中的用户信息
            user = userService.getUserById(user.getId());
            session.setAttribute("user", user);
            modelAndView.addObject("message", "上传成功");
        } catch (IOException e) {
            throw new RuntimeException(e);
        } catch (RuntimeException runtimeException) {
            modelAndView.addObject("message", runtimeException.getMessage());
            return modelAndView;
        }
        return modelAndView;

    }
}

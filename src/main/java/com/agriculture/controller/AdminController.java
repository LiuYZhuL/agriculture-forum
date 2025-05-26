package com.agriculture.controller;
import com.agriculture.model.dto.SelectUser;
import com.agriculture.model.dto.UpdateUser;
import com.agriculture.model.po.Role;
import com.github.pagehelper.PageInfo;
import com.agriculture.model.po.User;
import com.agriculture.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.apache.commons.io.FilenameUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import javax.validation.Valid;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.Set;

@Controller
@RequestMapping("/api/admin")
public class AdminController {
    @Autowired
    private UserService userService;
    /**
     * 管理用户页面
     * @return ModelAndView
     */
    @GetMapping("/manage")
    public ModelAndView manage(){
        ModelAndView mv = new ModelAndView();
        mv.setViewName("manage");
        PageInfo<User> pageInfo = userService.listUsers(1, 5, new User());
        mv.addObject("pageInfo", pageInfo);
        return mv;
    }

    /**
     * 前往修改用户页面
     * @param userId 用户id
     * @return ModelAndView
     */
    @GetMapping("/user/update")
    public ModelAndView updateUser(
            @RequestParam("userId") Integer userId){
        ModelAndView mv = new ModelAndView();
        mv.setViewName("userUD");
        try {
            User updateUser = userService.getUserById(userId);
            mv.addObject("updateUser", updateUser);
            return mv;
        }catch (RuntimeException e) {
            mv.addObject("activeSection","userMgt");
            mv.addObject("userSuccess", false);
            mv.addObject("userMsg", e.getMessage());
            mv.setViewName("manage");
            return mv;
        }
    }

    /**
     * 更新用户信息
     * @param id 用户id
     * @param avatar 用户头像
     * @param username 用户名
     * @param email 用户邮箱
     * @param roleId 用户角色id
     * @param status 用户状态
     * @return ModelAndView
     */
    @PostMapping("/user/update")
    public ModelAndView updateUserInfo(
            @RequestParam("id") Integer id,
            @RequestParam("avatar") MultipartFile avatar,
            @RequestParam("username") String username,
            @RequestParam("email") String email,
            @RequestParam("roleId") Integer roleId,
            @RequestParam("status") Integer status,
            HttpSession session){
        ModelAndView mv = new ModelAndView();
        mv.setViewName("redirect:/api/admin/user/update?userId=" + id);
        try{
            UpdateUser updateUser = new UpdateUser();
            updateUser.setId(id);
            updateUser.setUsername(username);
            updateUser.setEmail(email);
            userService.updateUserInfo(updateUser);
            if (!avatar.isEmpty()){
                if (avatar.getSize() > 10 * 1024 * 1024) {
                    mv.addObject("msg", "文件大小超过10MB限制");
                    return mv;
                }
                Set<String> allowedExtensions = Set.of("jpg", "jpeg", "png", "gif");
                String extension = FilenameUtils.getExtension(avatar.getOriginalFilename()).toLowerCase();

                if (!allowedExtensions.contains(extension)) {
                    mv.addObject("msg", "仅支持JPG/PNG/GIF格式");
                    return mv;
                }
                // 3. 生成唯一文件名
                String newFileName = id + "_" + System.currentTimeMillis() + "." + extension;
                // 4. 保存文件
                // 修改文件保存路径为服务器部署路径
                Path uploadDir = Paths.get(
                        session.getServletContext().getRealPath("/static/uploads/img")
                );

                Files.createDirectories(uploadDir);
                avatar.transferTo(uploadDir.resolve(newFileName));
                // 5. 更新用户头像路径（需实现UserService
                userService.updateAvatar(id, newFileName);
            }

            userService.updateUserStatus(id, status);
            userService.updateUserRole(id, roleId);
            mv.addObject("success", true);
            mv.addObject("msg", "更新成功");
            return mv;
        } catch (IOException e) {
            throw new RuntimeException(e);
        } catch (RuntimeException e) {
            mv.addObject("success", false);
            mv.addObject("msg", e.getMessage());
            return mv;
        }
    }
    /**
     * 重置用户密码
     * @param userId 用户id
     * @return ModelAndView
     */
    @GetMapping("/user/reset")
    public ModelAndView resetUserPassword(
            @RequestParam("userId") Integer userId){
        ModelAndView mv = new ModelAndView();
        try {
            userService.resetPassword(userId);
            mv.addObject("userSuccess", true);
            mv.addObject("userMsg", "用户[" + userId + "]的密码重置成功");
        } catch (RuntimeException e) {
            mv.addObject("userSuccess", false);
            mv.addObject("userMsg", e.getMessage());
        }
        mv.addObject("activeSection","userMgt");
        PageInfo<User> pageInfo = userService.listUsers(1, 5, new User());
        mv.addObject("pageInfo", pageInfo);
        mv.setViewName("manage");
        return mv;
    }


    /**
     * 获取用户列表（分页查询）
     * @param pageNum 页码
     * @param pageSize 页容量
     * @param selectUser 查询条件
     * @return ModelAndView
     */
    @GetMapping("/manage/user")
    public ModelAndView listUsers(
            @RequestParam(value = "pageNum", defaultValue = "1") Integer pageNum,
            @RequestParam(value = "pageSize", defaultValue = "5") Integer pageSize,
            @Valid SelectUser selectUser){
        ModelAndView mv = new ModelAndView();
        mv.addObject("activeSection","userMgt");
        User user = new User();
        user.setId(selectUser.getId());
        user.setUsername(selectUser.getUsername());
        user.setEmail(selectUser.getEmail());
        if (selectUser.getStatus() != null){
            if (selectUser.getStatus().equals(User.STATUS_LOCKED)){
                user.setStatus(User.STATUS_LOCKED);
            }else if (selectUser.getStatus().equals(User.STATUS_NORMAL)){
                user.setStatus(User.STATUS_NORMAL);
            }
        }
        if (selectUser.getRoleId() != null){
            if (selectUser.getRoleId().equals(Role.ROLE_ADMIN)){
                user.setRoleId(Role.ROLE_ADMIN);
            }else if (selectUser.getRoleId().equals(Role.ROLE_USER)){
                user.setRoleId(Role.ROLE_USER);
            }
        }
        mv.addObject("selectUser", selectUser);

        try{
            PageInfo<User> pageInfo = userService.listUsers(pageNum, pageSize, user);
            mv.addObject("pageInfo", pageInfo);
            mv.addObject("userSuccess", true);
            mv.addObject("userMsg", "用户列表获取成功");
            mv.setViewName("manage");
            return mv;
        }catch (RuntimeException e) {
            mv.addObject("userSuccess", false);
            mv.addObject("userMsg", e.getMessage());
            mv.setViewName("manage");
            return mv;
        }
    }

}

package com.agriculture.controller;
import com.agriculture.model.dto.SelectUser;
import com.agriculture.model.dto.UpdateUser;
import com.agriculture.model.po.Category;
import com.agriculture.model.po.Role;
import com.agriculture.service.CategoryService;
import com.github.pagehelper.PageInfo;
import com.agriculture.model.po.User;
import com.agriculture.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.apache.commons.io.FilenameUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.validation.Valid;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

@Controller
@RequestMapping("/api/admin")
public class AdminController {
    @Autowired
    private UserService userService;
    @Autowired
    private CategoryService categoryService;


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
            mv.setViewName("usermgt");
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
                String oldFileName = userService.getUserById(id).getAvatar();
                Files.createDirectories(uploadDir);
                avatar.transferTo(uploadDir.resolve(newFileName));

                // 5. 更新用户头像路径（需实现UserService
                userService.updateAvatar(id, newFileName);
                if (!oldFileName.equals("default_avatar.png")){
                    Path oldFilePath = Paths.get(
                            session.getServletContext().getRealPath("/static/uploads/img"),
                            oldFileName
                    );
                    if (Files.exists(oldFilePath)) {
                        Files.delete(oldFilePath);
                    }
                }
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
    @PostMapping("/user/reset/{userId}")
    public ModelAndView resetUserPassword(
            @PathVariable("userId") Integer userId,
            @RequestParam(name = "id", required = false) Integer id,
            @RequestParam(name = "username", required = false) String username,
            @RequestParam(name = "email", required = false) String email,
            @RequestParam(name = "roleId", defaultValue = "0") Integer roleId,
            @RequestParam(name = "status", defaultValue = "2") Integer status,
            @RequestParam(name = "pageNum",  defaultValue = "1") Integer pageNum){
        ModelAndView mv = new ModelAndView();
        try {
            User user = new User(id, username, null, email, null, null, null, null, null, null);
            if(roleId != 0) user.setRoleId(roleId);
            if(status != 2) user.setStatus(status);
            SelectUser selectUser = new SelectUser(id, username, email, roleId, status);
            userService.resetPassword(userId);
            mv.addObject("userSuccess", true);
            mv.addObject("userMsg", "用户[" + userId + "]的密码重置成功");
            PageInfo<User> pageInfo = userService.listUsers(pageNum, 5, user);
            mv.addObject("pageInfo", pageInfo);
            mv.addObject("selectUser", selectUser);
        } catch (RuntimeException e) {
            mv.addObject("userSuccess", false);
            mv.addObject("userMsg", e.getMessage());
        }
        mv.addObject("activeSection","userMgt");


        mv.setViewName("usermgt");
        return mv;
    }

    @GetMapping("/category/delete")
    public ModelAndView deleteCategory(
            @RequestParam("categoryId") Integer categoryId){
        ModelAndView mv = new ModelAndView();
        try {
            String categoryName = categoryService.getCategoryById(categoryId).getName();
            categoryService.deleteCategory(categoryId);
            mv.addObject("categorySuccess", true);
            mv.addObject("categoryMsg", "分类[" + categoryName + "]删除成功");
        } catch (RuntimeException e) {
            mv.addObject("categorySuccess", false);
            mv.addObject("categoryMsg", e.getMessage());
        }
        mv.addObject("activeSection","categoryMgt");
        PageInfo<Category> pageCategory = categoryService.listCategories(1, 5);
        mv.addObject("pageCategory", pageCategory);
        mv.setViewName("categorymgt");
        return mv;
    }
    @PostMapping("/category/add")
    public ModelAndView addCategory(
            @RequestParam("categoryName") String categoryName,
            @RequestParam("categoryDesc") String categoryDesc,
            @RequestParam( name="pageNum", defaultValue = "1")Integer  pageNum){
        ModelAndView mv = new ModelAndView();
        try {
            Category category = new Category();
            category.setName(categoryName);
            category.setDescription(categoryDesc);
            categoryService.addCategory(category);
            mv.addObject("categorySuccess", true);
            mv.addObject("categoryMsg", "分类[" + categoryName + "]添加成功");
        } catch (RuntimeException e) {
            mv.addObject("categorySuccess", false);
            mv.addObject("categoryMsg", e.getMessage());
        }
        mv.addObject("activeSection","categoryMgt");
        PageInfo<Category> pageCategory = categoryService.listCategories(pageNum, 5);
        mv.addObject("pageCategory", pageCategory);
        mv.setViewName("categorymgt");
        return mv;
    }

    @PostMapping("/category/update")
    public ModelAndView updateCategory(
            @RequestParam("id") Integer id,
            @RequestParam("name") String name,
            @RequestParam(name = "description", required = false) String description) {

        ModelAndView mv = new ModelAndView("manage");
        mv.addObject("activeSection","categoryMgt");
        try {
            Category category = new Category();
            category.setId(id);
            category.setName(name);
            category.setDescription(description);
            categoryService.updateCategory(category);

            mv.addObject("categorySuccess", true);
            mv.addObject("categoryMsg", "分类修改成功");
        } catch (RuntimeException e) {
            mv.addObject("categorySuccess", false);
            mv.addObject("categoryMsg", e.getMessage());
        }
        return mv;
    }




}

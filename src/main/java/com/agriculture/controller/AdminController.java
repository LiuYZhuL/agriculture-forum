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
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
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
        mv.setViewName("user-modal");
        try {
            User user = userService.getUserById(userId);
            mv.addObject("user", user);
            return mv;
        }catch (RuntimeException e) {
            mv.addObject("userSuccess", false);
            mv.addObject("userMsg", e.getMessage());
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
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updateUserInfo(
            @RequestParam("id") Integer id,
            @RequestParam(name = "avatar",  required = false) MultipartFile avatar,
            @RequestParam("username") String username,
            @RequestParam("email") String email,
            @RequestParam("roleId") Integer roleId,
            @RequestParam("status") Integer status,
            HttpSession session){
        Map<String, Object> response = new HashMap<>();
        try{
            UpdateUser updateUser = new UpdateUser();
            updateUser.setId(id);
            updateUser.setUsername(username);
            updateUser.setEmail(email);
            userService.updateUserInfo(updateUser);
            if (avatar!= null && !avatar.isEmpty()){
                if (avatar.getSize() > 10 * 1024 * 1024) {
                    throw new RuntimeException("图片大小不能超过10M");
                }
                Set<String> allowedExtensions = Set.of("jpg", "jpeg", "png", "gif");
                String extension = FilenameUtils.getExtension(avatar.getOriginalFilename()).toLowerCase();

                if (!allowedExtensions.contains(extension)) {
                    throw new RuntimeException("图片格式不支持");
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
            response.put("success", true);
            response.put("msg", "用户信息更新成功");
            return ResponseEntity.ok(response);
        } catch (IOException | RuntimeException e) {
            response.put("success", false);
            response.put("msg", e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
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

    @DeleteMapping("/category/delete")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> deleteCategory(
            @RequestParam("categoryId") Integer categoryId){
        Map<String, Object> response = new HashMap<>();
        try {
            String categoryName = categoryService.getCategoryById(categoryId).getName();
            categoryService.deleteCategory(categoryId);
            response.put("success", true);
            response.put("msg", "分类[" + categoryName + "]删除成功");
            return ResponseEntity.ok(response);
        } catch (RuntimeException e) {
            response.put("success", false);
            response.put("msg", e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }
    @PostMapping("/category/add")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> addCategory(
            @RequestParam("categoryName") String categoryName,
            @RequestParam("categoryDesc") String categoryDesc){
        Map<String, Object> response = new HashMap<>();
        try {
            Category category = new Category();
            category.setName(categoryName);
            category.setDescription(categoryDesc);
            categoryService.addCategory(category);
            response.put("success", true);
            response.put("msg", "添加成功");
            return ResponseEntity.ok(response);
        } catch (RuntimeException e) {
            response.put("success", false);
            response.put("msg", e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    @GetMapping("/category/update")
    public ModelAndView Category(
            @RequestParam("categoryId") Integer categoryId){
        ModelAndView mv = new ModelAndView();
        mv.setViewName("category-modal");
        try {
            Category category = categoryService.getCategoryById(categoryId);
            mv.addObject("category", category);
            return mv;
        } catch (RuntimeException e) {
            mv.addObject("categorySuccess", false);
            mv.addObject("categoryMsg", e.getMessage());
            return mv;
        }
    }
    @PostMapping("/category/update")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updateCategory(
            @RequestParam("id") Integer id,
            @RequestParam("name") String name,
            @RequestParam(name = "description", required = false) String description) {

        Map<String, Object> response = new HashMap<>();
        try {
            Category category = new Category();
            category.setId(id);
            category.setName(name);
            category.setDescription(description);
            categoryService.updateCategory(category);

            response.put("success", true);
            response.put("msg", "分类信息更新成功");
            return ResponseEntity.ok(response);
        } catch (RuntimeException e) {
            response.put("success", false);
            response.put("msg", e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }




}

package com.agriculture.controller;

import com.agriculture.model.dto.SelectPost;
import com.agriculture.model.dto.SelectUser;
import com.agriculture.model.po.Category;
import com.agriculture.model.po.Post;
import com.agriculture.model.po.Role;
import com.agriculture.model.po.User;
import com.agriculture.service.CategoryService;
import com.agriculture.service.PostService;
import com.agriculture.service.UserService;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.validation.Valid;
import java.util.List;

@Controller
@RequestMapping("/api/admin/manage")
public class ManageController {
    @Autowired
    private UserService userService;

    @Autowired
    private CategoryService categoryService;
    @Autowired
    private PostService postService;
    /**
     * 管理用户页面
     * @return ModelAndView
     */
    @GetMapping("/")
    public ModelAndView manage(){
        ModelAndView mv = new ModelAndView();
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
    @GetMapping("/user")
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

    /**
     * 获取分类列表（分页查询）
     * @param pageNum 页码
     * @param pageSize 页容量
     * @param searchCategory 分类名称
     * @return ModelAndView
     */
    @GetMapping("/category")
    public ModelAndView ListCategories(
            @RequestParam(value = "pageNum", defaultValue = "1") Integer pageNum,
            @RequestParam(value = "pageSize", defaultValue = "5") Integer pageSize,
            @RequestParam(value = "searchCategory", required = false) String searchCategory){
        ModelAndView mv = new ModelAndView();
        mv.addObject("activeSection","categoryMgt");
        mv.addObject("searchCategory", searchCategory);
        try {
            if (searchCategory != null && !searchCategory.isEmpty()){
                PageInfo<Category> pageCategory = categoryService.searchCategories(searchCategory, pageNum, pageSize);
                mv.addObject("pageCategory", pageCategory);
            }else{
                PageInfo<Category> pageCategory = categoryService.listCategories(pageNum, pageSize);
                mv.addObject("pageCategory", pageCategory);
            }
            mv.addObject("categorySuccess", true);
            mv.addObject("categoryMsg", "分类列表获取成功");
            mv.setViewName("manage");
            return mv;
        }catch (RuntimeException e) {
            mv.addObject("categorySuccess", false);
            mv.addObject("categoryMsg", e.getMessage());
            mv.setViewName("manage");
            return mv;
        }
    }
    @GetMapping("/post")
    public ModelAndView ListPosts(
            @RequestParam(value = "pageNum", defaultValue = "1")Integer pageNum,
            @RequestParam(value = "pageSize", defaultValue = "5") Integer pageSize,
            @Valid SelectPost selectPost)
    {
        ModelAndView mv = new ModelAndView();
        mv.addObject("activeSection","postMgt");
        mv.addObject("selectPost", selectPost);
        Post post = new Post();
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
            mv.setViewName("manage");
            return mv;
        } catch (RuntimeException e) {
            e.printStackTrace();
            mv.addObject("postSuccess", false);
            mv.addObject("postMsg", e.getMessage());
            mv.setViewName("manage");
            return mv;
        }
    }
}

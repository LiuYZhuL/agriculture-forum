package com.agriculture.controller;

import com.agriculture.model.dto.SelectPost;
import com.agriculture.model.dto.SelectUser;
import com.agriculture.model.po.Category;
import com.agriculture.model.po.Post;
import com.agriculture.model.po.Role;
import com.agriculture.model.po.User;
import com.agriculture.model.vo.KnowledgeVO;
import com.agriculture.model.vo.PostVO;
import com.agriculture.service.*;
import com.github.pagehelper.PageInfo;
import com.mysql.cj.Session;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.validation.Valid;
import java.util.ArrayList;
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
    @Autowired
    private AttachmentService attachmentService;
    @Autowired
    private CommentService commentService;
    /**
     * 管理用户页面
     * @return ModelAndView
     */
    @GetMapping("/")
    public ModelAndView manage(
            @RequestParam(name = "section", required = false) String section,
            HttpSession session){
        ModelAndView modelAndView = new ModelAndView();
        User user = (User) session.getAttribute("user");
        modelAndView.addObject("section", section);
        modelAndView.addObject("user", user);
        modelAndView.setViewName("manage");
        return modelAndView;
    }

    /**
     * 获取用户列表（分页查询）
     * @param pageNum 页码
     * @param pageSize 页容量
     * @param selectUser 查询条件
     * @return ModelAndView
     */
    @GetMapping("/usermgt")
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
            mv.setViewName("usermgt");
            return mv;
        }catch (RuntimeException e) {
            mv.addObject("userSuccess", false);
            mv.addObject("userMsg", e.getMessage());
            mv.setViewName("usermgt");
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
    @GetMapping("/categorymgt")
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
            mv.setViewName("categorymgt");
            return mv;
        }catch (RuntimeException e) {
            mv.addObject("categorySuccess", false);
            mv.addObject("categoryMsg", e.getMessage());
            mv.setViewName("categorymgt");
            return mv;
        }
    }
    @GetMapping("/postmgt")
    public ModelAndView ListPosts(
            @RequestParam(value = "pageNum", defaultValue = "1")Integer pageNum,
            @RequestParam(value = "pageSize", defaultValue = "5") Integer pageSize,
            @RequestParam(name = "user", required = false) String user,
            @RequestParam(name = "title", required = false) String title,
            @RequestParam(name = "sts",  required = false) Integer sts,
            @RequestParam(name = "isTop", required = false) Integer isTop,
            @RequestParam(name = "isEssence", required = false) Integer isEssence,
            @RequestParam(name = "category", required = false) Integer category)
    {
        ModelAndView mv = new ModelAndView();
        mv.addObject("activeSection","postMgt");
        SelectPost selectPost = new SelectPost();
        selectPost.setUser(user);
        selectPost.setTitle(title);
        selectPost.setSts(sts);
        selectPost.setIsTop(isTop);
        selectPost.setIsEssence(isEssence);
        selectPost.setCategoryId(category);
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
            mv.setViewName("postmgt");
            return mv;
        } catch (RuntimeException e) {
            e.printStackTrace();
            mv.addObject("postSuccess", false);
            mv.addObject("postMsg", e.getMessage());
            mv.setViewName("postmgt");
            return mv;
        }
    }
    @GetMapping("/knowledgemgt")
    public ModelAndView ListKnowledge(
            @RequestParam(value = "pageNum", defaultValue = "1")Integer pageNum,
            @RequestParam(value = "pageSize", defaultValue = "5") Integer pageSize,
            @RequestParam(value = "ktitle", required = false) String ktitle,
            @RequestParam(value = "ksts"  , required = false) Integer ksts,
            @RequestParam(value = "kcategory", required = false) Integer kcategory,
            @RequestParam(value = "kisTop", required = false) Integer kisTop,
            @RequestParam(value = "kisEssence", required = false) Integer kisEssence)
    {
        ModelAndView mv = new ModelAndView();
        SelectPost selectK = new SelectPost();
        selectK.setTitle(ktitle);
        selectK.setSts(ksts);
        selectK.setCategoryId(kcategory);
        selectK.setIsTop(kisTop);
        selectK.setIsEssence(kisEssence);
        mv.addObject("activeSection","knowledgeMgt");
        mv.addObject("selectK", selectK);
        Post post = new Post();
        post.setId(selectK.getPostId());
        post.setTitle(selectK.getTitle());
        post.setUsername(selectK.getUser());
        post.setCategoryId(selectK.getCategoryId());
        post.setStatus(selectK.getSts());
        post.setIsTop(selectK.getIsTop());
        post.setIsEssence(selectK.getIsEssence());
        PageInfo<Post> pageK;
        try {
            pageK = postService.searchKnowledges(pageNum, pageSize, post);

            List<Category> categories = categoryService.listCategories();
            mv.addObject("categories", categories);
            mv.addObject("knowledgeSuccess", true);
            mv.addObject("knowledgeMsg", "知识列表获取成功");
            mv.addObject("pageK", pageK);
            mv.setViewName("knowledgemgt");
            return mv;
        } catch (RuntimeException e) {
            e.printStackTrace();
            mv.addObject("knowledgeSuccess", false);
            mv.addObject("knowledgeMsg", e.getMessage());
            mv.setViewName("knowledgemgt");
            return mv;
        }
    }
}

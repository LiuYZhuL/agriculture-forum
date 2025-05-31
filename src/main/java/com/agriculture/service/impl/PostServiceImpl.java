package com.agriculture.service.impl;

import com.agriculture.dao.InteractionMapper;
import com.agriculture.dao.PostMapper;
import com.agriculture.dao.UserMapper;
import com.agriculture.model.dto.AddPost;
import com.agriculture.model.po.Category;
import com.agriculture.model.po.Post;
import com.agriculture.model.po.User;
import com.agriculture.service.PostService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class PostServiceImpl implements PostService {
    @Autowired
    private PostMapper postMapper;
    @Autowired
    private UserMapper userMapper;
    @Autowired
    private InteractionMapper  interactionMapper;
    @Override
    public Post add(AddPost addPost) {
        if(addPost==null){
            throw new RuntimeException("参数错误");
        }
        if(addPost.getUserId()==null||addPost.getUserId()<=0){
            throw new RuntimeException("用户id不能为空");
        }
        if(addPost.getTitle()==null||addPost.getTitle().isEmpty()){
            throw new RuntimeException("帖子名不能为空");
        }
        if(addPost.getContent()==null||addPost.getContent().isEmpty()){
            throw new RuntimeException("帖子内容不能为空");
        }
        if(addPost.getCategoryId()==null||addPost.getCategoryId()<=0){
            throw new RuntimeException("帖子分类不能为空");
        }
        Post post = new Post();
        post.setUserId(addPost.getUserId());
        post.setTitle(addPost.getTitle());
        post.setContent(addPost.getContent());
        post.setCategoryId(addPost.getCategoryId());
        postMapper.insertPost(post);
        return post;
    }

    @Override
    public Post getbyId(Integer postId) {
        if(postId==null||postId<=0){
            throw new RuntimeException("帖子id不能为空");
        }
        Post post = postMapper.getPostById(postId);
        if(post==null){
            throw new RuntimeException("帖子不存在");
        }
        return post;
    }
    /**
     * 获取帖子列表
     * @param pageNum(web端分页参数)
     * @param pageSize(通常为 10)
     * 筛选条件 可为空 为空则查询全部用户
     * @return
     */
    @Override
    public PageInfo<Post> listPosts(int pageNum, int pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        List<Post> posts = postMapper.selectAllPost();
        return new PageInfo<>(posts, pageSize);
    }

    @Override
    public PageInfo<Post> searchPosts(int pageNum, int pageSize, Post post){
        try {
            PageHelper.startPage(pageNum, pageSize);
            List<Post> posts = postMapper.selectPostByCondition(post);
            return new PageInfo<>(posts, pageSize);
        } catch (Exception e){
            e.printStackTrace();
            throw new RuntimeException("搜索帖子失败");
        }
    }
    @Override
    public void deletePost(Integer postId) {
        if(postId==null||postId<=0){
            throw new RuntimeException("帖子id不能为空");
        }
        try {
            postMapper.deletePost(postId);
        } catch (Exception e){
            e.printStackTrace();
            throw new RuntimeException("删除帖子失败");
        }
    }

    @Override
    public void updatePostStatus(Integer postId, Integer status) {
        try {
            Post post = new Post();
            post.setId(postId);
            post.setStatus(status);
            postMapper.updatePost(post);
        } catch (Exception e){
            e.printStackTrace();
            throw new RuntimeException("修改帖子状态失败");
        }
    }

    @Override
    public void updatePostTop(Integer postId, Integer top) {
        try {
            Post post = new Post();
            post.setId(postId);
            post.setIsTop(top);
            postMapper.updatePost(post);
        } catch (Exception e){
            e.printStackTrace();
            throw new RuntimeException("修改帖子置顶状态失败");
        }

    }

    @Override
    public void updatePostEssence(Integer postId, Integer essence) {
        try {
            Post post = new Post();
            post.setId(postId);
            post.setIsEssence(essence);
            postMapper.updatePost(post);
        } catch (Exception e){
            e.printStackTrace();
            throw new RuntimeException("修改帖子精华状态失败");
        }
    }

    @Override
    public void updatePost(Post post) {
        if(post.getId()==null||post==null){
            throw new RuntimeException("参数错误");
        }
        if(postMapper.getPostById(post.getId())==null){
            throw new RuntimeException("帖子不存在");
        }
        if(post.getTitle()==null||post.getTitle().isEmpty()){
            throw new RuntimeException("帖子名不能为空");
        }
        if(post.getContent()==null||post.getContent().isEmpty()){
            throw new RuntimeException("帖子内容不能为空");
        }
        if(post.getCategoryId()==null||post.getCategoryId()<=0){
            throw new RuntimeException("帖子分类不能为空");
        }
        try  {
            postMapper.updatePost(post);
        } catch (Exception e){
            throw new RuntimeException("修改失败");
        }

    }
    @Override
    public User selectUserById(Integer userId) {
        User user = userMapper.getUserById(userId);
        if(user==null){
            throw new RuntimeException("用户不存在");
        }
        return user;
    }

    @Override
    public void updatePostViewCount(Integer postId) {
        try {
            postMapper.updatePostViewCount(postId);
        } catch (Exception e){
            throw new RuntimeException("更新帖子浏览次数失败");
        }
    }

    @Override
    public int getPostLikeCount(Integer postId) {
        try {
            return postMapper.selectPostLikeCount(postId);
        } catch (Exception e){
            throw new RuntimeException("获取帖子点赞数失败");
        }
    }

    @Override
    public int getPostCollectionCount(Integer postId) {
        try {
            return postMapper.selectPostCollectionCount(postId);
        } catch (Exception e){
            throw new RuntimeException("获取帖子收藏数失败");
        }

    }

    @Override
    public List<Post> getCollectPostsByUser(Integer userId) {
        try {
            return postMapper.selectCollectionPost(userId);
        }catch (Exception e){
            throw new RuntimeException("获取用户收藏帖子失败");
        }
    }

}

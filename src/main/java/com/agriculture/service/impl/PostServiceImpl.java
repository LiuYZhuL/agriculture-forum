package com.agriculture.service.impl;

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
    @Override
    public Post add(AddPost addPost) {
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
        post.setTitle(addPost.getTitle());
        post.setContent(addPost.getContent());
        post.setCategoryId(addPost.getCategoryId());
        postMapper.insertPost(post);
        return post;
    }

    @Override
    public Post getbyId(Integer postId) {
        return null;
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
    public PageInfo<Post> searchPosts(String searchText, int pageNum, int pageSize) {
        try {
            PageHelper.startPage(pageNum, pageSize);
            List<Post> posts= postMapper.searchPostsByTitle(searchText);
            return new PageInfo<>(posts, pageSize);
        } catch (Exception e){
            throw new RuntimeException("搜索分类失败");
        }
    }
    @Override
    public void deletePost(Integer postId) {

    }

    @Override
    public void updatePostStatus(Integer postId, Integer status) {

    }

    @Override
    public void updatePostRecommend(Integer postId, Integer recommend) {

    }

    @Override
    public void updatePostEssence(Integer postId, Integer essence) {

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

}

package com.agriculture.service.impl;

import com.agriculture.dao.PostMapper;
import com.agriculture.dao.UserMapper;
import com.agriculture.model.dto.AddPost;
import com.agriculture.model.po.Post;
import com.agriculture.service.PostService;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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
        if(postMapper.getPostsByTitle(addPost.getTitle())!=null ){
            throw new RuntimeException("帖子已存在");
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

    @Override
    public PageInfo<Post> listPosts(int pageNum, int pageSize, Post post) {
        return null;
    }

    @Override
    public void update(AddPost addPost) {

    }

    @Override
    public void delete(Integer postId) {

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


}

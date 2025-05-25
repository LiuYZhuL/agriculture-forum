package com.agriculture.dao;

import com.agriculture.model.po.Post;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface PostMapper {
    Post getPostById(int id);
    List<Post> getAllPosts();
    Post insertPost(Post post);
    void updatePost(Post post);
    void deletePost(int id);
    List<Post> getPostsByStatus(int status);
    List<Post> getPostsByCategory(int categoryId);
    List<Post> getPostsByUser(int userId);
    List<Post> getHotPosts();
    int getPostCount();
    int getPostCountByStatus(int status);
}

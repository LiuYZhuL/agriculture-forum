package com.agriculture.dao;

import com.agriculture.model.po.Post;
import com.agriculture.model.vo.PostBU;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface PostMapper {
    PostBU getPostById(int id);
    List<Post> getAllPosts();
    int insertPost(Post post);
    void updatePost(Post post);
    void deletePost(int id);
    List<Post> getPostsByStatus(int status);
    List<Post> getPostsByCategory(int categoryId);
    List<Post> getPostsByUser(int userId);
    List<Post> getHotPosts();
    int getPostCount();
    int getPostCountByStatus(int status);
    Post  getPostsByTitle(String title);
    List<Post> selectAllPost();
    List<Post> selectPostByCondition();
    List<Post> searchPostsByTitle(String title);
}

package com.agriculture.service;

import com.agriculture.model.dto.AddPost;
import com.agriculture.model.po.Post;
import com.github.pagehelper.PageInfo;

public interface PostService {
    // 添加帖子
    Post add(AddPost addPost);
    // 获取帖子
    Post getbyId(Integer postId);
    // 获取帖子列表
    PageInfo<Post> listPosts(int pageNum, int pageSize);
    // 修改帖子
    void updatePost(Post Post);
    // 删除帖子
    void deletePost(Integer postId);
    // 修改帖子状态
    void updatePostStatus(Integer postId, Integer status);
    //  推荐
    void updatePostRecommend(Integer postId, Integer recommend);
    //  置顶
    void updatePostEssence(Integer postId, Integer essence);
    // 搜索帖子
    PageInfo<Post> searchPosts(String searchText, int pageNum, int pageSize);
}

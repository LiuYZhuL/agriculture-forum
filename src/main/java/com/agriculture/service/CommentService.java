package com.agriculture.service;

import com.agriculture.model.po.Comment;

import java.util.List;

public interface CommentService {
    void addComment(Comment comment);
    void deleteComment(Integer commentId);
    void updateComment(Comment comment);
    List<Comment> getPCommentsByPostId(Integer postId);
    List<Comment> getCCommentsByPostId(Integer commentId);
    List<Comment> getCommentsByUserId(Integer userId);
    int getCommentCountByPostId(Integer postId);


}

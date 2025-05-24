package com.agriculture.dao;

import com.agriculture.model.po.Comment;

import java.util.List;

public interface CommentMapper {
    Comment insertComment(Comment comment);
    void batchInsertComment(List<Comment> comments);
    Comment deleteCommentById(int id);
    List<Comment> deleteCommentByPostId(int postId);
    Comment updateComment(Comment comment);
    Comment selectCommentById(int id);
    List<Comment> selectAllComment();
    List<Comment> selectCommentByPostId(int postId);
    List<Comment> selectCommentByUserId(int userId);
    List<Comment> selectCommentByParentId(int parentId);
    List<Comment> selectTopLevelCommentByPostId(int postId);
    List<Comment> selectCommentByCondition(Comment comment);
    int countCommentByPostId(int postId);
    int countCommentByUserId(int userId);



}

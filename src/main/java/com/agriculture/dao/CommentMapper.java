package com.agriculture.dao;

import com.agriculture.model.po.Comment;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
@Mapper
public interface CommentMapper {
    int insertComment(Comment comment);
    void batchInsertComment(List<Comment> comments);
    void deleteCommentById(int id);
    void deleteCommentByPostId(int postId);
    void deleteCommentByParentId(int parentId);
    void updateComment(Comment comment);
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

package com.agriculture.service.impl;

import com.agriculture.dao.CommentMapper;
import com.agriculture.model.po.Comment;
import com.agriculture.service.CommentService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
@Service
public class CommentServiceImpl implements CommentService {
    @Autowired
    private CommentMapper commentMapper;

    @Override
    public void addComment(Comment comment) {
        try {
            commentMapper.insertComment(comment);
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("添加评论失败");
        }

    }

    @Override
    public void deleteComment(Integer commentId) {
        try{
            commentMapper.deleteCommentById(commentId);
        }catch (Exception e){
            e.printStackTrace();
            throw new RuntimeException("删除评论失败");
        }
    }

    @Override
    public void updateComment(Comment comment) {

    }

    @Override
    public List<Comment> getPCommentsByPostId(Integer postId) {
        try {
            return commentMapper.selectTopLevelCommentByPostId(postId);
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("获取评论失败");
        }
    }

    @Override
    public List<Comment> getCCommentsByPostId(Integer commentId) {
        try {
            return commentMapper.selectCommentByParentId(commentId);
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("获取评论失败");
        }
    }

    @Override
    public List<Comment> getCommentsByUserId(Integer userId) {
        try {
            return commentMapper.selectCommentByUserId(userId);
        }catch (Exception e){
            e.printStackTrace();
            throw new RuntimeException("获取评论失败");
        }
    }

    @Override
    public int getCommentCountByPostId(Integer postId) {
        try {
            return commentMapper.countCommentByPostId(postId);
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("获取评论失败");
        }
    }
    @Override
    public PageInfo<Comment> getCommentsByPage(Integer postId, Integer pageNum, Integer pageSize) {
        try {
            PageHelper.startPage(pageNum, pageSize);
            List<Comment> comments = commentMapper.selectTopLevelCommentByPostId(postId);
            return new PageInfo<>(comments, pageSize);
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("获取评论失败");
        }
    }
}

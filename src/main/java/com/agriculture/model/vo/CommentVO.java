package com.agriculture.model.vo;

import com.agriculture.model.po.Comment;
import com.agriculture.service.CommentService;
import com.agriculture.service.UserService;
import com.agriculture.service.impl.CommentServiceImpl;
import com.agriculture.service.impl.UserServiceImpl;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
@Data
@NoArgsConstructor
@AllArgsConstructor
public class CommentVO {
    private Integer id;
    private Integer postId;
    private Integer userId;
    private String username;
    private String avatar;
    private String content;
    private Integer parentId;
    List<CommentVO> children;
    private Date createTime;

    public void setComment(Comment comment){
         this.id = comment.getId();
         this.postId = comment.getPostId();
         this.userId = comment.getUserId();
         this.content = comment.getContent();
         this.parentId = comment.getParentId();
         this.createTime = comment.getCreateTime();
         if (comment.getParentId() == null){
             this.children = new ArrayList<>();
         }
    }
}



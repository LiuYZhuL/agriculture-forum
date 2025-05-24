package com.agriculture.model.po;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Comment {

    private Integer id;


    private Integer postId;


    private Integer userId;

    private String content;


    private Integer parentId;


    private Date createTime;
}
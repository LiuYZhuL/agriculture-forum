package com.agriculture.model.po;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Post {
    private Integer id;

    private Integer userId;

    private Integer categoryId;

    private String title;
    private String content;
    private Integer type;  // 0-普通帖 1-问答帖

    private Integer status; // 0-待审核 1-已发布 2-已拒绝

    private Integer isTop;

    private Integer isEssence;

    private Integer bestAnswerId;

    private Date createTime;

    private Date updateTime;

    private Integer viewCount;
}
package com.agriculture.model.po;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Interaction {

    private Integer id;


    private Integer postId;


    private Integer userId;

    private Integer type; // 1-点赞 2-收藏

    private Date createTime;
    public static final Integer TYPE_LIKE = 1;
    public static final Integer TYPE_COLLECT = 2;
}
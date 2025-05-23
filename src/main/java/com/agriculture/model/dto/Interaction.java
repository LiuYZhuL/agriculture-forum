package com.agriculture.model.dto;

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
}
package com.agriculture.model.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;
@Data
@NoArgsConstructor
@AllArgsConstructor
public class PostBU {
    private Integer postId;
    private String title;
    private String user;
    private String category;
    private Integer top;
    private Integer essence;
    private Date  createTime;
    private Date updateTime;
    private Integer  status;
    private Integer  viewCount;


    
}

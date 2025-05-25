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

    private Integer status; // 0-待审核 1-已发布 2-已拒绝

    private Integer isTop;

    private Integer isEssence;

    private Integer bestAnswerId;

    private Date createTime;

    private Date updateTime;

    private Integer viewCount;
    public static final Integer STATUS_WAITING_AUDIT = 0;
    public static final Integer STATUS_PUBLISHED = 1;
    public static final Integer STATUS_REJECTED = 2;
    public static final Integer IS_NOT_TOP = 0;
    public static final Integer IS_TOP = 1;
    public static final Integer IS_NOT_ESSENCE = 0;
    public static final Integer IS_ESSENCE = 1;
}
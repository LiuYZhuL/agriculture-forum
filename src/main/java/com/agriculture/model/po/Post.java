package com.agriculture.model.po;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Post {
    /**
     * 帖子ID
     */
    private Integer id;

    /**
     * 发帖用户ID
     */
    private Integer userId;

    /**
     * 分类ID
     */
    private Integer categoryId;

    /**
     * 帖子标题
     */
    private String title;

    /**
     * 帖子内容
     */
    private String content;

    /**
     * 状态: 0-待审核 1-已发布 2-已拒绝
     * 知识类别：3-待审核 4-已发布 5-已拒绝
     */
    private Integer status;

    /**
     * 是否置顶: 0-否 1-是
     */
    private Integer isTop;

    /**
     * 是否精华: 0-否 1-是
     */
    private Integer isEssence;


    /**
     * 创建时间
     */
    private Date createTime;

    /**
     * 更新时间
     */
    private Date updateTime;

    /**
     * 浏览量
     */
    private Integer viewCount;

    /**
     * 结算状态: 0-未结算 1-已结算
     */
    private Integer isSettlement;

    public static final Integer STATUS_WAITING_AUDIT = 0;
    public static final Integer STATUS_PUBLISHED = 1;
    public static final Integer STATUS_REJECTED = 2;

     public static final Integer STATUS_KNOWLEDGE_WAITING_AUDIT = 3;
     public static final Integer STATUS_KNOWLEDGE_PUBLISHED = 4;
     public static final Integer STATUS_KNOWLEDGE_REJECTED = 5;

    public static final Integer IS_NOT_TOP = 0;
    public static final Integer IS_TOP = 1;

    public static final Integer IS_NOT_ESSENCE = 0;
    public static final Integer IS_ESSENCE = 1;

    public static final Integer SETTLEMENT_NOT = 0;
    public static final Integer SETTLEMENT_YES = 1;
    /**
     * 非数据库字段，用于存放发送该帖子的用户名称
     */
    private String username;
    /**
     * 非数据库字段，用于存放该帖子的分类名称
     */
    private String category;
}
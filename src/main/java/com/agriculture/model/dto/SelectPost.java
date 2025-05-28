package com.agriculture.model.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class SelectPost {
    /**
     * 帖子ID
     */
    private Integer PostId;

    /**
     * 发帖用户名
     */
    private String user;

    /**
     * 分类名称
     */
    private Integer categoryId;

    /**
     * 帖子标题
     */
    private String title;


    /**
     * 状态: 0-待审核 1-已发布 2-已拒绝
     */
    private Integer sts;

    /**
     * 是否置顶: 0-否 1-是
     */
    private Integer isTop;

    /**
     * 是否精华: 0-否 1-是
     */
    private Integer isEssence;
}

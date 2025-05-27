package com.agriculture.model.po;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

/**
 * 附件实体类
 * 用于存储论坛帖子相关的附件信息
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Attachment {

    /**
     * 附件ID - 主键
     */
    private Integer id;

    /**
     * 关联的帖子ID
     * 表示该附件属于哪个帖子
     */
    private Integer postId;

    /**
     * 文件存储路径
     * 可以是相对路径或绝对路径，指向实际存储的文件
     */
    private String filePath;

    /**
     * 文件类型
     * 例如: image/jpeg, application/pdf 等MIME类型
     */
    private String fileType;

    /**
     * 上传时间
     * 记录附件被上传到系统的时间
     */
    private Date uploadTime;
}

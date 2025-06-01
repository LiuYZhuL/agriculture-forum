package com.agriculture.model.vo;

import com.agriculture.model.po.Attachment;
import com.agriculture.model.po.Post;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class KnowledgeVO {
    private Post post;
    private String User;
    private String category;
    private Attachment attachment;
    private int viewCount;
    private int likeCount;
    private int collectionCount;
}


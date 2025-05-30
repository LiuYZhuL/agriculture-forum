package com.agriculture.model.vo;

import com.agriculture.model.po.Attachment;
import com.agriculture.model.po.Comment;
import com.agriculture.model.po.Post;
import com.agriculture.model.po.User;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class PostVO {
    private Post post;
    private String User;
    private String category;
    private Attachment attachment;
    private int commentCount;
    private int viewCount;
    private int likeCount;
    private int collectionCount;
}

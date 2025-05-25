package com.agriculture.dao;

import com.agriculture.model.po.Attachment;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface AttachmentMapper {
    Attachment insertAttachment(Attachment attachment);
    void batchInsertAttachment(List<Attachment> attachmentList);
    void deleteAttachmentById(int id);
    void deleteAttachmentByPostId(int postId);
    void updateAttachment(Attachment attachment);
    Attachment selectAttachmentById(int id);
    List<Attachment> selectAttachmentByPostId(int postId);
    List<Attachment> selectAttachmentByFileType(String fileType);
    List<Attachment> selectAttachmentByCondition(Attachment attachment);
    int countAttachmentByPostId(int postId);
    boolean existsAttachmentByFilePath(String filePath);


}

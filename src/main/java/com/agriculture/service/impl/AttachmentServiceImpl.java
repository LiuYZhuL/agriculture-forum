package com.agriculture.service.impl;

import com.agriculture.dao.AttachmentMapper;
import com.agriculture.model.po.Attachment;
import com.agriculture.service.AttachmentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
@Service
public class AttachmentServiceImpl implements AttachmentService {
    @Autowired
    private AttachmentMapper attachmentMapper;
    @Override
    public void postAttachment(List<Attachment> attachments) {
        try {
            attachmentMapper.batchInsertAttachment(attachments);
        }catch (Exception e){
            throw new RuntimeException("添加附件失败");
        }
    }

    @Override
    public void deleteAttachment(Attachment attachment) {
        try {
            attachmentMapper.deleteAttachmentById(attachment.getId());
        }catch (Exception e){
            throw new RuntimeException("删除附件失败");
        }
    }

    @Override
    public void deleteAttachmentByPostId(Integer PostId) {
        try {
            attachmentMapper.deleteAttachmentByPostId(PostId);
        }catch (Exception e){
            throw new RuntimeException("删除附件失败");
        }
    }

    @Override
    public List<Attachment> getAttachmentByPostId(Integer PostId) {
        try {
            return attachmentMapper.selectAttachmentByPostId(PostId);
        }catch (Exception e){
            throw new RuntimeException("获取附件失败");
        }
    }
}

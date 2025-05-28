package com.agriculture.service;

import com.agriculture.model.po.Attachment;

import java.util.List;

public interface AttachmentService {
    void postAttachment(List<Attachment> attachments);
    void deleteAttachment(Attachment attachment);
    void deleteAttachmentByPostId(Integer PostId);
    List<Attachment> getAttachmentByPostId(Integer PostId);


}

package com.agriculture.model.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Data
@NoArgsConstructor
@AllArgsConstructor

public class Attachment {

    private Integer id;


    private Integer postId;


    private String filePath;


    private String fileType;


    private Date uploadTime;
}
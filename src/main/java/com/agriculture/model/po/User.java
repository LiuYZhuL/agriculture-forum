package com.agriculture.model.po;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class User {
    private Integer id;
    private String username;
    private String password;
    private String email;
    private String avatar;
    private Integer roleId;
    private Integer status;
    private Date createTime;
    private Date lastLoginTime;
}


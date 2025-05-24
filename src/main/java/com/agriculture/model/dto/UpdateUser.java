package com.agriculture.model.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class UpdateUser {
    private String username;
    private String password;
    private String email;
    private String avatar;
    private int roleId;
    private int status;
    private Date lastLoginTime;
}

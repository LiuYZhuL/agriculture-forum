package com.agriculture.model.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class UpdateUser {
    private int id;
    private String username;
    private String password;
    private String newPassword;
    private String email;
}

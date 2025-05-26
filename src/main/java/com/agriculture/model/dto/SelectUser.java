package com.agriculture.model.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class SelectUser {
    private Integer id;
    private String username;
    private String email;
    private Integer roleId;
    private Integer status;
}

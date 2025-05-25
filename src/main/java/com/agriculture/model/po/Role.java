package com.agriculture.model.po;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Role {
    private Integer id;
    private String roleName;
    private String description;
    public static final Integer ROLE_USER = 1;
    public static final Integer ROLE_ADMIN = 2;
}

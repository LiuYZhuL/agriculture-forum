package com.agriculture.model.dto;

import javax.validation.constraints.Email;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Pattern;

public class RegisterUser {
    @NotBlank(message = "用户名不能为空")
    private String username;
    @Pattern(regexp = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$",
            message = "密码必须包含至少一个字母和一个数字，长度至少8位")
    private String password;
    @Email(message = "邮箱格式不正确")
    private String email;
}

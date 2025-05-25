package com.agriculture.service;

import com.agriculture.model.dto.LoginUser;
import com.agriculture.model.dto.RegisterUser;
import com.agriculture.model.dto.UpdateUser;
import com.agriculture.model.po.User;
import com.github.pagehelper.PageInfo;

public interface UserService {
    User login(LoginUser loginUser);
    User register(RegisterUser registerUser);
    void logout(User user);
    // 根据ID获取用户信息
    User getUserById(Integer userId);

    // 根据用户名获取用户信息
    User getUserByUsername(String username);

    // 更新用户基本信息
    void updateUserInfo(UpdateUser updateUser);

    // 修改密码
    void changePassword(UpdateUser updateUser);

    // 重置密码（忘记密码流程）
    String resetPassword(String username, String email);

    // 封禁/解封用户（管理员）
    void updateUserStatus(Integer userId, Integer status);

    // 修改用户角色（管理员）
    void updateUserRole(Integer userId, Integer roleId);

    // 分页查询用户列表（管理员）
    PageInfo<User> listUsers(int pageNum, int pageSize, User user);


}

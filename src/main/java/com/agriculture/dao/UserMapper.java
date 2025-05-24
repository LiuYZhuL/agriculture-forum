package com.agriculture.dao;

import com.agriculture.model.po.User;
import org.apache.ibatis.annotations.Mapper;

import java.util.Date;
import java.util.List;
@Mapper
public interface UserMapper {
    User getUserById(int id);
    List<User> getAllUsers();
    User insertUser(User user);
    User updateUser(User user);
    User deleteUser(int id);
    List<User> getUserByStatus(int status);
    int getUserCount();
    User getUserByUsername(String username);
    void updateLastLoginTime(int id);
}

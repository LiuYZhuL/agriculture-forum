package com.agriculture.dao;

import com.agriculture.model.po.User;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
@Mapper
public interface UserMapper {
    User getUserById(int id);
    List<User> getAllUsers();
    int insertUser(User user);
    int updateUser(User user);
    int deleteUser(int id);
    List<User> getUserByStatus(int status);
    int getUserCount();
    User getUserByUsername(String username);
}

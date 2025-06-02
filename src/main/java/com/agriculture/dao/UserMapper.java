package com.agriculture.dao;

import com.agriculture.model.po.User;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.Date;
import java.util.List;
@Mapper
public interface UserMapper {
    User getUserById(int id);
    List<User> getAllUsers();
    int insertUser(User user);
    void updateUser(User user);
    void deleteUser(int id);
    List<User> getUserByStatus(int status);
    int getUserCount();
    User getUserByUsername(String username);
    void updateLastLoginTime(int id);
    List<User> selectUserByCondition(User user);
    void addScore(@Param("id")int id, @Param("score") float score);
}

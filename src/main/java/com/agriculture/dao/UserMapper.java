package com.agriculture.dao;

import com.agriculture.model.dto.User;
import java.util.List;

public interface UserMapper {
    User getUserById(int id);
    List<User> getAllUsers();
    int addUser(User user);
    int updateUser(User user);
    int deleteUser(int id);
    List<User> getUserByStatus(int status);
    int getUserCount();
}

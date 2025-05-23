package com.agriculture.service.impl;

import com.agriculture.dao.UserMapper;
import com.agriculture.model.dto.User;
import com.agriculture.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserServiceImpl implements UserService {
    @Autowired
    private UserMapper userMapper;
    @Override
    public void login(User user) {

    }

}

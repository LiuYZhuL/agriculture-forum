package com.agriculture.service.impl;

import com.agriculture.dao.UserMapper;
import com.agriculture.model.dto.LoginUser;
import com.agriculture.model.dto.RegisterUser;
import com.agriculture.model.dto.UpdateUser;
import com.agriculture.model.po.User;
import com.agriculture.service.UserService;
import com.agriculture.util.PasswordUtil;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class UserServiceImpl implements UserService {
    @Autowired
    private UserMapper userMapper;

    /*
     * 登录
     * @param loginUser 登录用户名和密码
     * @return User 用户信息
     */
    @Override
    @Transactional
    public User login(LoginUser loginUser) {
        if(userMapper.getUserByUsername(loginUser.getUsername())==null){
            throw new RuntimeException("用户名不存在");
        }
        User user = userMapper.getUserByUsername(loginUser.getUsername());
        if(user.getStatus().equals(User.STATUS_LOCKED)){
            throw new RuntimeException("用户被锁定");
        }
        if(!PasswordUtil.matches(loginUser.getPassword(),user.getPassword())){
            throw new RuntimeException("密码错误");
        }
        userMapper.updateLastLoginTime(user.getId());
        return user;

    }
    /*
     * 注册
     * @param registerUser 注册用户信息
     * @return User 用户信息
     */
    @Override
    @Transactional
    public User register(RegisterUser registerUser) {
        if(userMapper.getUserByUsername(registerUser.getUsername())!=null){
            throw new RuntimeException("用户名已存在");
        }
        User user = new User();
        user.setUsername(registerUser.getUsername());
        user.setPassword(PasswordUtil.encode(registerUser.getPassword()));
        user.setEmail(registerUser.getEmail());
        userMapper.insertUser(user);
        return user;
    }

    /*
     * 登出
     * @param user 登出的用户
     */
    @Override
    @Transactional
    public void logout(User user) {
        if (userMapper.getUserById(user.getId()) == null){
            throw new RuntimeException("用户不存在");
        }
        if (userMapper.getUserById(user.getId()).getStatus().equals(User.STATUS_LOCKED)){
            throw new RuntimeException("用户被锁定");
        }
    }

}

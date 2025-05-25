package com.agriculture.service.impl;

import com.agriculture.dao.UserMapper;
import com.agriculture.model.dto.LoginUser;
import com.agriculture.model.dto.RegisterUser;
import com.agriculture.model.dto.UpdateUser;
import com.agriculture.model.po.Role;
import com.agriculture.model.po.User;
import com.agriculture.service.UserService;
import com.agriculture.util.PasswordUtil;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

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
        if(loginUser.getUsername()==null || loginUser.getUsername().isEmpty()){
            throw new RuntimeException("用户名不能为空");
        }
        if(loginUser.getPassword()==null || loginUser.getPassword().isEmpty()){
            throw new RuntimeException("密码不能为空");
        }
        User user = userMapper.getUserByUsername(loginUser.getUsername());
        if(user.getStatus() != null && user.getStatus().equals(User.STATUS_LOCKED)){
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
        if(registerUser.getUsername()==null || registerUser.getUsername().isEmpty()){
            throw new RuntimeException("用户名不能为空");
        }
        if(registerUser.getPassword()==null || registerUser.getPassword().isEmpty()){
            throw new RuntimeException("密码不能为空");
        }
        if(registerUser.getEmail()==null || registerUser.getEmail().isEmpty()){
            throw new RuntimeException("邮箱不能为空");
        }
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
        if (user == null){
            throw new RuntimeException("用户不存在");
        }
        if (userMapper.getUserById(user.getId()) == null){
            throw new RuntimeException("用户不存在");
        }
        if (userMapper.getUserById(user.getId()).getStatus().equals(User.STATUS_LOCKED)){
            throw new RuntimeException("用户被锁定");
        }
    }
//获取用户信息
    @Override
    @Transactional
    public User getUserById(Integer userId) {
        if (userId == null){
            throw new RuntimeException("用户ID不能为空");
        }
        return userMapper.getUserById(userId);
    }
//获取用户信息
    @Override
    @Transactional
    public User getUserByUsername(String username) {
        if (username == null || username.isEmpty()){
            throw new RuntimeException("用户名不能为空");
        }
        return userMapper.getUserByUsername(username);
    }

//修改用户信息
    @Override
    @Transactional
    public void updateUserInfo(UpdateUser updateUser) {
        if (updateUser == null){
            throw new RuntimeException("修改信息不能为空");
        }
        if (userMapper.getUserById(updateUser.getId()) == null){
            throw new RuntimeException("用户不存在");
        }
        User user = userMapper.getUserById(updateUser.getId());
        if (userMapper.getUserByUsername(updateUser.getUsername()) != null &&!user.getUsername().equals(updateUser.getUsername())){
            throw new RuntimeException("用户名已存在");
        }
        if (!user.getPassword().equals(PasswordUtil.encode(updateUser.getPassword()))){
            throw new RuntimeException("旧密码错误");
        }
        User newUser = new User();
        newUser.setId(updateUser.getId());
        newUser.setUsername(updateUser.getUsername());
        newUser.setPassword(PasswordUtil.encode(updateUser.getNewPassword()));
        newUser.setEmail(updateUser.getEmail());
        userMapper.updateUser(user);
    }
//修改密码
    @Override
    @Transactional
    public void changePassword(Integer userId, String oldPassword, String newPassword) {
        if (userId == null){
            throw new RuntimeException("用户ID不能为空");
        }
        if (userMapper.getUserById(userId) == null){
            throw new RuntimeException("用户不存在");
        }
        User user = userMapper.getUserById(userId);
        if (!user.getPassword().equals(PasswordUtil.encode(oldPassword))){
            throw new RuntimeException("旧密码错误");
        }
        User newUser = new User();
        newUser.setId(userId);
        newUser.setPassword(PasswordUtil.encode(newPassword));
        userMapper.updateUser(user);

    }
//重设密码
    @Override
    @Transactional
    public String resetPassword(String username, String email) {
        if (username == null || username.isEmpty()){
            throw new RuntimeException("用户名不能为空");
        }
        User user = userMapper.getUserByUsername(username);
        if (email == null || email.isEmpty()){
            throw new RuntimeException("邮箱不能为空");
        }
        if (!user.getEmail().equals(email)){
            throw new RuntimeException("邮箱错误");
        }
        String newPassword = "a1234567";
        User newUser = new User();
        newUser.setId(user.getId());
        newUser.setPassword(PasswordUtil.encode(newPassword));
        userMapper.updateUser(newUser);
        return newPassword;

    }
//修改用户状态

    @Override
    @Transactional
    public void updateUserStatus(Integer userId, Integer status) {
        if (userId == null){
            throw new RuntimeException("用户ID不能为空");
        }
        if (userMapper.getUserById(userId) == null){
            throw new RuntimeException("用户不存在");
        }
        User newUser = new User();
        newUser.setId(userId);
        if (status.equals(User.STATUS_LOCKED)){
            newUser.setStatus(User.STATUS_LOCKED);
        }
        if (status.equals(User.STATUS_NORMAL)){
            newUser.setStatus(User.STATUS_NORMAL);
        }
        userMapper.updateUser(newUser);

    }
//修改用户角色
    @Override
    @Transactional
    public void updateUserRole(Integer userId, Integer roleId) {
        if (userId == null){
            throw new RuntimeException("用户ID不能为空");
        }
        if (userMapper.getUserById(userId) == null){
            throw new RuntimeException("用户不存在");
        }
        User newUser = new User();
        newUser.setId(userId);
        if (roleId.equals(Role.ROLE_ADMIN)){
            newUser.setRoleId(Role.ROLE_ADMIN);
        }
        if (roleId.equals(Role.ROLE_USER)){
            newUser.setRoleId(Role.ROLE_USER);
        }
        userMapper.updateUser(newUser);

    }
//获取用户列表
    @Override
    @Transactional
    public PageInfo<User> listUsers(int pageNum, int pageSize, User user) {
        // 构建查询条件
        // 单次分页查询
        PageHelper.startPage(pageNum, pageSize);
        List<User> users = userMapper.selectUserByCondition(user);
        return new PageInfo<>(users);
    }

}

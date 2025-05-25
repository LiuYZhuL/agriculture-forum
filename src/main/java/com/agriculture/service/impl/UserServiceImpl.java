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

    /**
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
    /**
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

    /**
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

    /**
     * 获取用户信息
     * @param userId
     * @return User 用户信息
     */
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

    /**
     * 修改用户信息
     * @param updateUser 修改用户信息
     *                     必须包含id,username,email
     */
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

        User newUser = new User();
        newUser.setId(updateUser.getId());
        newUser.setUsername(updateUser.getUsername());
        newUser.setEmail(updateUser.getEmail());
        userMapper.updateUser(user);
    }
    /**
     * 修改密码
     * @param updateUser 修改密码的用户信息
     *                     必须包含id,password,newPassword
     */
    @Override
    @Transactional
    public void changePassword(UpdateUser updateUser) {
        if (updateUser == null){
            throw new RuntimeException("用户ID不能为空");
        }
        if (userMapper.getUserById(updateUser.getId()) == null){
            throw new RuntimeException("用户不存在");
        }
        User user = userMapper.getUserById(updateUser.getId());
        if (!user.getPassword().equals(PasswordUtil.encode(updateUser.getPassword()))){
            throw new RuntimeException("旧密码错误");
        }
        User newUser = new User();
        newUser.setId(updateUser.getId());
        newUser.setPassword(PasswordUtil.encode(updateUser.getNewPassword()));
        userMapper.updateUser(user);

    }

    /**
     * 重置密码
     * @param username
     * @param email
     * @return String 新密码
     */
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

    /**
     * 修改用户状态
     * @param userId
     * @param status
     * User.STATUS_LOCKED:锁定
     * User.STATUS_NORMAL:正常
     */
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

    /**
     * 修改用户角色
     * @param userId
     * @param roleId
     * Role.ROLE_ADMIN:管理员
     * Role.ROLE_USER:普通用户
     */
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

    /**
     * 获取用户列表
     * @param pageNum(web端分页参数)
     * @param pageSize(通常为 10)
     * @param user
     * 筛选条件 可为空 为空则查询全部用户
     * @return
     */
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

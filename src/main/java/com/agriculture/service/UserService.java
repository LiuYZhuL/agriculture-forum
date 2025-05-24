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

}

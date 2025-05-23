package com.agriculture.dao;

import com.agriculture.model.dto.Role;

import java.util.List;

public interface RoleMapper {
    Role selectRoleById(int id);
    List<Role> selectAllRole();
    int addRole(Role role);
    int updateRole(Role role);
    int deleteRole(int id);
    int getRoleCount();

}

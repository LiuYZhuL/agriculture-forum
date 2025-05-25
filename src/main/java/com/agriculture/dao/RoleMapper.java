package com.agriculture.dao;

import com.agriculture.model.po.Role;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
@Mapper
public interface RoleMapper {
    Role selectRoleById(int id);
    List<Role> selectAllRole();
    int insertRole(Role role);
    void updateRole(Role role);
    void deleteRole(int id);
    int getRoleCount();

}

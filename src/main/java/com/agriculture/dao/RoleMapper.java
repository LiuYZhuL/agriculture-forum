package com.agriculture.dao;

import com.agriculture.model.po.Role;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
@Mapper
public interface RoleMapper {
    Role selectRoleById(int id);
    List<Role> selectAllRole();
    int insertRole(Role role);
    int updateRole(Role role);
    int deleteRole(int id);
    int getRoleCount();

}

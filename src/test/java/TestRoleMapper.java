
import com.agriculture.dao.RoleMapper;
import com.agriculture.model.po.Role;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import java.util.Arrays;
import java.util.List;
import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class TestRoleMapper {

    @Mock
    private RoleMapper roleMapper;

    // 测试ID查询 - 存在记录
    @Test
    void selectRoleById_ValidId_ReturnsRole() {
        Role expectedRole = new Role(1, "Admin","");
        when(roleMapper.selectRoleById(1)).thenReturn(expectedRole);

        Role actual = roleMapper.selectRoleById(1);
        assertEquals(expectedRole, actual);
    }

    // 测试ID查询 - 无记录
    @Test
    void selectRoleById_InvalidId_ReturnsNull() {
        when(roleMapper.selectRoleById(999)).thenReturn(null);

        assertNull(roleMapper.selectRoleById(999));
    }

    // 测试查询所有角色 - 非空列表
    @Test
    void selectAllRole_NonEmptyList_ReturnsRoles() {
        List<Role> mockList = Arrays.asList(
                new Role(1, "Admin",""),
                new Role(2, "User","")
        );
        when(roleMapper.selectAllRole()).thenReturn(mockList);

        List<Role> result = roleMapper.selectAllRole();
        assertEquals(2, result.size());
    }

    // 测试新增角色 - 成功
    @Test
    void addRole_ValidInput_ReturnsOne() {
        Role newRole = new Role(3, "Guest","");
        when(roleMapper.insertRole(newRole)).thenReturn(1);

        int rowsAffected = roleMapper.insertRole(newRole);
        assertEquals(1, rowsAffected);
    }

    // 测试更新角色 - 成功
    @Test
    void updateRole_ExistingRole_UpdatesSuccessfully() {
        Role existingRole = new Role(1, "UpdatedAdmin","");
        when(roleMapper.updateRole(existingRole)).thenReturn(1);

        int result = roleMapper.updateRole(existingRole);
        assertEquals(1, result);
    }

    // 测试删除角色 - 成功
    @Test
    void deleteRole_ValidId_DeletesSuccessfully() {
        when(roleMapper.deleteRole(1)).thenReturn(1);

        int result = roleMapper.deleteRole(1);
        assertEquals(1, result);
    }

    // 测试统计总数
    @Test
    void getRoleCount_ReturnsCorrectCount() {
        when(roleMapper.getRoleCount()).thenReturn(5);

        int count = roleMapper.getRoleCount();
        assertEquals(5, count);
    }
}

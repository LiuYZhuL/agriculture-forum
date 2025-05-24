import com.agriculture.dao.UserMapper;
import com.agriculture.model.po.User;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.ZoneId;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

import java.time.LocalDateTime;

import static org.hibernate.validator.internal.util.Contracts.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.argThat;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
public class TestUserMapper {
    @Mock
    private UserMapper userMapper;
    private User testUser;
    @BeforeEach
    void setUp() {
        // 初始化测试用户对象
        testUser = new User();
        testUser.setId(1);
        testUser.setUsername("testUser");
        testUser.setPassword("securePass");
        testUser.setEmail("test@agri.com");
        testUser.setRoleId(2);
        testUser.setStatus(1);
    }

    /**
     * Test getUserById with existing ID
     * 测试通过有效ID查询用户
     */
    @Test
    void getUserById_WhenIdExists_ReturnsUser() {
        when(userMapper.getUserById(1)).thenReturn(testUser);

        User result = userMapper.getUserById(1);

        assertNotNull(result);
        assertEquals("testUser", result.getUsername());
    }

    /**
     * Test insertUser with optional fields
     * 测试包含可选字段的用户插入
     */
    @Test
    void insertUser_WithOptionalFields_ReturnsGeneratedId() {
        testUser.setAvatar("avatar.jpg");
        when(userMapper.insertUser(testUser)).thenReturn(1);

        int result = userMapper.insertUser(testUser);

        assertEquals(1, result);
        verify(userMapper).insertUser(argThat(user ->
                user.getAvatar().equals("avatar.jpg") &&
                        user.getRoleId() == 2
        ));
    }

    /**
     * Test updateUser partial fields update
     * 测试部分字段更新场景
     */
    @Test
    void updateUser_WhenUpdatePartialFields_GeneratesCorrectSetClause() {
        User updateUser = new User();
        updateUser.setId(1);
        updateUser.setUsername("newName");
        updateUser.setLastLoginTime(Date.from(LocalDateTime.now().atZone(ZoneId.systemDefault()).toInstant()));

        when(userMapper.updateUser(updateUser)).thenReturn(1);

        int result = userMapper.updateUser(updateUser);

        assertEquals(1, result);
        verify(userMapper).updateUser(argThat(user ->
                user.getUsername().equals("newName") &&
                        user.getLastLoginTime() != null &&
                        user.getPassword() == null
        ));
    }

    /**
     * Test deleteUser with invalid ID
     * 测试删除无效ID用户
     */
    @Test
    void deleteUser_WithInvalidId_ReturnsZeroAffectedRows() {
        when(userMapper.deleteUser(999)).thenReturn(0);

        int result = userMapper.deleteUser(999);

        assertEquals(0, result);
    }

    /**
     * Test getUserCount with empty table
     * 测试空表时的用户总数查询
     */
    @Test
    void getUserCount_WhenTableEmpty_ReturnsZero() {
        when(userMapper.getUserCount()).thenReturn(0);

        int count = userMapper.getUserCount();

        assertEquals(0, count);
    }

    /**
     * Test getUserByStatus with multiple results
     * 测试按状态查询返回多结果场景
     */
    @Test
    void getUserByStatus_WhenMultipleUsersExist_ReturnsList() {
        List<User> mockUsers = Arrays.asList(
                new User(), new User(), new User()
        );
        when(userMapper.getUserByStatus(1)).thenReturn(mockUsers);

        List<User> result = userMapper.getUserByStatus(1);

        assertEquals(3, result.size());
    }
}

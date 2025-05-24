import com.agriculture.dao.UserMapper;
import com.agriculture.model.dto.LoginUser;
import com.agriculture.model.dto.RegisterUser;
import com.agriculture.model.po.User;
import com.agriculture.service.impl.UserServiceImpl;
import com.agriculture.util.PasswordUtil;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.mockito.junit.jupiter.MockitoExtension;


import static org.hibernate.validator.internal.util.Contracts.assertNotNull;
import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class TestUserService {
    @Mock
    private UserMapper userMapper;

    @InjectMocks
    private UserServiceImpl userService;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
    }

    // region login() Tests
    @Test
    void login_WhenUsernameNotExist_ThrowException() {
        // Arrange
        LoginUser input = new LoginUser("unknown", "anypass");
        when(userMapper.getUserByUsername(input.getUsername())).thenReturn(null);

        // Act & Assert
        Exception exception = assertThrows(RuntimeException.class, () ->
                userService.login(input)
        );
        assertEquals("用户名不存在", exception.getMessage());
        verify(userMapper, times(1)).getUserByUsername(input.getUsername());
    }

    @Test
    void login_WhenPasswordMismatch_ThrowException() {
        // Arrange
        String rawPassword = "wrongpass";
        User mockUser = new User();
        mockUser.setPassword(PasswordUtil.encode("correctpass")); // 正确密码加密
        when(userMapper.getUserByUsername("user1")).thenReturn(mockUser);

        LoginUser input = new LoginUser("user1", rawPassword);

        // Act & Assert
        Exception exception = assertThrows(RuntimeException.class, () ->
                userService.login(input)
        );
        assertEquals("密码错误", exception.getMessage());
    }

    @Test
    void login_WhenValidCredentials_ReturnUser() {
        // Arrange
        String rawPassword = "pass123";
        User mockUser = new User();
        mockUser.setUsername("user1");
        mockUser.setPassword(PasswordUtil.encode(rawPassword)); // 加密后的密码
        when(userMapper.getUserByUsername("user1")).thenReturn(mockUser);

        LoginUser input = new LoginUser("user1", rawPassword);

        // Act
        User result = userService.login(input);

        // Assert
        assertNotNull(result);
        assertEquals("user1", result.getUsername());
        verify(userMapper, times(2)).getUserByUsername("user1"); // 两次查询（实际代码中有冗余）
    }
    // endregion

    // region register() Tests
    @Test
    void register_WhenUsernameExists_ThrowException() {
        // Arrange
        RegisterUser input = new RegisterUser("existingUser", "pass", "test@mail.com");
        when(userMapper.getUserByUsername(input.getUsername()))
                .thenReturn(new User()); // 模拟已存在用户

        // Act & Assert
        Exception exception = assertThrows(RuntimeException.class, () ->
                userService.register(input)
        );
        assertEquals("用户名已存在", exception.getMessage());
    }

    @Test
    void register_WhenNewUser_SaveWithEncryptedPassword() {
        // Arrange
        RegisterUser input = new RegisterUser("newUser", "rawPassword", "new@mail.com");
        when(userMapper.getUserByUsername(input.getUsername())).thenReturn(null);

        // Act
        User result = userService.register(input);

        // Assert
        assertNotNull(result);
        // 验证密码是否加密（非明文）
        assertTrue(PasswordUtil.matches("rawPassword", result.getPassword()));
        verify(userMapper, times(1)).insertUser(any(User.class));
    }
    // endregion
}

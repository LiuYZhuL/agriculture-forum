import com.agriculture.controller.UserController;
import com.agriculture.model.dto.LoginUser;
import com.agriculture.model.dto.RegisterUser;
import com.agriculture.model.po.User;
import com.agriculture.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.BindingResult;
import org.springframework.web.servlet.ModelAndView;

import static org.hibernate.validator.internal.util.Contracts.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class TestUserController {

    @InjectMocks
    private UserController userController;

    @Mock
    private UserService userService;

    @Test
    void testLoginPost_WithValidationErrors() {
        // Setup
        LoginUser loginUser = new LoginUser();
        BindingResult bindingResult = mock(BindingResult.class);
        when(bindingResult.hasErrors()).thenReturn(true);

        // Execute
        ModelAndView result = userController.login(loginUser, bindingResult, mock(HttpSession.class));

        // Verify
        assertEquals("redirect:/api/user/login", result.getViewName());
        assertNotNull(result.getModel().get("error"));
    }

    @Test
    void testLoginPost_ServiceException() throws Exception {
        // Setup
        LoginUser loginUser = new LoginUser("test", "password");
        BindingResult bindingResult = mock(BindingResult.class);
        when(bindingResult.hasErrors()).thenReturn(false);
        when(userService.login(any())).thenThrow(new RuntimeException("Invalid credentials"));

        // Execute
        ModelAndView result = userController.login(loginUser, bindingResult, mock(HttpSession.class));

        // Verify
        assertEquals("redirect:/api/user/login", result.getViewName());
        assertEquals("Invalid credentials", result.getModel().get("error"));
    }

    @Test
    void testLoginPost_Success() throws Exception {
        // Setup
        LoginUser loginUser = new LoginUser("valid", "password");
        BindingResult bindingResult = mock(BindingResult.class);
        HttpSession session = mock(HttpSession.class);
        when(bindingResult.hasErrors()).thenReturn(false);
        when(userService.login(any())).thenReturn(new User());

        // Execute
        ModelAndView result = userController.login(loginUser, bindingResult, session);

        // Verify
        verify(session).setAttribute(eq("user"), any());
        assertEquals("redirect:/api/dashboard", result.getViewName());
    }

    @Test
    void testRegisterPost_ValidationFailed() {
        // Setup
        RegisterUser regUser = new RegisterUser();
        BindingResult bindingResult = mock(BindingResult.class);
        when(bindingResult.hasErrors()).thenReturn(true);

        // Execute
        ModelAndView result = userController.register(regUser, bindingResult, mock(HttpSession.class));

        // Verify
        assertEquals("redirect:/api/user/register", result.getViewName());
        assertNotNull(result.getModel().get("error"));
    }

    @Test
    void testRegisterPost_ServiceException() {
        // Setup
        RegisterUser regUser = new RegisterUser("newuser", "pass", "test@agri.com");
        BindingResult bindingResult = mock(BindingResult.class);
        when(bindingResult.hasErrors()).thenReturn(false);
        doThrow(new RuntimeException("User exists")).when(userService).register(any());

        // Execute
        ModelAndView result = userController.register(regUser, bindingResult, mock(HttpSession.class));

        // Verify
        assertEquals("redirect:/api/user/register", result.getViewName());
        assertEquals("User exists", result.getModel().get("error"));
    }

    @Test
    void testLogout_Success() {
        // Setup
        HttpSession session = mock(HttpSession.class);
        when(session.getAttribute("user")).thenReturn(new User());

        // Execute
        ModelAndView result = userController.logout(session);

        // Verify
        verify(session).invalidate();
        assertEquals("redirect:/api/dashboard", result.getViewName());
    }
}
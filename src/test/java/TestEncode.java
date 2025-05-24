import com.agriculture.util.PasswordUtil;
import org.junit.jupiter.api.Test;

public class TestEncode {
    @Test
    public void testEncode() {
        String password = PasswordUtil.encode("123456");
        System.out.println(password);
        System.out.println(PasswordUtil.matches("123456", password));
        System.out.println(PasswordUtil.generateRandomPassword(8));
    }
}

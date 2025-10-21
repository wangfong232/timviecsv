package utils;

import java.util.List;

/**
 *
 * @author qp
 */
public class RegisterValidator {

    public static String validateRegistration(String email, String password, String confirmPassword, String fullName, String phone) {
        Validator validator = new Validator();

        //password validation
        validator.required(password, "Password")
                .minLength(password, 6, "Password")
                .maxLength(password, 100, "Password")
                .passwordStrength(password, "Password");

        //confirm password validation
        validator.required(confirmPassword, "xác nhận mật khẩu")
                .passwordMatch(password, confirmPassword, "Xác nhận mật khẩu");

        //full name validation
        validator.required(fullName, "Full name")
                .minLength(fullName, 2, "Họ và tên")
                .maxLength(fullName, 150, "Họ và tên")
                .name(fullName, "Họ và tên");

        //phone validation
        validator.required(phone, "Số điện thoại").phone(phone, "Số điện thoại");

        return validator.isValid() ? "" : validator.getFirstError();
    }

    //check duplicate
    public static String validateEmail(String email) {
        Validator validator = new Validator();
        //email validation
        validator.required(email, "Email")
                .email(email, "Email");

        return validator.isValid() ? "" : validator.getFirstError();
    }
}

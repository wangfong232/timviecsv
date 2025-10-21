package utils;

/**
 *
 * @author qp
 */
public class LoginValidator {

    public static String validateLogin(String email, String password) {
        Validator validator = new Validator();

        validator.required(email, "Email");
        validator.required(password, "Password").minLength(password, 6, "Password").maxLength(email, 100, "Password");

        return validator.isValid() ? "" : validator.getFirstError();
    }
}

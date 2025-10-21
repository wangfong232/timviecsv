package utils;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

public class Validator {

    private List<String> errors;

    public Validator() {
        this.errors = new ArrayList<>();
    }

    //required field
    public Validator required(String value, String fieldName) {
        if (value == null || value.trim().isEmpty()) {
            errors.add(fieldName + " không được để trống");
        }
        return this;
    }

    //minium length
    public Validator minLength(String value, int minLength, String fieldName) {
        if (value != null && value.trim().length() < minLength) {
            errors.add(fieldName + " phải có ít nhất " + minLength + " ký tự");
        }
        return this;
    }

    //maximum length
    public Validator maxLength(String value, int maxLength, String fieldName) {
        if (value != null && value.trim().length() > maxLength) {
            errors.add(fieldName + " không được vượt quá " + maxLength + " ký tự");
        }
        return this;
    }

    //validate email format
    public Validator email(String email, String fieldName) {
        if (email != null && !email.trim().isEmpty()) {
            String emailPattern = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$";
            if (!Pattern.matches(emailPattern, email)) {
                errors.add(fieldName + " không đúng định dạng");
            }
        }
        return this;
    }

    //validate phone number
    public Validator phone(String phone, String fieldName) {
        if (phone != null && !phone.trim().isEmpty()) {
            String phonePattern = "^[0-9]{10,11}$";
            if (!Pattern.matches(phonePattern, phone)) {
                errors.add(fieldName + " phải có 10-11 chữ số");
            }
        }
        return this;
    }

    //validate password strength
    public Validator passwordStrength(String password, String fieldName) {
        if (password != null && !password.trim().isEmpty()) {
            if (!Pattern.matches(".*[A-Z].*", password)) {            //. : khop moi ky tu(tru xuong dong)
                errors.add(fieldName + " phải có ít nhất một chữ in hoa");                                                              //* : lap lai 0 lan hoặc nhiều lần    ==> .* : có thể bắt đầu bằng bất cứ cái gì
            }
            if (!Pattern.matches(".*[0-9].*", password)) {
                errors.add(fieldName + " phải có ít nhất một chữ số");                                                              //* : lap lai 0 lan hoặc nhiều lần    ==> .* : có thể bắt đầu bằng bất cứ cái gì
            }
            if (!Pattern.matches(".*[!@#$%^&*()].*", password)) {
                errors.add(fieldName + " phải có ít nhất một ký tự đặc biệt");                                                              //* : lap lai 0 lan hoặc nhiều lần    ==> .* : có thể bắt đầu bằng bất cứ cái gì
            }
        }
        return this;
    }

    //validate name
    public Validator name(String name, String fieldName) {
        if (name != null && !name.trim().isEmpty()) {
            String namePattern = "^[\\p{L} ]+$";
            if (!Pattern.matches(namePattern, name)) {
                errors.add(fieldName + " chỉ được chữ cái và khoảng trắng");
            }
        }
        return this;
    }

    //validate password confirmation
    public Validator passwordMatch(String password, String confirmPassword, String fieldName) {
        if (password != null && confirmPassword != null) {
            if (!password.equals(confirmPassword)) {
                errors.add(fieldName + " không khớp");

            }
        }
        return this;
    }

    //check if validation passed
    public boolean isValid() {
        return errors.isEmpty();
    }

    //get first erorr messages
    public String getFirstError() {
        return errors.isEmpty() ? "" : errors.get(0);
    }

    //get all error message
    public List<String> getAllErrors() {
        return new ArrayList<>(errors);
    }

    //get errors as a single string
    public String getErrorString() {
        return String.join("; ", errors);
    }

    public void clearErrors() {
        errors.clear();
    }
}

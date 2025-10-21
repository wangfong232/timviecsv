package utils;

import java.util.List;

/**
 *
 * @author qp
 */
public class ValidationResult {

    private boolean valid;
    private String errorMessage;
    private List<String> allErrors;

    //pass
    public ValidationResult(boolean valid) {
        this.valid = valid;
        this.errorMessage = "";
        this.allErrors = null;
    }

    //1 error
    public ValidationResult(boolean valid, String errorMessage) {
        this.valid = valid;
        this.errorMessage = errorMessage;
    }

    //errors
    public ValidationResult(boolean valid, String errorMessage, List<String> allErrors) {
        this.valid = valid;
        this.errorMessage = errorMessage;
        this.allErrors = allErrors;
    }

    public static ValidationResult success() {
        return new ValidationResult(true);
    }

    public static ValidationResult failure(String errorMessage) {
        return new ValidationResult(false, errorMessage);
    }

    public static ValidationResult failure(String erString, List<String> allErrors) {
        return new ValidationResult(false, erString, allErrors);
    }

    //tạo ValidationResult từ validator
    public static ValidationResult fromValidator(Validator validator) {
        if (validator.isValid()) {
            return ValidationResult.success();
        } else {
            return new ValidationResult(false, validator.getFirstError(), validator.getAllErrors());
        }
    }

    // Getters
    public boolean isValid() {
        return valid;
    }

    public String getErrorMessage() {
        return errorMessage;
    }

    public List<String> getAllErrors() {
        return allErrors;
    }

    public boolean hasErrors() {
        return !valid;
    }

    public String getErrorsAsString() {
        if (allErrors != null && !allErrors.isEmpty()) {
            return String.join("; ", allErrors);
        }
        return errorMessage;
    }
}

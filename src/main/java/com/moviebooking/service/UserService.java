package com.moviebooking.service;

import com.moviebooking.dao.UserDao;
import com.moviebooking.model.User;
import com.moviebooking.util.Validation;

public class UserService {
    private final UserDao userDao = new UserDao();

    public ServiceResult registerUser(String fullName, String email, String phone,
                                      String password, String confirmPassword) {
        if (Validation.isEmpty(fullName) || Validation.isEmpty(email) ||
            Validation.isEmpty(phone) || Validation.isEmpty(password)) {
            return ServiceResult.error("All fields are required");
        }

        if (!Validation.isValidName(fullName)) {
            return ServiceResult.error("Full name should contain only letters");
        }

        if (!Validation.isValidEmail(email)) {
            return ServiceResult.error("Invalid email format");
        }

        if (!Validation.isValidPhone(phone)) {
            return ServiceResult.error("Phone number must be 10 digits");
        }

        if (!Validation.isValidPassword(password)) {
            return ServiceResult.error("Password must be at least 6 characters");
        }

        if (!password.equals(confirmPassword)) {
            return ServiceResult.error("Passwords do not match");
        }

        if (userDao.emailExists(email)) {
            return ServiceResult.error("Email already registered");
        }

        if (userDao.phoneExists(phone)) {
            return ServiceResult.error("Phone number already registered");
        }

        User user = new User(fullName, email, phone, password, "user");
        boolean isRegistered = userDao.registerUser(user);
        if (isRegistered) {
            return ServiceResult.success("Registration successful");
        }
        return ServiceResult.error("Registration failed. Please try again");
    }

    public LoginResult login(String email, String password) {
        if (Validation.isEmpty(email) || Validation.isEmpty(password)) {
            return LoginResult.error("Email and password are required");
        }

        if (!Validation.isValidEmail(email)) {
            return LoginResult.error("Invalid email format");
        }

        User authenticated = userDao.validateUser(email, password);
        if (authenticated != null) {
            return LoginResult.success(authenticated);
        }

        return LoginResult.error("Invalid email or password");
    }

    public ServiceResult resetPassword(String email, String newPassword, String confirmPassword) {
        if (Validation.isEmpty(email) || Validation.isEmpty(newPassword)) {
            return ServiceResult.error("All fields are required");
        }

        if (!Validation.isValidEmail(email)) {
            return ServiceResult.error("Invalid email format");
        }

        if (!Validation.isValidPassword(newPassword)) {
            return ServiceResult.error("Password must be at least 6 characters");
        }

        if (!newPassword.equals(confirmPassword)) {
            return ServiceResult.error("Passwords do not match");
        }

        if (!userDao.emailExists(email)) {
            return ServiceResult.error("Email not found");
        }

        boolean isUpdated = userDao.updatePassword(email, newPassword);
        if (isUpdated) {
            return ServiceResult.success("Password reset successful");
        }
        return ServiceResult.error("Password reset failed");
    }

    public static class ServiceResult {
        private final boolean success;
        private final String message;

        private ServiceResult(boolean success, String message) {
            this.success = success;
            this.message = message;
        }

        public boolean isSuccess() { return success; }
        public String getMessage() { return message; }

        public static ServiceResult success(String message) {
            return new ServiceResult(true, message);
        }

        public static ServiceResult error(String message) {
            return new ServiceResult(false, message);
        }
    }

    public static class LoginResult extends ServiceResult {
        private final User user;

        private LoginResult(boolean success, String message, User user) {
            super(success, message);
            this.user = user;
        }

        public User getUser() { return user; }

        public static LoginResult success(User user) {
            return new LoginResult(true, "", user);
        }

        public static LoginResult error(String message) {
            return new LoginResult(false, message, null);
        }
    }
}

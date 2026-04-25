package com.moviebooking.service;

import com.moviebooking.dao.UserDao;
import com.moviebooking.model.User;
import com.moviebooking.util.Validation;
import com.moviebooking.util.PasswordUtil;

/**
 * Service layer for user-related operations.
 * Handles registration, login, and password reset with validation.
 * Uses PasswordUtil for secure password hashing and verification.
 */
public class UserService {
    private final UserDao userDao = new UserDao();

    /**
     * Register a new user with validation.
     * Validates all inputs, checks for duplicates, and hashes password.
     * @param fullName user's full name
     * @param email user's email address
     * @param phone user's phone number
     * @param password user's password
     * @param confirmPassword password confirmation
     * @return ServiceResult with success/error message
     */
    public ServiceResult registerUser(String fullName, String email, String phone,
                                      String password, String confirmPassword) {
        // Validate all fields are provided
        if (Validation.isEmpty(fullName) || Validation.isEmpty(email) ||
            Validation.isEmpty(phone) || Validation.isEmpty(password)) {
            return ServiceResult.error("All fields are required");
        }

        // Validate name format (letters only)
        if (!Validation.isValidName(fullName)) {
            return ServiceResult.error("Full name should contain only letters");
        }

        // Validate email format
        if (!Validation.isValidEmail(email)) {
            return ServiceResult.error("Invalid email format");
        }

        // Validate phone format (10 digits)
        if (!Validation.isValidPhone(phone)) {
            return ServiceResult.error("Phone number must be 10 digits");
        }

        // Validate password length (minimum 6 characters)
        if (!Validation.isValidPassword(password)) {
            return ServiceResult.error("Password must be at least 6 characters");
        }

        // Check if passwords match
        if (!password.equals(confirmPassword)) {
            return ServiceResult.error("Passwords do not match");
        }

        // Check if email already exists
        if (userDao.emailExists(email)) {
            return ServiceResult.error("Email already registered");
        }

        // Check if phone already exists
        if (userDao.phoneExists(phone)) {
            return ServiceResult.error("Phone number already registered");
        }

        // Hash password using PBKDF2-SHA256
        String hashedPassword = PasswordUtil.hashPassword(password);
        User user = new User(fullName, email, phone, hashedPassword, "user");
        
        // Save user to database
        boolean isRegistered = userDao.registerUser(user);
        if (isRegistered) {
            return ServiceResult.success("Registration successful");
        }
        return ServiceResult.error("Registration failed. Please try again");
    }

    /**
     * Authenticate user login with email and password.
     * Validates inputs and verifies password against stored hash.
     * @param email user's email address
     * @param password user's password
     * @return LoginResult with user object if successful, error message otherwise
     */
    public LoginResult login(String email, String password) {
        // Validate inputs
        if (Validation.isEmpty(email) || Validation.isEmpty(password)) {
            return LoginResult.error("Email and password are required");
        }

        // Validate email format
        if (!Validation.isValidEmail(email)) {
            return LoginResult.error("Invalid email format");
        }

        // Get user from database by email
        User user = userDao.getUserByEmail(email);
        
        // Verify password using bcrypt comparison
        if (user != null && PasswordUtil.verifyPassword(password, user.getPassword())) {
            return LoginResult.success(user);
        }

        return LoginResult.error("Invalid email or password");
    }

    /**
     * Reset user password (used after OTP verification).
     * Validates inputs and hashes new password.
     * @param email user's email address
     * @param newPassword new password to set
     * @param confirmPassword password confirmation
     * @return ServiceResult with success/error message
     */
    public ServiceResult resetPassword(String email, String newPassword, String confirmPassword) {
        // Validate inputs
        if (Validation.isEmpty(email) || Validation.isEmpty(newPassword)) {
            return ServiceResult.error("All fields are required");
        }

        // Validate email format
        if (!Validation.isValidEmail(email)) {
            return ServiceResult.error("Invalid email format");
        }

        // Validate password length
        if (!Validation.isValidPassword(newPassword)) {
            return ServiceResult.error("Password must be at least 6 characters");
        }

        // Check if passwords match
        if (!newPassword.equals(confirmPassword)) {
            return ServiceResult.error("Passwords do not match");
        }

        // Check if email exists
        if (!userDao.emailExists(email)) {
            return ServiceResult.error("Email not found");
        }

        // Hash new password and update database
        String hashedPassword = PasswordUtil.hashPassword(newPassword);
        boolean isUpdated = userDao.updatePassword(email, hashedPassword);
        if (isUpdated) {
            return ServiceResult.success("Password reset successful");
        }
        return ServiceResult.error("Password reset failed");
    }

    /**
     * Generic service result class for operations.
     * Contains success flag and message.
     */
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

    /**
     * Login result class extending ServiceResult.
     * Contains user object if login is successful.
     */
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

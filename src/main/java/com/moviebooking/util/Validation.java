package com.moviebooking.util;

import java.util.regex.Pattern;

/**
 * This class checks if user input is valid.
 * Has methods to check email, phone, name, and password.
 * Used in servlets before saving data to database.
 */
public class Validation {
    
    // Pattern to check valid email format (e.g. user@example.com)
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");
    // Pattern to check phone number is exactly 10 digits
    private static final Pattern PHONE_PATTERN = Pattern.compile("^[0-9]{10}$");
    // Pattern to check name has only letters and spaces (no numbers or symbols)
    private static final Pattern NAME_PATTERN = Pattern.compile("^[A-Za-z\\s]+$");

    /**
     * Check if email is in correct format.
     * @param email the email to check
     * @return true if email format is valid, false if not
     */
    public static boolean isValidEmail(String email) {
        return email != null && EMAIL_PATTERN.matcher(email).matches();
    }

    /**
     * Check if phone number is exactly 10 digits.
     * @param phone the phone number to check
     * @return true if phone is valid, false if not
     */
    public static boolean isValidPhone(String phone) {
        return phone != null && PHONE_PATTERN.matcher(phone).matches();
    }

    /**
     * Check if name has only letters and is at least 2 characters long.
     * @param name the name to check
     * @return true if name is valid, false if not
     */
    public static boolean isValidName(String name) {
        return name != null && NAME_PATTERN.matcher(name).matches() && name.trim().length() >= 2;
    }

    /**
     * Check if password is at least 6 characters long.
     * @param password the password to check
     * @return true if password is valid, false if not
     */
    public static boolean isValidPassword(String password) {
        return password != null && password.length() >= 6;
    }

    /**
     * Check if a string is null or blank (empty after trimming spaces).
     * @param str the string to check
     * @return true if string is empty or null, false if it has content
     */
    public static boolean isEmpty(String str) {
        return str == null || str.trim().isEmpty();
    }
}

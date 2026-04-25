package com.moviebooking.util;

import java.util.Random;

/**
 * Utility class for generating and validating One-Time Passwords (OTP).
 * Used for 2FA during password reset process.
 */
public class OtpUtil {
    private static final int OTP_LENGTH = 6;
    private static final long OTP_EXPIRY_MINUTES = 10;

    /**
     * Generate a random 6-digit OTP.
     * @return a 6-digit OTP as a string
     */
    public static String generateOtp() {
        Random random = new Random();
        StringBuilder otp = new StringBuilder();
        for (int i = 0; i < OTP_LENGTH; i++) {
            otp.append(random.nextInt(10));
        }
        return otp.toString();
    }

    /**
     * Check if an OTP has expired based on generation time.
     * OTP is valid for 10 minutes from generation.
     * @param generatedTime the time when OTP was generated in milliseconds
     * @return true if OTP has expired, false if still valid
     */
    public static boolean isOtpExpired(long generatedTime) {
        long currentTime = System.currentTimeMillis();
        long expiryTime = generatedTime + (OTP_EXPIRY_MINUTES * 60 * 1000);
        return currentTime > expiryTime;
    }

    /**
     * Get current system time in milliseconds.
     * Used to track OTP generation time.
     * @return current time in milliseconds
     */
    public static long getCurrentTimeMillis() {
        return System.currentTimeMillis();
    }
}

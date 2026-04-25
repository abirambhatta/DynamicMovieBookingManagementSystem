package com.moviebooking.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

/**
 * Utility class for secure password hashing and verification.
 * Uses PBKDF2 with SHA-256 algorithm for password encryption.
 * Each password gets a unique 16-byte salt and 10,000 iterations.
 * Provides protection against rainbow table and brute force attacks.
 */
public class PasswordUtil {
    private static final int SALT_LENGTH = 16;
    private static final int ITERATIONS = 10000;

    /**
     * Hash a plain text password using PBKDF2-SHA256.
     * Generates a random salt and combines it with the hash for storage.
     * @param password the plain text password to hash
     * @return Base64 encoded string containing salt + hash
     */
    public static String hashPassword(String password) {
        try {
            // Generate random salt
            SecureRandom random = new SecureRandom();
            byte[] salt = new byte[SALT_LENGTH];
            random.nextBytes(salt);

            // Hash password with salt using PBKDF2
            byte[] hash = pbkdf2(password.toCharArray(), salt, ITERATIONS, 32);
            
            // Combine salt and hash for storage
            byte[] combined = new byte[salt.length + hash.length];
            System.arraycopy(salt, 0, combined, 0, salt.length);
            System.arraycopy(hash, 0, combined, salt.length, hash.length);

            // Encode to Base64 for storage in database
            return Base64.getEncoder().encodeToString(combined);
        } catch (Exception e) {
            throw new RuntimeException("Error hashing password", e);
        }
    }

    /**
     * Verify a plain text password against a stored hash.
     * Extracts salt from stored hash and compares with new hash.
     * Uses constant-time comparison to prevent timing attacks.
     * @param password the plain text password to verify
     * @param hashedPassword the stored Base64 encoded hash+salt
     * @return true if password matches, false otherwise
     */
    public static boolean verifyPassword(String password, String hashedPassword) {
        try {
            // Decode stored hash from Base64
            byte[] combined = Base64.getDecoder().decode(hashedPassword);
            
            // Extract salt from stored hash
            byte[] salt = new byte[SALT_LENGTH];
            System.arraycopy(combined, 0, salt, 0, SALT_LENGTH);

            // Hash the provided password with extracted salt
            byte[] hash = pbkdf2(password.toCharArray(), salt, ITERATIONS, 32);
            
            // Extract stored hash for comparison
            byte[] storedHash = new byte[combined.length - SALT_LENGTH];
            System.arraycopy(combined, SALT_LENGTH, storedHash, 0, storedHash.length);

            // Compare hashes using constant-time comparison
            return constantTimeEquals(hash, storedHash);
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * PBKDF2 key derivation function using SHA-256.
     * Applies 10,000 iterations to strengthen the hash against brute force.
     * @param password the password to hash
     * @param salt the salt to use
     * @param iterations number of iterations (10,000 recommended)
     * @param keyLength desired output length in bytes
     * @return the derived key
     */
    private static byte[] pbkdf2(char[] password, byte[] salt, int iterations, int keyLength) 
            throws NoSuchAlgorithmException {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] result = new byte[keyLength];
        byte[] u = new byte[32];
        byte[] uXor = new byte[32];

        String passwordStr = new String(password);
        for (int i = 1; i <= keyLength / 32; i++) {
            md.reset();
            md.update(passwordStr.getBytes());
            md.update(salt);
            md.update(new byte[]{(byte) (i >> 24), (byte) (i >> 16), (byte) (i >> 8), (byte) i});
            u = md.digest();
            System.arraycopy(u, 0, uXor, 0, 32);

            // Apply iterations
            for (int j = 1; j < iterations; j++) {
                md.reset();
                md.update(u);
                u = md.digest();
                for (int k = 0; k < 32; k++) {
                    uXor[k] ^= u[k];
                }
            }

            System.arraycopy(uXor, 0, result, (i - 1) * 32, Math.min(32, keyLength - (i - 1) * 32));
        }

        return result;
    }

    /**
     * Constant-time byte array comparison.
     * Prevents timing attacks by always comparing all bytes.
     * @param a first byte array
     * @param b second byte array
     * @return true if arrays are equal, false otherwise
     */
    private static boolean constantTimeEquals(byte[] a, byte[] b) {
        if (a.length != b.length) {
            return false;
        }
        int result = 0;
        for (int i = 0; i < a.length; i++) {
            result |= a[i] ^ b[i];
        }
        return result == 0;
    }
}

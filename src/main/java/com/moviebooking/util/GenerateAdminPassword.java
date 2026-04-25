package com.moviebooking.util;

/**
 * One-time utility to generate admin password hash for database insertion.
 * Run this once to get the hash, then use it in your SQL INSERT statement.
 */
public class GenerateAdminPassword {
    public static void main(String[] args) {
        String password = "admin123";
        String hash = PasswordUtil.hashPassword(password);
        
        System.out.println("=".repeat(80));
        System.out.println("ADMIN PASSWORD HASH GENERATED");
        System.out.println("=".repeat(80));
        System.out.println("\nPassword: " + password);
        System.out.println("Hash: " + hash);
        System.out.println("\nUse this SQL to insert admin user:");
        System.out.println("-".repeat(80));
        System.out.println("INSERT INTO users (name, email, password, role)");
        System.out.println("VALUES ('Admin', 'admin@moviemint.com',");
        System.out.println("'" + hash + "',");
        System.out.println("'admin');");
        System.out.println("=".repeat(80));
    }
}

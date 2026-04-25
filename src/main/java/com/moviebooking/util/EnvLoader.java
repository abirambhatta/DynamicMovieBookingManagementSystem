package com.moviebooking.util;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

public class EnvLoader {
    private static Map<String, String> envVars = new HashMap<>();
    private static boolean loaded = false;

    public static String get(String key) {
        if (!loaded) {
            load();
        }
        String value = envVars.get(key);
        if (value == null) {
            value = System.getenv(key);
        }
        return value;
    }

    private static void load() {
        // Try multiple possible locations for .env file
        String[] possiblePaths = {
            System.getProperty("user.dir") + "/.env",
            System.getProperty("user.dir") + "\\.env",
            System.getProperty("catalina.base") + "/webapps/MovieBookingManagementSystem/.env"
        };
        
        boolean found = false;
        for (String envPath : possiblePaths) {
            try (BufferedReader reader = new BufferedReader(new FileReader(envPath))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    line = line.trim();
                    if (line.isEmpty() || line.startsWith("#")) {
                        continue;
                    }
                    int equalsIndex = line.indexOf('=');
                    if (equalsIndex > 0) {
                        String key = line.substring(0, equalsIndex).trim();
                        String value = line.substring(equalsIndex + 1).trim();
                        envVars.put(key, value);
                    }
                }
                System.out.println("✓ Loaded .env from: " + envPath);
                found = true;
                break;
            } catch (IOException e) {
                // Try next path
            }
        }
        
        if (!found) {
            System.err.println("\n" + "=".repeat(80));
            System.err.println("ERROR: .env file not found!");
            System.err.println("=".repeat(80));
            System.err.println("Please create a .env file in your project root with:");
            System.err.println("  1. Copy .env.example to .env");
            System.err.println("  2. Fill in your database, email, and TMDB API credentials");
            System.err.println("  3. Restart the server");
            System.err.println("\nSee README.md for detailed setup instructions.");
            System.err.println("=".repeat(80) + "\n");
        }
        
        loaded = true;
    }
}

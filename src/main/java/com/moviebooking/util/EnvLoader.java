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
        String projectRoot = System.getProperty("user.dir");
        String envPath = projectRoot + "/.env";
        
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
            loaded = true;
        } catch (IOException e) {
            System.err.println("Warning: .env file not found. Using system environment variables.");
            loaded = true;
        }
    }
}

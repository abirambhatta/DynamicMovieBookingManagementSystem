package com.moviebooking.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import com.moviebooking.dao.UserDao;
import com.moviebooking.model.User;
import com.moviebooking.util.PasswordUtil;

/**
 * Initializes database with default admin user on application startup.
 * Runs once when the application starts.
 */
@WebServlet(urlPatterns = "/init", loadOnStartup = 1)
public class DatabaseInitServlet extends HttpServlet {
    
    @Override
    public void init() throws ServletException {
        super.init();
        initializeAdminUser();
    }
    
    private void initializeAdminUser() {
        try {
            UserDao userDao = new UserDao();
            
            // Check if admin from SQL file exists
            User sqlAdmin = userDao.getUserByEmail("admin@moviebooking.com");
            if (sqlAdmin != null && !sqlAdmin.getPassword().startsWith("$2a$")) {
                // The SQL file inserted plaintext 'admin123', so we need to hash it
                userDao.updatePassword("admin@moviebooking.com", PasswordUtil.hashPassword("admin123"));
                System.out.println("✓ Updated SQL admin password to hashed version");
            }
            
            // Check if moviemint admin already exists
            User existingAdmin = userDao.getUserByEmail("admin@moviemint.com");
            
            if (existingAdmin == null) {
                // Create admin user with hashed password
                User admin = new User();
                admin.setFullName("Super Admin");
                admin.setEmail("admin@moviemint.com");
                admin.setPhone("9999999999"); // Added phone to avoid constraint error
                admin.setPassword(PasswordUtil.hashPassword("admin123"));
                admin.setRole("admin");
                
                boolean created = userDao.registerUser(admin);
                
                if (created) {
                    System.out.println("✓ Default admin user created successfully");
                    System.out.println("  Email: admin@moviemint.com");
                    System.out.println("  Password: admin123");
                } else {
                    System.err.println("✗ Failed to create default admin user");
                }
            } else {
                System.out.println("✓ Admin user already exists");
            }
            
        } catch (Exception e) {
            System.err.println("✗ Error initializing admin user: " + e.getMessage());
            e.printStackTrace();
        }
    }
}

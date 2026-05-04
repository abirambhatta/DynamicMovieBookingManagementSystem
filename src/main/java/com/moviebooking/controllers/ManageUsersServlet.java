package com.moviebooking.controllers;

import com.moviebooking.dao.UserDao;
import com.moviebooking.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * Servlet for admin to manage users.
 * Shows all users with search and sort features.
 * Admin can delete, block, or unblock users.
 * Uses Selection Sort for sorting and Binary Search for searching (DSA algorithms).
 */
@WebServlet("/manageUsers")
public class ManageUsersServlet extends HttpServlet {
    private final UserDao userDao = new UserDao();

    /**
     * Show all users, or handle delete/block actions.
     * Supports search by name/email and sort by name/date/bookings.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");

        // Handle delete action
        if ("delete".equals(action)) {
            handleDelete(request, response);
            return;
        }
        
        // Handle change role action
        if ("changeRole".equals(action)) {
            handleChangeRole(request, response);
            return;
        }

        // Get statistics
        int totalUsers = userDao.getTotalUsers();
        int totalAdmins = userDao.countAdmins();
        int newUsersThisMonth = userDao.getNewUsersThisMonth();
        int activeUsers = userDao.getActiveUsers();
        
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("totalAdmins", totalAdmins);
        request.setAttribute("newUsersThisMonth", newUsersThisMonth);
        request.setAttribute("activeUsers", activeUsers);

        // Get filter parameters
        String search = request.getParameter("search");
        String sort = request.getParameter("sort");
        String role = request.getParameter("role");
        String period = request.getParameter("period");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        
        List<User> users;
        
        // Apply filters if provided
        if ((role != null && !role.isEmpty() && !"all".equals(role)) 
            || (period != null && !period.isEmpty()) 
            || (startDate != null && !startDate.isEmpty())) {
            users = userDao.getUsersByFilter(role, period, startDate, endDate);
        } else {
            users = userDao.getAllUsers();
        }
        
        if (search != null && !search.trim().isEmpty()) {
            // If user searched something, sort by name first then use binary search
            selectionSortByName(users);
            users = binarySearch(users, search.trim().toLowerCase());
        } else if (sort != null && !sort.isEmpty()) {
            // If user chose a sort option, sort the list
            if ("name".equals(sort)) {
                selectionSortByName(users);        // Sort A to Z by name
            } else if ("date".equals(sort)) {
                selectionSortByDate(users);        // Sort by newest registration date
            } else if ("bookings".equals(sort)) {
                selectionSortByBookings(users);    // Sort by most bookings first
            }
        }

        // Pass users list to JSP page and show it
        request.setAttribute("users", users);
        request.getRequestDispatcher("/WEB-INF/pages/manageUsers.jsp").forward(request, response);
    }
    
    // ==========================================
    // Data Structure Algorithms (DSA) Section
    // ==========================================
    
    /**
     * Selection Sort - sorts users by name (A to Z).
     * How it works:
     * 1. Loop through the list
     * 2. Find the smallest name in the remaining list
     * 3. Swap it with the current position
     * 4. Repeat until the list is sorted
     */
    private void selectionSortByName(List<User> list) {
        int n = list.size();
        // Go through each position in the list
        for (int i = 0; i < n - 1; i++) {
            int minIdx = i; // Assume current position has the smallest name
            // Find the user with the smallest name in the rest of the list
            for (int j = i + 1; j < n; j++) {
                if (list.get(j).getFullName().compareToIgnoreCase(list.get(minIdx).getFullName()) < 0) {
                    minIdx = j; // Found a smaller name
                }
            }
            // Swap the smallest name user with the current position
            User temp = list.get(minIdx);
            list.set(minIdx, list.get(i));
            list.set(i, temp);
        }
    }
    
    /**
     * Selection Sort - sorts users by registration date (newest first).
     * Works same as name sort but compares dates instead of names.
     * Handles null dates by putting them at the end.
     */
    private void selectionSortByDate(List<User> list) {
        int n = list.size();
        for (int i = 0; i < n - 1; i++) {
            int maxIdx = i; // Start with current position
            for (int j = i + 1; j < n; j++) {
                boolean jIsAfter = false;
                // Compare dates - check if j's date is after maxIdx's date
                if (list.get(j).getRegistrationDate() != null && list.get(maxIdx).getRegistrationDate() != null) {
                    jIsAfter = list.get(j).getRegistrationDate().after(list.get(maxIdx).getRegistrationDate());
                } else if (list.get(j).getRegistrationDate() != null) {
                    jIsAfter = true; // If maxIdx has no date but j has, j comes first
                }
                
                if (jIsAfter) {
                    maxIdx = j; // Found a newer date
                }
            }
            // Swap the user with newest date to the current position
            User temp = list.get(maxIdx);
            list.set(maxIdx, list.get(i));
            list.set(i, temp);
        }
    }
    
    /**
     * Selection Sort - sorts users by booking count (most bookings first).
     * Users with more bookings appear at the top of the list.
     */
    private void selectionSortByBookings(List<User> list) {
        int n = list.size();
        for (int i = 0; i < n - 1; i++) {
            int maxIdx = i; // Start with current position
            // Find the user with the most bookings in the rest of the list
            for (int j = i + 1; j < n; j++) {
                if (list.get(j).getBookingCount() > list.get(maxIdx).getBookingCount()) {
                    maxIdx = j; // Found a user with more bookings
                }
            }
            // Swap the user with most bookings to the current position
            User temp = list.get(maxIdx);
            list.set(maxIdx, list.get(i));
            list.set(i, temp);
        }
    }

    /**
     * Binary Search - searches for users by name or email.
     * The list must be sorted by name first (done by selectionSortByName).
     * How it works:
     * 1. Look at the middle of the list
     * 2. If match found, expand left and right to find all matches
     * 3. If search word is smaller, search the left half
     * 4. If search word is bigger, search the right half
     * 5. Repeat until found or no more items to check
     */
    private List<User> binarySearch(List<User> sortedList, String query) {
        List<User> result = new java.util.ArrayList<>();
        int low = 0;
        int high = sortedList.size() - 1;

        while (low <= high) {
            // Find the middle position
            int mid = (low + high) / 2;
            User midUser = sortedList.get(mid);
            String midName = midUser.getFullName().toLowerCase();
            String midEmail = midUser.getEmail().toLowerCase();

            // Check if the middle user's name or email starts with the search word
            if (midName.startsWith(query) || midEmail.startsWith(query)) {
                // Found a match - add it to results
                result.add(midUser);
                
                // Look left to find more matches
                int left = mid - 1;
                while (left >= 0 && (sortedList.get(left).getFullName().toLowerCase().startsWith(query) || 
                                     sortedList.get(left).getEmail().toLowerCase().startsWith(query))) {
                    result.add(sortedList.get(left));
                    left--;
                }
                
                // Look right to find more matches
                int right = mid + 1;
                while (right < sortedList.size() && (sortedList.get(right).getFullName().toLowerCase().startsWith(query) || 
                                                     sortedList.get(right).getEmail().toLowerCase().startsWith(query))) {
                    result.add(sortedList.get(right));
                    right++;
                }
                break; // All matches found, stop searching
            } else if (midName.compareTo(query) < 0) {
                // Search word is bigger - search the right half
                low = mid + 1;
            } else {
                // Search word is smaller - search the left half
                high = mid - 1;
            }
        }
        return result;
    }

    /**
     * Handle deleting a user from the system.
     * Prevents deleting the last admin to avoid lockout.
     */
    private void handleDelete(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int userId = Integer.parseInt(request.getParameter("id"));
            User user = userDao.getUserById(userId);
            
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/manageUsers?error=User not found");
                return;
            }
            
            // Prevent deleting the last admin
            if ("admin".equals(user.getRole())) {
                int adminCount = userDao.countAdmins();
                if (adminCount <= 1) {
                    response.sendRedirect(request.getContextPath() + "/manageUsers?error=Cannot delete the last admin");
                    return;
                }
            }
            
            boolean isDeleted = userDao.deleteUser(userId);

            if (isDeleted) {
                response.sendRedirect(request.getContextPath() + "/manageUsers?success=User deleted successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/manageUsers?error=Failed to delete user");
            }
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/manageUsers?error=Invalid user ID");
        }
    }
    
    /**
     * Handle changing a user's role.
     * Prevents demoting the last admin to avoid lockout.
     */
    private void handleChangeRole(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int userId = Integer.parseInt(request.getParameter("id"));
            String newRole = request.getParameter("role");
            
            if (newRole == null || (!"user".equals(newRole) && !"admin".equals(newRole))) {
                response.sendRedirect(request.getContextPath() + "/manageUsers?error=Invalid role");
                return;
            }
            
            User user = userDao.getUserById(userId);
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/manageUsers?error=User not found");
                return;
            }
            
            // Prevent demoting the last admin
            if ("admin".equals(user.getRole()) && "user".equals(newRole)) {
                int adminCount = userDao.countAdmins();
                if (adminCount <= 1) {
                    response.sendRedirect(request.getContextPath() + "/manageUsers?error=Cannot demote the last admin");
                    return;
                }
            }
            
            user.setRole(newRole);
            boolean updated = userDao.updateUser(user);
            
            if (updated) {
                HttpSession session = request.getSession(false);
                User loggedInUser = (session != null) ? (User) session.getAttribute("user") : null;
                
                // Log the user out if they demoted themselves
                if (loggedInUser != null && loggedInUser.getUserId() == userId && "user".equals(newRole)) {
                    session.invalidate();
                    response.sendRedirect(request.getContextPath() + "/login?message=You+have+been+logged+out+because+your+admin+privileges+were+removed.");
                    return;
                }
                
                response.sendRedirect(request.getContextPath() + "/manageUsers?success=Role+changed+successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/manageUsers?error=Failed+to+change+role");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/manageUsers?error=Error changing role");
        }
    }
}

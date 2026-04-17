<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.moviebooking.config.DBConnection" %>
<!DOCTYPE html>
<html>
<head>
    <title>Reset Admin Account</title>
    <style>
        body { font-family: Arial; padding: 50px; background: #f4f4f4; }
        .container { max-width: 600px; margin: 0 auto; background: white; padding: 30px; border-radius: 8px; }
        .success { color: green; padding: 10px; background: #d4edda; border-radius: 4px; margin: 10px 0; }
        .error { color: red; padding: 10px; background: #f8d7da; border-radius: 4px; margin: 10px 0; }
        .btn { background: #007bff; color: white; padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; }
        .info { background: #d1ecf1; padding: 15px; border-radius: 4px; margin: 20px 0; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Reset Admin Account</h1>
        
        <%
            String action = request.getParameter("action");
            
            if ("reset".equals(action)) {
                try {
                    Connection conn = DBConnection.getConnection();
                    
                    // Reset admin account
                    String query = "UPDATE users SET failed_attempts = 0, account_locked = false WHERE email = 'admin@moviebooking.com'";
                    Statement stmt = conn.createStatement();
                    int rows = stmt.executeUpdate(query);
                    
                    if (rows > 0) {
                        out.println("<div class='success'>✓ Admin account reset successfully!</div>");
                        out.println("<div class='info'>");
                        out.println("<p><strong>You can now login with:</strong></p>");
                        out.println("<p>Email: admin@moviebooking.com</p>");
                        out.println("<p>Password: admin123</p>");
                        out.println("</div>");
                    } else {
                        out.println("<div class='error'>✗ Admin account not found!</div>");
                    }
                    
                    stmt.close();
                    conn.close();
                } catch (Exception e) {
                    out.println("<div class='error'>✗ Error: " + e.getMessage() + "</div>");
                }
            }
        %>
        
        <h2>Current Admin Status:</h2>
        <%
            try {
                Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery("SELECT * FROM users WHERE email = 'admin@moviebooking.com'");
                
                if (rs.next()) {
                    out.println("<table border='1' cellpadding='10' style='width:100%; border-collapse: collapse;'>");
                    out.println("<tr><td><strong>Email:</strong></td><td>" + rs.getString("email") + "</td></tr>");
                    out.println("<tr><td><strong>Password:</strong></td><td>" + rs.getString("password") + "</td></tr>");
                    out.println("<tr><td><strong>Role:</strong></td><td>" + rs.getString("role") + "</td></tr>");
                    out.println("<tr><td><strong>Failed Attempts:</strong></td><td>" + rs.getInt("failed_attempts") + "</td></tr>");
                    out.println("<tr><td><strong>Account Locked:</strong></td><td>" + (rs.getBoolean("account_locked") ? "YES" : "NO") + "</td></tr>");
                    out.println("</table>");
                    
                    if (rs.getBoolean("account_locked") || rs.getInt("failed_attempts") > 0) {
                        out.println("<br><div class='error'>⚠ Account needs to be reset!</div>");
                    }
                } else {
                    out.println("<div class='error'>Admin user not found in database!</div>");
                }
                
                rs.close();
                stmt.close();
                conn.close();
            } catch (Exception e) {
                out.println("<div class='error'>Error: " + e.getMessage() + "</div>");
            }
        %>
        
        <br><br>
        <form method="get">
            <input type="hidden" name="action" value="reset">
            <button type="submit" class="btn">Reset Admin Account</button>
        </form>
        
        <br><br>
        <a href="login">Go to Login Page</a>
    </div>
</body>
</html>

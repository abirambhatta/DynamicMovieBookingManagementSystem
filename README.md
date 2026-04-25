# MovieMint - Movie Booking Management System

## Project Overview
A complete movie booking management system with admin and user portals, featuring secure authentication, real-time seat selection, and email notifications.

## Key Features

### User Features
- ✅ User registration and login with encrypted passwords
- ✅ Browse movies with search and filters
- ✅ Real-time seat selection with hall configuration
- ✅ Book tickets with dynamic pricing (Standard/Premium/Recliner/VIP)
- ✅ View booking history
- ✅ Receive booking confirmation emails
- ✅ Password reset with OTP verification (2FA)
- ✅ User profile management

### Admin Features
- ✅ Admin dashboard with analytics
- ✅ Manage movies (Add/Edit/Delete with TMDB integration)
- ✅ Manage users (View/Edit/Delete)
- ✅ Manage bookings (View/Cancel)
- ✅ Manage hall configurations
- ✅ Manage global settings (pricing, hall layouts)
- ✅ Filter and export data by date ranges
- ✅ Real-time statistics (revenue, bookings, users)

### Security Features
- ✅ Password encryption with PBKDF2-SHA256 (10,000 iterations)
- ✅ Two-factor authentication (2FA) with OTP for password reset
- ✅ Email notifications via Google SMTP
- ✅ Session-based authentication
- ✅ Role-based access control (Admin/User)

## Technology Stack

### Backend
- Java Servlets (Jakarta EE)
- JDBC for database operations
- MySQL database
- JavaMail API for email sending

### Frontend
- JSP (JavaServer Pages)
- HTML5, CSS3, JavaScript
- Material Symbols icons
- Responsive design

### Security
- PBKDF2-SHA256 password hashing
- OTP-based 2FA
- TLS email encryption

## Project Structure

```
src/main/java/com/moviebooking/
├── config/
│   └── DBConnection.java
├── controllers/
│   ├── AdminHomeServlet.java
│   ├── BookTicketServlet.java
│   ├── ForgotPasswordServlet.java
│   ├── LoginServlet.java
│   ├── RegisterServlet.java
│   └── ... (other servlets)
├── dao/
│   ├── BookingDao.java
│   ├── MovieDao.java
│   ├── UserDao.java
│   └── ... (other DAOs)
├── model/
│   ├── Booking.java
│   ├── Movie.java
│   ├── User.java
│   └── ... (other models)
├── service/
│   ├── EmailService.java
│   ├── UserService.java
│   └── TmdbService.java
└── util/
    ├── OtpUtil.java
    ├── PasswordUtil.java
    └── Validation.java

src/main/webapp/
├── WEB-INF/
│   └── pages/
│       ├── adminHome.jsp
│       ├── bookTicket.jsp
│       ├── forgotPassword.jsp
│       ├── login.jsp
│       ├── myBookings.jsp
│       └── ... (other JSPs)
└── css/
    └── style.css
```

## Database Schema

### Main Tables
- `users` - User accounts with encrypted passwords and OTP fields
- `movies` - Movie information with pricing
- `bookings` - Booking records with seat information
- `showtimes` - Movie showtimes and hall assignments
- `hall_configs` - Hall layouts and seat configurations
- `global_settings` - System-wide settings

## Color Scheme
- Primary: #dc143c (MovieMint Red)
- Primary Hover: #b71c1c
- Background: #f8f9fa
- Text: #212529
- Secondary Text: #6c757d
- White: #ffffff

## Setup Requirements

### Prerequisites
- Java 17 or higher
- Apache Tomcat 10.1+
- MySQL 8.0+
- Gmail account with app password for email sending

### Dependencies
- Jakarta Servlet API
- MySQL Connector/J
- JavaMail API (javax.mail-1.6.2.jar)
- Jakarta Activation (jakarta.activation-1.2.2.jar)

## Configuration

### Database
Update `DBConnection.java` with your MySQL credentials:
```java
private static final String URL = "jdbc:mysql://localhost:3306/moviebooking";
private static final String USER = "root";
private static final String PASSWORD = "your_password";
```

### Email
Update `EmailService.java` with your Gmail credentials:
```java
private static final String SENDER_EMAIL = "your-email@gmail.com";
private static final String APP_PASSWORD = "your-app-password";
```

## Default Admin Account
- Email: admin@moviebooking.com
- Password: (encrypted in database)

## Documentation
- `SECURITY_FEATURES.md` - Security implementation details
- `add_otp_columns.sql` - Database migration for OTP fields

## Author
Abiram Bhatta

## Repository
https://github.com/abirambhatta/DynamicMovieBookingManagementSystem

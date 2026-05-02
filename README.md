# MovieMint - Movie Booking Management System

A full-stack web application for booking movie tickets with advanced admin management features, dynamic seat mapping, and real-time revenue analytics.

## Features
- **Security**: Role-Based Access Control (Admin/User) and OTP-based password reset.
- **Catalog Management**: Deep TMDB API integration for auto-filling movie details and downloading posters, with YouTube trailer fallback.
- **Dynamic Booking Engine**: Interactive JSON-powered seat maps that update in real-time.
- **Advanced Pricing**: Support for 4-Tier pricing (Standard, Premium, Recliner, VIP) with global fallbacks.
- **Hall Configuration**: Dynamic theater layouts (e.g., Audi 01, Audi 02) with custom row-to-tier mappings.
- **Admin Dashboard**: Real-time business intelligence using Chart.js to track revenue, popular movies, and seat distribution.
- **Data Integrity**: Soft-delete architecture for preserving financial history.

## Technology Stack
- **Backend**: Java 21, Jakarta EE (Servlets, JSP, JSTL)
- **Frontend**: JSP, Vanilla CSS3, Vanilla JS, Chart.js
- **Database**: MySQL 8.0+
- **Server**: Apache Tomcat 10.1+
- **APIs**: TMDB API (The Movie Database), YouTube Search Fallback

## Prerequisites
- Java 21 or higher
- Apache Tomcat 10.1 or higher
- MySQL 8.0 or higher
- Gmail account with App Password (for email features)
- TMDB API key (free from https://www.themoviedb.org/settings/api)

## Setup Instructions

### 1. Clone the Repository
```bash
git clone https://github.com/abirambhatta/DynamicMovieBookingManagementSystem.git
cd DynamicMovieBookingManagementSystem
```

### 2. Database Setup
Create a MySQL database and import the schema. **Note:** See `DATABASE_SCHEMA.sql` for the full, detailed initialization script.

```sql
CREATE DATABASE movie_booking_db;
USE movie_booking_db;

-- Core Tables (Simplified Overview)
-- Refer to DATABASE_SCHEMA.sql or the Total Code Breakdown for full schema details.

-- users: Stores admins and users, hashed passwords, and OTP logic.
-- movies: Stores catalog data, 4-tier custom pricing, and soft-delete status.
-- hall_config: Defines theater layouts (e.g., "S S | P P | V V") and tier mappings.
-- system_settings: Global constants and default ticket prices.
-- show_times: The schedule linking movies, dates, times, and halls.
-- bookings: The transactional record of sold seats and revenue.
```

### 3. Environment Configuration
Create a `.env` file in the project root directory:

```bash
cp .env.example .env
```

Edit `.env` with your credentials:

```properties
# Database Configuration
DB_URL=jdbc:mysql://localhost:3306/movie_booking_db
DB_USER=root
DB_PASSWORD=your_mysql_password

# Email Configuration (Gmail)
SENDER_EMAIL=your_email@gmail.com
EMAIL_APP_PASSWORD=your_gmail_app_password

# TMDB API Configuration
TMDB_API_KEY=your_tmdb_api_key
```

#### Getting Gmail App Password:
1. Enable 2-Factor Authentication on your Gmail account
2. Go to https://myaccount.google.com/apppasswords
3. Generate a new app password for "Mail"
4. Copy the 16-character password to `.env`

#### Getting TMDB API Key:
1. Create account at https://www.themoviedb.org/
2. Go to Settings → API
3. Request API key (free)
4. Copy the API Key (v3 auth) to `.env`

### 4. Deploy to Tomcat

**Required JAR Files** (already included in `src/main/webapp/WEB-INF/lib/`):
- mysql-connector-j-9.6.0.jar
- jakarta.servlet-api-5.0.0.jar
- jakarta.servlet.jsp.jstl-2.0.0.jar
- jakarta.servlet.jsp.jstl-api-2.0.0.jar
- jakarta.activation-1.2.2.jar
- jakarta.el-api-4.0.0.jar
- jakarta.xml.bind-api-3.0.0.jar
- javax.mail-1.6.2.jar
- json-20251224.jar
- itextpdf-5.5.13.3.jar
- xmlworker-5.5.13.3.jar

**Deployment Steps:**
1. Build the project (if using Eclipse: Export → WAR file)
2. Copy the WAR file to `[TOMCAT_HOME]/webapps/`
3. Start Tomcat server
4. Access the application at `http://localhost:8080/MovieBookingManagementSystem/`

## Documentation & Viva Prep
This project includes extensive internal documentation for academic defense:
1. **Total Code Breakdown (Vol 1-9)**: Line-by-line explanations of complex logic.
2. **DATABASE_SCHEMA.sql**: Complete database blueprint with foreign key rules and seed data.
3. **MovieBooking_MCP.md**: The Master Context Prompt for architectural overview.
4. **Project_Wireframes.html**: A 1:1 visual structural replica of the entire application.

## Default Login Credentials
- **Admin**: admin@moviebooking.com / admin123
- **User**: Create new account via registration

## Security Notes
- Never commit `.env` file to version control
- Change default admin password after first login
- Use strong passwords for database and email
- Keep dependencies updated

## Author
Abiram Bhatta

## License
This project is for educational purposes.

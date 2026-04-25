# MovieMint - Movie Booking Management System

A full-stack web application for booking movie tickets with admin management features.

## Features
- User authentication with OTP-based password reset
- Browse movies with TMDB API integration
- Book tickets with seat selection
- Email confirmation with PDF tickets
- Admin dashboard for managing movies, shows, and bookings

## Technology Stack
- **Backend**: Java 21, Jakarta EE (Servlets, JSP, JSTL)
- **Frontend**: JSP, Tailwind CSS
- **Database**: MySQL 8.0+
- **Server**: Apache Tomcat 10.1+
- **APIs**: TMDB API for movie data

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
Create a MySQL database and import the schema:

```sql
CREATE DATABASE movie_booking_db;
USE movie_booking_db;

-- Create users table
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('user', 'admin') DEFAULT 'user',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    otp VARCHAR(6),
    otp_expiry TIMESTAMP
);

-- Create movies table
CREATE TABLE movies (
    movie_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    genre VARCHAR(100),
    duration INT,
    release_date DATE,
    poster_url VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create showtimes table
CREATE TABLE showtimes (
    showtime_id INT PRIMARY KEY AUTO_INCREMENT,
    movie_id INT,
    show_date DATE NOT NULL,
    show_time TIME NOT NULL,
    hall VARCHAR(50),
    available_seats INT DEFAULT 100,
    price DECIMAL(10,2),
    FOREIGN KEY (movie_id) REFERENCES movies(movie_id) ON DELETE CASCADE
);

-- Create bookings table
CREATE TABLE bookings (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    showtime_id INT,
    seats VARCHAR(255),
    number_of_seats INT,
    total_price DECIMAL(10,2),
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('confirmed', 'cancelled') DEFAULT 'confirmed',
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (showtime_id) REFERENCES showtimes(showtime_id) ON DELETE CASCADE
);

-- Admin user will be auto-created on first application startup
-- Email: admin@moviemint.com
-- Password: admin123
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

## Default Login Credentials
- **Admin**: admin@moviemint.com / admin123
- **User**: Create new account via registration

## Project Structure
```
MovieBookingManagementSystem/
├── src/main/java/com/moviebooking/
│   ├── config/          # Database connection
│   ├── controllers/     # Servlets
│   ├── dao/            # Data Access Objects
│   ├── models/         # Entity classes
│   ├── service/        # Business logic
│   └── util/           # Utility classes
├── src/main/webapp/
│   ├── WEB-INF/
│   │   ├── pages/      # JSP files
│   │   ├── lib/        # JAR dependencies
│   │   └── web.xml     # Deployment descriptor
│   └── index.jsp       # Landing page
└── .env                # Environment variables (create this)
```

## Troubleshooting

### Database Connection Issues
- Verify MySQL is running
- Check database name, username, and password in `.env`
- Ensure MySQL port 3306 is not blocked

### Email Not Sending
- Verify Gmail App Password is correct (16 characters, no spaces)
- Check if 2FA is enabled on Gmail account
- Ensure firewall allows SMTP port 587

### TMDB API Not Working
- Verify API key is valid in `.env` file
- Ensure `.env` file is in the correct location (project root or Tomcat working directory)
- Ensure internet connection is active

### Tomcat Deployment Issues
- Check Tomcat logs in `[TOMCAT_HOME]/logs/catalina.out`
- Verify Java version is 21+
- Ensure all JAR files are in WEB-INF/lib

## Security Notes
- Never commit `.env` file to version control
- Change default admin password after first login
- Use strong passwords for database and email
- Keep dependencies updated

## Author
Abiram Bhatta

## License
This project is for educational purposes.

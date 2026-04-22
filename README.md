# MovieMint - Movie Booking Management System

A comprehensive web-based movie ticket booking platform built with Java Servlets, JSP, and MySQL.

## Features

### User Features
- Browse movies with filters (genre, language)
- Real-time autocomplete search
- Interactive seat selection with visual seat map
- Multiple seat types (Standard, Premium, Recliner, VIP)
- Real-time booking validation
- Responsive design
- User profile management
- View booking history

### Admin Features
- Comprehensive dashboard with charts
- Movie management (CRUD operations)
- Dynamic hall configuration
- User management
- Revenue analytics (daily, monthly, yearly)
- Global settings management
- Booking management

### Technical Features
- REST API endpoints for AJAX operations
- Password strength validation
- Modern UI with smooth animations
- Chart.js integration for analytics
- Secure authentication and authorization
- MySQL database with optimized queries

## Technology Stack

- **Backend**: Java Servlets, JSP
- **Frontend**: HTML5, CSS3, JavaScript (ES6+)
- **Database**: MySQL
- **Server**: Apache Tomcat
- **Libraries**: 
  - Chart.js (for analytics)
  - JSTL (JSP Standard Tag Library)
  - Jakarta Servlet API

## Prerequisites

- Java JDK 11 or higher
- Apache Tomcat 10.x
- MySQL 8.0 or higher
- Maven (optional, for dependency management)

## Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/MovieBookingManagementSystem.git
   cd MovieBookingManagementSystem
   ```

2. **Set up MySQL database**
   ```sql
   CREATE DATABASE movie_booking;
   ```

3. **Configure database connection**
   - Edit `src/main/java/com/moviebooking/config/DBConnection.java`
   - Update database credentials:
     ```java
     private static final String URL = "jdbc:mysql://localhost:3306/movie_booking";
     private static final String USER = "your_username";
     private static final String PASSWORD = "your_password";
     ```

4. **Deploy to Tomcat**
   - Copy the project to Tomcat's webapps directory
   - Or use Eclipse/IntelliJ to run on Tomcat

5. **Access the application**
   - Open browser: `http://localhost:8080/MovieBookingManagementSystem`
   - Default admin credentials will be created on first run

## Project Structure

```
MovieBookingManagementSystem/
├── src/main/
│   ├── java/com/moviebooking/
│   │   ├── config/          # Database configuration
│   │   ├── controllers/     # Servlets
│   │   ├── dao/            # Data Access Objects
│   │   ├── model/          # Entity classes
│   │   ├── filter/         # Authentication filters
│   │   └── util/           # Utility classes
│   └── webapp/
│       ├── css/            # Stylesheets
│       ├── js/             # JavaScript files
│       ├── images/         # Movie posters and images
│       └── WEB-INF/
│           ├── pages/      # JSP pages
│           ├── lib/        # JAR libraries
│           └── web.xml     # Deployment descriptor
└── build/                  # Compiled classes (gitignored)
```

## REST API Endpoints

### Booking Validation
```
POST /api/bookings/validate
Body: movieId, showTime, seatIds
Response: {success: true/false, error: "message"}
```

### Movie Search
```
GET /api/movies/search?q=inception
Response: {success: true, movies: [...]}
```

### Seat Availability
```
GET /api/seats/available?movieId=1&showTime=2025-04-27 18:00 - Audi 01
Response: {success: true, bookedSeats: "A1,A2,B3"}
```

### Revenue Statistics
```
GET /api/stats/revenue?period=month
Response: {success: true, data: [...]}
```

### Recent Bookings
```
GET /api/stats/bookings/recent?limit=10
Response: {success: true, bookings: [...]}
```

## Key Features Explained

### Dynamic Seat Selection
- Visual seat map with 3D perspective
- Color-coded seat types
- Real-time reservation status
- Maximum 10 seats per booking
- 15-minute booking cutoff before showtime

### Password Security
- Minimum 8 characters
- Requires uppercase, lowercase, number, and special character
- Real-time strength indicator
- Client and server-side validation

### Hall Configuration
- Customizable seat layouts per hall
- Dynamic row assignments (Standard/Premium/Recliner/VIP)
- Configurable seats per row
- Multiple hall support

### Analytics Dashboard
- Revenue charts (daily, monthly, yearly)
- Movie booking statistics
- Seat type distribution
- Top movies ranking

## Database Schema

### Main Tables
- `users` - User accounts and profiles
- `movies` - Movie information
- `bookings` - Ticket bookings
- `show_times` - Movie showtimes
- `hall_config` - Hall seat configurations
- `system_settings` - Global application settings

## Security Features

- Password hashing (implement bcrypt recommended)
- Session-based authentication
- Role-based access control (User/Admin)
- SQL injection prevention (PreparedStatements)
- XSS protection (input sanitization)
- CSRF protection (implement tokens recommended)

## Browser Support

- Chrome/Edge (latest)
- Firefox (latest)
- Safari (latest)
- Mobile browsers

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## Future Enhancements

- [ ] Payment gateway integration
- [ ] Email notifications
- [ ] QR code tickets
- [ ] Mobile app (using REST APIs)
- [ ] Social media login
- [ ] Movie ratings and reviews
- [ ] Loyalty points system
- [ ] Multi-language support

## License

This project is open source and available under the [MIT License](LICENSE).

## Contact

Your Name - [@yourhandle](https://twitter.com/yourhandle)

Project Link: [https://github.com/yourusername/MovieBookingManagementSystem](https://github.com/yourusername/MovieBookingManagementSystem)

## Acknowledgments

- Chart.js for beautiful charts
- Jakarta EE for servlet specifications
- MySQL for reliable database
- All contributors and testers

---

**Note**: This is a college/educational project. For production use, implement additional security measures like bcrypt password hashing, HTTPS, CSRF tokens, and proper error handling.

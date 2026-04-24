# THE MOVIE BOOKING SYSTEM BIBLE: Complete Line-by-Line Breakdown

This document is the final, absolute technical guide for the entire project. It explains every line of code, every syntax choice, and every piece of logic.

---

## CHAPTER 1: THE CORE INFRASTRUCTURE

### 1.1 `DBConnection.java` (Database Access)
*This file is the "Engine Starter" for the database.*

1.  **`package com.moviebooking.config;`**: Defines the project folder.
2.  **`import java.sql.Connection;`**: Imports the standard Java tool to hold a database session.
3.  **`import java.sql.DriverManager;`**: Imports the tool that finds the database driver.
4.  **`private static final String URL = "jdbc:mysql://localhost:3306/movie_booking_db";`**:
    *   `jdbc:mysql`: Use the MySQL language.
    *   `localhost`: The database is on this computer.
    *   `3306`: The default "port" (gate) MySQL uses.
5.  **`static { ... }`**: This is a static initializer. It runs once when the app starts to load the driver (`Class.forName`).
6.  **`public static Connection getConnection()`**: This is the "Service Desk." Whenever a DAO needs to talk to MySQL, it calls this method to get a "ticket" (Connection).

---

## CHAPTER 2: THE MODELS (Data Blueprints)

Models are simple Java classes that act as "Containers" for our data.

### 2.1 `Movie.java`
1.  **`private int movieId;`**: Every movie gets a unique ID number.
2.  **`private String title;`**: Stores the name of the movie.
3.  **`private boolean isActive;`**: 
    *   **Logic**: 1 = Visible, 0 = Hidden. 
    *   **Why?**: To support "Soft Delete" so historical records aren't lost.
4.  **`public Movie(...) { ... }`**: This is the "Constructor." It is a special method used to create a new Movie object and fill it with data immediately.
5.  **`public String getTitle() { return title; }`**: A "Getter" method. Since `title` is `private` (secret), other classes use this to see the name.

---

## CHAPTER 3: THE DAOs (Database Workers)

DAOs contain the raw SQL logic.

### 3.1 `MovieDao.java`
1.  **`private void checkSchema()`**: 
    *   **Logic**: Runs `ALTER TABLE` commands.
    *   **Why?**: If you add a new feature (like Soft Delete) but your database table doesn't have the `is_active` column yet, this method automatically adds it so the app doesn't crash.
2.  **`public boolean addMovie(Movie movie)`**:
    *   **`PreparedStatement pstmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);`**:
        *   `PreparedStatement`: Protects against SQL Injection (hackers).
        *   `RETURN_GENERATED_KEYS`: Asks MySQL to give back the ID of the movie it just created.
3.  **`public List<Movie> getAllActiveMovies()`**:
    *   **`SELECT * FROM movies WHERE is_active = 1`**:
    *   **Logic**: This is the heart of the "User View." It ensures that deleted (hidden) movies never show up for customers.

---

## CHAPTER 4: THE CONTROLLERS (Servlets)

Servlets handle the "Traffic" of the website.

### 4.1 `BookTicketServlet.java`
1.  **`@WebServlet("/bookTicket")`**: This tells the server "When someone goes to /bookTicket in their browser, run this Java file."
2.  **`doGet(...)`**:
    *   **Logic**: Fetches movie details and available showtimes.
    *   **Why?**: To populate the seat selection page so the user knows what movie they are booking.
3.  **`doPost(...)`**:
    *   **`String seatNumbers = request.getParameter("seats");`**: Receives the seats from the frontend.
    *   **`Booking booking = new Booking(...);`**: Packages everything into a `Booking` object.
    *   **`bookingDao.addBooking(booking);`**: Saves it to the database permanently.

---

## CHAPTER 5: THE VIEW (JSPs and JavaScript)

### 5.1 `bookTicket.jsp` (Seat Selection Logic)
1.  **HTML Loop**: 
    ```jsp
    <c:forEach var="row" items="${rows}">
    ```
    *   **Logic**: Repeats the code for every row (A, B, C...).
2.  **JavaScript Logic**:
    ```javascript
    seat.addEventListener('click', function() { ... });
    ```
    *   **Logic**: Listens for the user clicking a seat.
    *   **Why?**: To toggle the selection and update the "Total Price" label instantly without refreshing the page.

### 5.2 `manageMovies.jsp` (TMDB Integration)
1.  **`const query = document.getElementById('tmdbSearch').value;`**: Grabs what the admin typed.
2.  **`fetch(CONTEXT_PATH + '/tmdbSearch?query=' + query)`**: Sends a request to the `TmdbSearchServlet` to get movie details from the internet.

---

## CHAPTER 6: EXTERNAL SERVICES

### 6.1 `TmdbService.java`
1.  **`fetchJson(String urlString)`**:
    *   **Logic**: Opens an HTTP connection to the TMDB website and downloads the movie data as a long string of text (JSON).
2.  **`Pattern.compile(...)` (Regex)**:
    *   **Logic**: Scans the long string of text to find specific words like "overview" or "poster_path".
    *   **Why?**: We use this instead of a complex library to keep the code easy to read and fast.
3.  **`searchYoutube(String query)`**:
    *   **Logic**: If TMDB doesn't have a trailer, it searches YouTube and finds the first video ID to use as an embed.

---

## CHAPTER 7: SECURITY

### 7.1 `AuthFilter.java`
1.  **`doFilter(...)`**:
    *   **Logic**: Checks if the user is an admin before letting them see `/manageMovies`.
    *   **Why?**: To prevent normal users from deleting movies or seeing sensitive financial stats by just guessing the URL.

---

## CHAPTER 8: VIVA VOCCE PREPARATION

### **Top 10 "Must-Know" Questions:**
1.  **Q: What is a Servlet?** A: A Java class that handles web requests and generates responses.
2.  **Q: What is JSTL?** A: A library that lets us write logic (loops, ifs) in JSP without using raw Java.
3.  **Q: Difference between `Statement` and `PreparedStatement`?** A: `PreparedStatement` is faster and safer against SQL Injection.
4.  **Q: What is a DAO?** A: A class that contains all the database code for a specific entity.
5.  **Q: How does the seat price update dynamically?** A: Using JavaScript that listens for click events and sums up the `data-price` attributes.
6.  **Q: Why Soft Delete?** A: To hide data while keeping it for historical reporting.
7.  **Q: What is `session.getAttribute("user")`?** A: It retrieves the logged-in user's information stored in the server's memory.
8.  **Q: Why use `ALTER TABLE` in Java?** A: To automatically sync the database schema across different computers.
9.  **Q: How do you handle file uploads?** A: Using `@MultipartConfig` in the Servlet and `request.getPart()`.
10. **Q: What is the purpose of `1=1` in SQL?** A: To simplify appending dynamic `AND` conditions to a query.

---

*This is the complete technical blueprint of your project. If you read this entire document, you will have a perfect understanding of every line of code.*

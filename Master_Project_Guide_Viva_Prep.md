# Movie Booking Management System: The Master Technical Guide & Viva Preparation

This document is the ultimate reference for the Movie Booking Management System. it explains every logical block, every architectural decision, and provides a comprehensive preparation guide for a technical viva.

---

## Part 1: Viva Vocce Question Bank (50+ Questions)

### **A. Project Architecture & Basics**
1.  **Q: What design pattern does this project follow?**
    *   **A:** It follows the **MVC (Model-View-Controller)** pattern.
2.  **Q: Explain MVC in the context of your project.**
    *   **A:** 
        *   **Model**: POJO classes in `com.moviebooking.model` (like `Movie.java`) which hold data.
        *   **View**: JSP files in `WEB-INF/pages` that render the HTML.
        *   **Controller**: Servlets in `com.moviebooking.controllers` that handle business logic.
3.  **Q: Why did you use the DAO pattern?**
    *   **A:** DAO (Data Access Object) separates database operations from business logic. If we change our database (e.g., from MySQL to PostgreSQL), we only need to change the DAO classes, not the Servlets.
4.  **Q: What is the role of `web.xml`?**
    *   **A:** It is the Deployment Descriptor. It maps URL patterns to Servlets (though we used `@WebServlet` annotations for most). It also configures welcome files and error pages.
5.  **Q: Why use Servlets instead of just JSPs?**
    *   **A:** To follow the "Separation of Concerns". JSPs are for presentation; Servlets are for complex Java logic. Putting too much Java in a JSP (Scriptlets) is bad practice.

### **B. Database & JDBC**
6.  **Q: How do you connect Java to MySQL?**
    *   **A:** Using **JDBC (Java Database Connectivity)** and the **MySQL Connector/J** driver.
7.  **Q: Explain the `DBConnection.java` static block.**
    *   **A:** `static { Class.forName("com.mysql.cj.jdbc.Driver"); }` loads the MySQL driver into memory once when the class is first used. This is more efficient than loading it every time we need a connection.
8.  **Q: What is a `PreparedStatement` and why use it?**
    *   **A:** It is a pre-compiled SQL statement. We use it to:
        1.  Prevent **SQL Injection** (by using `?` placeholders).
        2.  Improve performance (the database compiles it once).
9.  **Q: What is `RETURN_GENERATED_KEYS` in your `MovieDao.addMovie`?**
    *   **A:** It tells MySQL to return the auto-incremented ID of the row we just inserted. We need this ID to link the movie to showtimes immediately.
10. **Q: Explain "Soft Delete".**
    *   **A:** Instead of `DELETE FROM movies`, we use `UPDATE movies SET is_active = 0`. This hides the movie from users but keeps the data for history/revenue reporting.

### **C. Core Logic & Features**
11. **Q: How does the Seat Selection logic work?**
    *   **A:** In `bookTicket.jsp`, we use a nested loop (Rows and Columns). Each seat is a `div` with a `data-price` and `data-type`. JavaScript listens for clicks, toggles a "selected" class, and sums up the prices.
12. **Q: How do you handle different ticket prices (VIP vs Standard)?**
    *   **A:** We use a `HallConfig` table. For every row (e.g., Row A), we store its type (VIP). During booking, the code looks up the row letter and applies the corresponding price override from the `Movie` or the global default.
13. **Q: Explain the TMDB Auto-fill logic.**
    *   **A:** We use the TMDB API. The admin types a name, JS calls `TmdbSearchServlet`, which uses `TmdbService` to fetch JSON. We parse the JSON to get the title, overview, and poster URL.
14. **Q: How does the YouTube trailer fallback work?**
    *   **A:** If TMDB doesn't have a trailer, `TmdbService` performs a search on YouTube using a URL like `youtube.com/results?search_query=...`. We use **Regex** to find the first video ID (`v=...`) in the HTML code and return the embed link.
15. **Q: What is the `AuthFilter`?**
    *   **A:** It is a **Servlet Filter**. It intercepts every request. If a user tries to access `/manageMovies` without being logged in as an admin, the filter sends them back to the login page.

---

## Part 2: Line-by-Line Code Breakdown (The "Why")

### **1. DBConnection.java**
*   **Line 13 (`jdbc:mysql://...`)**: The connection string. `useSSL=false` is used for local testing to avoid certificate errors.
*   **Line 35 (`getConnection()`)**: This is a static method so we can call `DBConnection.getConnection()` anywhere without creating an object (Singleton pattern).

### **2. MovieDao.java (Method: `checkSchema`)**
*   **Line 17-28**: This method checks if the database tables are up-to-date. If a column like `is_active` is missing (e.g., when moving the project to a new computer), it automatically adds it using `ALTER TABLE`.
*   **Why?**: This makes the project "Plug and Play". The user doesn't have to manually run SQL scripts to update their table structure.

### **3. MovieDao.java (Method: `getMoviesByFilter`)**
*   **Line 433 (`StringBuilder query = ... "WHERE 1=1"`)**: 
    *   **The Logic**: We use `StringBuilder` because the query changes based on user filters. 
    *   **Why `1=1`?**: If the user selects no filters, the query is just `SELECT * FROM movies WHERE 1=1` (which is always true). If they select a genre, we can just append `AND genre = ?`. Without `1=1`, we would have to check if we need to write `WHERE` or `AND` every time.

### **4. TmdbService.java (Regex Logic)**
*   **The Logic**: `\"overview\":\"(.*?)\"`
    *   `\"overview\"`: Looks for the word "overview" in quotes.
    *   `(.*?)`: The "lazy" capture group. It grabs everything until the next quote.
*   **Why use Regex instead of a JSON library?**: To keep the project "Lightweight". Adding libraries like Jackson or Gson increases the file size. Regex is built into Java.

### **5. AuthFilter.java**
*   **Line 34 (`HttpServletRequest httpRequest = (HttpServletRequest) request;`)**: We must cast the generic `ServletRequest` to `HttpServletRequest` to access session data and URLs.
*   **Line 45 (`chain.doFilter(request, response);`)**: This is crucial! It tells the system "Everything is fine, let the user proceed to the page they requested."

---

## Part 3: Advanced Logic (The "How It Works")

### **The Seat Mapping System**
When a user views `bookTicket.jsp`:
1.  The **Servlet** fetches the `HallConfig` for that specific hall.
2.  The **JSP** receives a string like `A,B,C` for VIP rows.
3.  **JavaScript** creates a Map: `{'A': 'VIP', 'B': 'VIP', ...}`.
4.  As you click seats, JS calculates: `If row == 'A', price = Movie.vip_price`.

### **The Soft-Delete Sync**
1.  **Admin** clicks Delete.
2.  `MovieDao` sets `is_active = 0`.
3.  **UserHomeServlet** calls `movieDao.getRecentMovies()`.
4.  The SQL inside `getRecentMovies` has `WHERE is_active = 1`.
5.  **Result**: The movie disappears for users instantly, but the **Admin Dashboard** still sees it in the "All Movies" filter and "Revenue" reports.

---

## Part 4: Troubleshooting Guide (Common Errors)

| Error | Cause | Solution |
| :--- | :--- | :--- |
| **404 Not Found** | URL mapping is wrong or file is in the wrong folder. | Check `@WebServlet` path and ensure JSPs are in `WEB-INF/pages`. |
| **500 Internal Error** | Java code crashed (NullPointerException, etc.). | Check the Tomcat Console for the stack trace. |
| **SQL Exception** | Database name is wrong or MySQL is not running. | Check `DBConnection.java` and ensure XAMPP/MySQL is ON. |
| **JSTL Not Found** | Jar files are missing from `WEB-INF/lib`. | Ensure `jakarta.servlet.jsp.jstl.jar` is in the classpath. |

---

*This document is intended for study and reference. Good luck with your final submission!*

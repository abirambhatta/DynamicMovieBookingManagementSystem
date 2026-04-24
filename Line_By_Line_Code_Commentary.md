# Literal Line-by-Line Code Commentary

This document provides a literal, line-by-line explanation of the most critical files in the project. This is designed for absolute clarity during a code review or viva.

---

## 1. `DBConnection.java` (The Database Bridge)

| Line | Code | Explanation |
| :--- | :--- | :--- |
| 1 | `package com.moviebooking.config;` | Defines the folder structure. Classes in this package are for configuration. |
| 3-5 | `import java.sql...;` | Brings in standard Java libraries for SQL connections and error handling. |
| 11 | `public class DBConnection {` | Defines the class. `public` means it can be accessed from any other package. |
| 13 | `private static final String URL = "...";` | `private`: hidden from other classes. `static`: belongs to the class, not an object. `final`: cannot be changed. This is the MySQL address. |
| 15 | `private static final String USER = "root";` | The default username for MySQL in XAMPP. |
| 17 | `private static final String PASSWORD = "";` | The default password (empty) for MySQL in XAMPP. |
| 21 | `static {` | A static block. It runs **only once** as soon as the class is loaded by Java. |
| 23 | `Class.forName("com.mysql.cj.jdbc.Driver");` | Manually loads the MySQL Driver class. Without this, Java doesn't know how to talk to MySQL. |
| 35 | `public static Connection getConnection()...` | A method that returns a `Connection` object. `static` means you call it as `DBConnection.getConnection()`. |
| 36 | `return DriverManager.getConnection(...);` | The actual line that attempts to open the door to the database using the URL, User, and Pass. |

---

## 2. `MovieDao.java` (The Data Engine) - Core Logic

| Line | Code | Explanation |
| :--- | :--- | :--- |
| 14 | `public class MovieDao {` | The Data Access Object class for Movies. |
| 15 | `private static boolean schemaChecked = false;` | A flag to track if we've already checked the database structure this session. |
| 17 | `private void checkSchema() {` | A private helper method to ensure the DB tables match the code. |
| 18 | `if (schemaChecked) return;` | If we checked it once, don't do it again. Saves performance. |
| 19 | `try (Connection conn = ...)` | **Try-with-resources**: Automatically closes the connection when done, even if an error occurs. |
| 25 | `try { stmt.executeUpdate("ALTER TABLE..."); }` | Attempts to add the `is_active` column. If it already exists, the `catch` ignores the error. |
| 36 | `public boolean addMovie(Movie movie) {` | Method to save a movie. Returns `true` if successful. |
| 37 | `checkSchema();` | Calls the helper to make sure the database is ready. |
| 39 | `String query = "INSERT INTO movies ...";` | The raw SQL query. `?` are placeholders for security. |
| 42 | `PreparedStatement pstmt = ...` | Prepares the query. `RETURN_GENERATED_KEYS` tells MySQL to give us the new ID back. |
| 44 | `pstmt.setString(1, movie.getTitle());` | Plugs the movie title into the first `?`. |
| 59 | `if (movie.getPriceStandard() != null) ...` | Checks if a custom price was set. If not, it tells SQL to store `NULL`. |
| 63 | `pstmt.setBoolean(19, movie.isActive());` | Sets the `is_active` status (defaults to 1/true). |
| 66 | `int result = pstmt.executeUpdate();` | **The actual execution**. `result` is the number of rows changed (should be 1). |
| 68 | `ResultSet rs = pstmt.getGeneratedKeys();` | Asks MySQL for the ID of the movie it just created. |
| 71 | `movie.setMovieId(rs.getInt(1));` | Updates our Java object with the ID from the database. |

---

## 3. `AuthFilter.java` (The Security Guard)

| Line | Code | Explanation |
| :--- | :--- | :--- |
| 19 | `@WebFilter("/*")` | Tells the server to run this code for **every single URL** in the app. |
| 20 | `public class AuthFilter implements Filter {` | Implements the standard Java Web Filter interface. |
| 32 | `public void doFilter(...)` | The main method that runs when a user requests a page. |
| 34 | `HttpServletRequest httpRequest = ...` | Converts the basic request to a web-specific request to see sessions/URLs. |
| 37 | `String path = httpRequest.getRequestURI()...` | Gets the actual URL the user typed (e.g., `/manageMovies`). |
| 40 | `HttpSession session = httpRequest.getSession(false);` | Looks for a current login session. `false` means "don't create a new one." |
| 42 | `User user = (user) session.getAttribute("user");` | Tries to find the "user" object we stored during login. |
| 45 | `boolean isAdminPage = path.contains("/manage") ...` | Logic to check if the user is trying to reach an Admin-only area. |
| 48 | `if (isAdminPage && (user == null || !user.isAdmin()))` | **The Security Check**: If it's an admin page AND the user isn't an admin... |
| 50 | `httpResponse.sendRedirect("login");` | **Kick them out!** Send them to the login page. |
| 53 | `chain.doFilter(request, response);` | **Let them pass.** Proceed to the requested page. |

---

## 4. `TmdbService.java` (The Integration Logic)

| Line | Code | Explanation |
| :--- | :--- | :--- |
| 74 | `public String fetchTrailerUrl(int tmdbId) {` | Method to get a video link from TMDB. |
| 75 | `String url = "https://api.themoviedb.org/3/movie/" + tmdbId + "/videos...";` | Builds the API request URL with your API Key. |
| 76 | `String json = fetchJson(url);` | Calls our helper method to download the text from the API. |
| 77 | `Pattern p = Pattern.compile("\"key\":\"(.*?)\"");` | **Regex**: Searches for the pattern `"key":"VIDEO_ID"`. |
| 80 | `if (m.find()) return "https://www.youtube.com/embed/" + m.group(1);` | If a match is found, build the YouTube embed link. |
| 141 | `public String searchYoutube(String query) {` | **Fallback Logic**: If TMDB fails, search YouTube directly. |
| 143 | `String searchUrl = "https://www.youtube.com/results?search_query=" + ...;` | Encodes the movie name into a YouTube search URL. |
| 149 | `Pattern p = Pattern.compile("v=([a-zA-Z0-9_-]{11})");` | **Scraping Logic**: Looks for the 11-character video ID in YouTube's HTML. |

---

## 5. `BookTicketServlet.java` (The Core Business Logic)

| Line | Code | Explanation |
| :--- | :--- | :--- |
| 1 | `package com.moviebooking.controllers;` | Controller package. Handles the flow of the booking process. |
| 42 | `protected void doGet(...)` | Runs when the user clicks "Book Now". It sets up the seat selection page. |
| 45 | `int movieId = Integer.parseInt(...)` | Gets the Movie ID from the URL. All data for seats depends on this ID. |
| 46 | `Movie movie = movieDao.getMovieById(movieId);` | Fetches full movie details (prices, title, poster) from the database. |
| 48 | `List<ShowTime> showTimes = ...` | Gets all available times/halls for this specific movie. |
| 52 | `request.setAttribute("movie", movie);` | Sends the movie data to the JSP so it can be displayed. |
| 56 | `request.getRequestDispatcher(...).forward(...);` | **The Handover**: Tells the server to show the `bookTicket.jsp` page to the user. |
| 62 | `protected void doPost(...)` | Runs when the user clicks "Confirm Booking". It saves the data. |
| 65 | `int userId = ((User) session.getAttribute("user")).getUserId();` | Gets the ID of the person currently logged in. |
| 71 | `String seatNumbers = request.getParameter("seats");` | Receives the string of selected seats (e.g., "A1, A2"). |
| 73 | `double totalAmount = Double.parseDouble(...);` | Receives the final price calculated by JavaScript. |
| 75 | `Booking booking = new Booking(...);` | Creates a new Java object to hold all the booking details. |
| 77 | `boolean success = bookingDao.addBooking(booking);` | Calls the DAO to write the record into the `bookings` table. |
| 80 | `response.sendRedirect("ticketConfirmation?id=" + ...);` | If successful, send the user to the "Thank You" page. |

---

## 6. `BookingDao.java` (Reporting and Stats)

| Line | Code | Explanation |
| :--- | :--- | :--- |
| 35 | `public boolean addBooking(Booking booking) {` | Saves a new ticket to the database. |
| 37 | `String query = "INSERT INTO bookings ...";` | The query that stores who booked what, which movie, and how much they paid. |
| 60 | `public List<Booking> getBookingsByUser(int userId) {` | Fetches history for the "My Bookings" page. |
| 61 | `String query = "SELECT b.*, m.title FROM bookings b JOIN movies m ...";` | **The JOIN**: Links the `bookings` table with the `movies` table so we can show the movie **Name** instead of just its **ID**. |
| 682 | `String query = "SELECT m.title, COALESCE(COUNT(b.booking_id), 0) ...";` | **The Revenue Query**: Used for the Admin Dashboard. |
| 683 | `FROM movies m LEFT JOIN bookings b ...` | **LEFT JOIN**: Ensures that even movies with 0 bookings show up in the list with a count of 0. |
| 682 | `COALESCE(..., 0)` | A SQL function that says "If there are no bookings (NULL), show the number 0 instead." |

---

## 7. `bookTicket.jsp` (The Interactive Seat Map)

| Area | Logic / Code | Explanation |
| :--- | :--- | :--- |
| **Grid Generation** | `<c:forEach var="row" items="${rows}">` | We use a nested loop to create a grid (A, B, C... rows and 1, 2, 3... columns). |
| **Seat Identity** | `data-seat-id="${row}${col}"` | Every seat "knows" its name (e.g., A1). This is sent to the backend when booked. |
| **JS Toggle** | `this.classList.toggle('selected')` | When clicked, JavaScript changes the color of the seat by adding/removing a CSS class. |
| **Price Logic** | `total += parseFloat(seat.dataset.price)` | JS looks at the `data-price` attribute of every "selected" seat and sums them up. |
| **Form Submit** | `document.getElementById('seatsInput').value = ...` | Before the form is sent, JS converts the list of seats into a string like "A1, A2" and puts it into a hidden input field. |

---

## 8. `manageMovies.jsp` (The Admin Control Center)

| Area | Logic / Code | Explanation |
| :--- | :--- | :--- |
| **TMDB Auto-Fill** | `fetch(CONTEXT_PATH + '/tmdbSearch?query=' + ...)` | When the admin types a name, JS sends an AJAX request to our Servlet to get movie data. |
| **YouTube Search** | `fetch(CONTEXT_PATH + '/tmdbSearch?action=searchYoutube&query=' + ...)` | If TMDB has no trailer, this script triggers our YouTube "scraper" logic. |
| **Soft Delete Action**| `action=delete&id=${movie.movieId}` | When the "Delete" button is clicked, it sends a command to the Servlet to set `is_active = 0`. |
| **Restore Action** | `action=restore&id=${movie.movieId}` | The "Restore" button sends a command to set `is_active = 1`. |
| **Pagination** | `data-paginate="true"` | A custom attribute that triggers `pagination.js` to split the movie list into pages. |

---

## Summary of Methodologies
*   **Singleton/Static Access**: Used in `DBConnection` and `TmdbService` to avoid creating multiple unnecessary objects.
*   **Try-with-resources**: Used in all DAOs to prevent "Memory Leaks" (unclosed connections).
*   **Regex Parsing**: Used in `TmdbService` to extract data from JSON/HTML without using a 3rd-party library (keeping the app "Pure Java").
*   **Soft Deletes**: Used in `MovieDao` to ensure the "Relational Integrity" of the database (so bookings don't lose their movie).

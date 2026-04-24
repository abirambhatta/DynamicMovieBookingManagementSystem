# The Absolute Beginner's Line-by-Line Project Guide

This document is for someone who has **never coded before**. We will explain every keyword, every bracket, and every semicolon in your project.

---

## Part 1: The "Code Language" Dictionary

Before we read the files, you must know what these common words mean:

*   **`package`**: Think of this as a folder. It tells Java where this file is located.
*   **`import`**: This is like "bringing a tool from another toolbox." If we want to talk to a database, we `import` the SQL tools.
*   **`public`**: Means anyone can use this. Like a public park.
*   **`private`**: Means only this file can see it. Like your private bedroom.
*   **`class`**: The name of the blueprint. `class Movie` is the blueprint for all movies.
*   **`static`**: Means this belongs to the blueprint itself, not to a specific copy. 
*   **`void`**: Means "This action doesn't give me any result back, it just does the work."
*   **`String`**: A piece of text (e.g., "Spider-Man").
*   **`int`**: A whole number (e.g., 120).
*   **`boolean`**: A True or False choice.
*   **`try { ... } catch { ... }`**: "Try to do this work. If it crashes (Error), don't break the whole app, just jump to the `catch` part and tell me what happened."
*   **`;` (Semicolon)**: The "period" at the end of a sentence in code.

---

## Part 2: `DBConnection.java` - Line-by-Line

This file is the "Phone Line" that connects your Java app to your MySQL Database.

| Line # | Code | What it literally means | Syntax Logic |
| :--- | :--- | :--- | :--- |
| 1 | `package com.moviebooking.config;` | This file lives in the `config` folder. | `package` is the keyword; `;` ends the line. |
| 3 | `import java.sql.Connection;` | Bring in the tool called `Connection`. | `import` brings external logic. |
| 11 | `public class DBConnection {` | Start the blueprint for database connections. | `{` starts the body of the class. |
| 13 | `private static final String URL = "...";` | Create a secret (`private`), permanent (`final`) piece of text (`String`) called `URL`. | `=` assigns the value. |
| 21 | `static {` | Start a block of code that runs immediately. | `static` blocks run before anything else. |
| 23 | `Class.forName("com.mysql.cj.jdbc.Driver");` | Search for the "MySQL Driver" file and load it. | `""` contains text. |
| 35 | `public static Connection getConnection() ...` | A public action that gives back a `Connection`. | `()` means this is a method (action). |
| 36 | `return DriverManager.getConnection(...);` | Actually open the connection and send it back. | `return` gives the result to whoever asked. |

---

## Part 3: `Movie.java` - The Data Blueprint

This file defines what a "Movie" actually is in your system.

| Line # | Code | What it literally means | Why it's used |
| :--- | :--- | :--- | :--- |
| 14 | `private int movieId;` | Every movie has a secret ID number. | To uniquely identify movies. |
| 15 | `private String title;` | Every movie has a title text. | To show the name of the movie. |
| 47 | `private boolean isActive;` | Is this movie active (1) or hidden (0)? | For the "Soft Delete" feature. |
| 50 | `public Movie() {}` | An "Empty Constructor." | Allows us to create a movie object first and fill details later. |
| 66 | `public String getTitle() { return title; }` | A "Getter." | Because `title` is `private`, we need this public method to see it. |
| 70 | `public void setTitle(String title) { this.title = title; }` | A "Setter." | `this.title` refers to the variable above; `title` refers to the new value. |

---

## Part 4: `MovieDao.java` - The SQL Engine

This is where the actual "Work" happens. It talks to MySQL.

| Line # | Code | Logic | Syntax Detail |
| :--- | :--- | :--- | :--- |
| 36 | `public boolean addMovie(Movie movie) {` | Start the action "Add a Movie". | Takes a `Movie` object as input. |
| 39 | `String query = "INSERT INTO movies ...";` | Create the SQL command. | `?` are placeholders to prevent hackers. |
| 42 | `PreparedStatement pstmt = ...` | Prepare the command for the database. | `conn.prepareStatement` creates the tool. |
| 44 | `pstmt.setString(1, movie.getTitle());` | Put the Title into the 1st `?`. | `1` refers to the first `?` in the query. |
| 63 | `pstmt.setBoolean(19, movie.isActive());` | Put the Active status into the 19th `?`. | This is where the Soft Delete status is saved. |
| 66 | `int result = pstmt.executeUpdate();` | **Run the command!** | `executeUpdate` is used for Insert/Update/Delete. |
| 68 | `ResultSet rs = pstmt.getGeneratedKeys();` | Get the new ID number from MySQL. | `ResultSet` is like a mini-table of results. |

---

## Part 5: JSP Syntax (The View)

In files like `manageMovies.jsp`, you see a mix of HTML and special tags:

*   **`${movie.title}`**: This is **Expression Language (EL)**. It tells the server "Go find the movie object and grab its title."
*   **`<c:if test="...">`**: A **Conditional**. "If the test is true, show the HTML inside."
*   **`<c:forEach ...>`**: A **Loop**. "For every item in this list, repeat the code below."

### **Example Breakdown from `manageMovies.jsp`**
```jsp
<tr style="${!movie.active ? 'opacity: 0.7;' : ''}">
```
1.  **`${...}`**: Start logic.
2.  **`!movie.active`**: Is the movie NOT active?
3.  **`?`**: If YES...
4.  **`'opacity: 0.7;'`**: ...then add this CSS style.
5.  **`:`**: If NO...
6.  **`''`**: ...then do nothing.

---

## Part 6: Why is the project built like this? (The Logic)

1.  **Why use separate folders (packages)?**
    *   Imagine a library with 1,000 books in one pile. You'd never find anything. Packages are the "Science," "History," and "Fiction" sections.
2.  **Why use DAOs?**
    *   If you decide to stop using MySQL and start using an Excel sheet for data, you only change the DAO files. The rest of the app stays the same!
3.  **Why use Servlets?**
    *   Servlets are the "Traffic Cops." They take the request from the browser, decide which DAO to talk to, and then tell the JSP which page to show.
4.  **Why use JavaScript for Seat Selection?**
    *   Because clicking a seat shouldn't make the whole page reload! JavaScript lets the user interact "instantly" without waiting for the server.

---

*This guide will be updated as we go. Focus on the Part 1 Dictionary first!*

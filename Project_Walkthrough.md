# Walkthrough - Soft Delete Implementation

We have transitioned the movie management system from a "Hard Delete" (permanent removal) to a "Soft Delete" system. This ensures that historical data (bookings, revenue, statistics) remains intact even if a movie is removed from public view.

## Changes Made

### 1. Database & Model
- Added an `isActive` boolean field to the `Movie` model.
- Updated `MovieDao.checkSchema()` to automatically add the `is_active` column to the `movies` table if it doesn't exist.

### 2. Data Access Layer (`MovieDao.java`)
- **Soft Delete**: `deleteMovie(int id)` now executes `UPDATE movies SET is_active = 0` instead of a `DELETE` query.
- **Restore**: Added `restoreMovie(int id)` to reactivate hidden movies.
- **Filtering**:
    - `getAllActiveMovies()`, `getRecentMovies()`, and `searchMovies()` now explicitly filter for `is_active = 1`.
    - `getMoviesByFilter()` (used by Admin) allows viewing both active and hidden movies.
- **Dashboard Stats**: `getTotalMovies()`, `getNowShowingMovies()`, etc., now count only active movies for more accurate "Current" reporting.

### 3. Controller Layer
- **ManageMoviesServlet**: Added handling for the `restore` action and ensured that updating a movie preserves its current active/hidden status.
- **BrowseMoviesServlet**: Updated to use `getAllActiveMovies()` so users don't see hidden titles.

### 4. Admin UI (`manageMovies.jsp`)
- **Status Badges**: Each movie now shows an "Active" (Green) or "Hidden" (Red) badge.
- **Visual Feedback**: Hidden movies appear slightly dimmed (opacity) in the catalog.
- **Restoration Controls**:
    - Active movies show a "Hide" button (visibility_off icon).
    - Hidden movies show a "Restore" button (restore icon).
- **Filter**: Added a "Hidden (Soft Deleted)" option to the status filter dropdown.

## Verification Results

### Soft Delete Test
1. Admin clicks "Hide" on a movie.
2. Movie remains in the table but is marked as "Hidden".
3. The movie is no longer visible on the User Home or Browse pages.
4. Historical bookings for this movie still show up in the Admin Dashboard and User Booking History.

### Restore Test
1. Admin filters by "Hidden" or finds the dimmed row.
2. Admin clicks "Restore".
3. Movie becomes "Active" and reappears on user-facing pages.

### Data Integrity
- No `Foreign Key` constraint errors occur because rows are never deleted.
- Revenue reports accurately include income from movies that have since been hidden.

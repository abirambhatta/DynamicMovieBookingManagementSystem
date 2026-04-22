# Movie Status Filtering Explanation

## How Movie Status Works

The system uses **start_date** and **end_date** columns in the movies table to determine movie status.

### Status Types:

#### 1. Now Showing (Currently Playing)
- **Condition**: `CURDATE() BETWEEN start_date AND end_date`
- **Meaning**: Today's date is between the movie's start and end dates
- **Example**: 
  - Movie: Inception
  - Start Date: 2025-01-01
  - End Date: 2025-01-31
  - Today: 2025-01-15
  - **Status: NOW SHOWING** ✓

#### 2. Upcoming (Coming Soon)
- **Condition**: `start_date > CURDATE()`
- **Meaning**: The movie's start date is in the future
- **Example**:
  - Movie: Avatar 3
  - Start Date: 2025-02-15
  - End Date: 2025-03-15
  - Today: 2025-01-15
  - **Status: UPCOMING** ✓

#### 3. Ended (No Longer Playing)
- **Condition**: `end_date < CURDATE()`
- **Meaning**: The movie's end date has passed
- **Example**:
  - Movie: Titanic
  - Start Date: 2024-11-01
  - End Date: 2024-12-31
  - Today: 2025-01-15
  - **Status: ENDED** ✓

## Visual Timeline:

```
Past                    Today                    Future
|------------------------|------------------------|
        ENDED         NOW SHOWING            UPCOMING
                         ↓
                    (Current Date)

Example:
|----Titanic----|----Inception----|----Avatar 3----|
  Nov-Dec 2024    Jan 2025          Feb-Mar 2025
     ENDED       NOW SHOWING         UPCOMING
```

## Database Query Examples:

### Get Now Showing Movies:
```sql
SELECT * FROM movies 
WHERE CURDATE() BETWEEN start_date AND end_date;
```

### Get Upcoming Movies:
```sql
SELECT * FROM movies 
WHERE start_date > CURDATE();
```

### Get Ended Movies:
```sql
SELECT * FROM movies 
WHERE end_date < CURDATE();
```

## How to Use in Admin Panel:

1. **Add a Movie**: Set start_date and end_date when adding
2. **Filter Movies**: Use the Status dropdown to filter by:
   - All Movies (no filter)
   - Now Showing (currently playing)
   - Upcoming (coming soon)
   - Ended (finished)

## Important Notes:

- The system automatically determines status based on dates
- No manual status field needed
- Status updates automatically as dates change
- Users can only book tickets for "Now Showing" movies
- Admin can see all movies regardless of status

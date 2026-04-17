package com.moviebooking.model;

import java.sql.Date;
import java.sql.Time;

/**
 * This class stores show time details for a movie.
 * Each show time has a date, time, and hall.
 * A movie can have many show times.
 */
public class ShowTime {
    // Unique ID for the show time (from database)
    private int showTimeId;
    // ID of the movie this show time belongs to
    private int movieId;
    // Date of the show (e.g. 2026-04-15)
    private Date showDate;
    // Time of the show (e.g. 14:30)
    private Time showTime;
    // Hall name where the show will be played
    private String hall;
    // Movie title (for display purposes, not stored in database)
    private String movieTitle;

    // Empty constructor - used to create object and set values later
    public ShowTime() {}

    // Constructor with main fields to create a show time quickly
    public ShowTime(int movieId, Date showDate, Time showTime) {
        this.movieId = movieId;
        this.showDate = showDate;
        this.showTime = showTime;
    }

    // Getters and Setters - used to get and set each field value

    public int getShowTimeId() { return showTimeId; }
    public void setShowTimeId(int showTimeId) { this.showTimeId = showTimeId; }

    public int getMovieId() { return movieId; }
    public void setMovieId(int movieId) { this.movieId = movieId; }

    public Date getShowDate() { return showDate; }
    public void setShowDate(Date showDate) { this.showDate = showDate; }

    public Time getShowTime() { return showTime; }
    public void setShowTime(Time showTime) { this.showTime = showTime; }

    public String getHall() { return hall; }
    public void setHall(String hall) { this.hall = hall; }

    public String getMovieTitle() { return movieTitle; }
    public void setMovieTitle(String movieTitle) { this.movieTitle = movieTitle; }
}

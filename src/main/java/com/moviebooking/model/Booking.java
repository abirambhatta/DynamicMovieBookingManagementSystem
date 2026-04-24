package com.moviebooking.model;

import java.sql.Timestamp;

/**
 * This class stores booking details like movie, seats, price.
 * Each booking is made by a user for a movie.
 * Used to pass booking data between servlet and database.
 */
public class Booking {
    // Unique ID for the booking (from database)
    private int bookingId;
    // ID of the user who made the booking
    private int userId;
    // ID of the movie that was booked
    private int movieId;
    // Show time for the booking (date and time as string)
    private String showTime;
    // Number of seats booked
    private int numberOfSeats;
    // Type of seat like Standard, Premium, Recliner, VIP
    private String seatType;
    // Total price for all the seats
    private double totalPrice;
    // Booking status: Confirmed or Cancelled
    private String status;
    // Date and time when booking was made
    private Timestamp bookingDate;
    // Title of the booked movie (used for display on pages)
    private String movieTitle;
    // Name of the user who booked (used for admin display)
    private String userName;
    // URL/path to the movie poster image
    private String moviePoster;

    // Empty constructor - needed to create booking object and set values later
    public Booking() {}

    // Constructor with all main fields to create a booking quickly
    public Booking(int userId, int movieId, String showTime, int numberOfSeats, String seatType, double totalPrice, String status) {
        this.userId = userId;
        this.movieId = movieId;
        this.showTime = showTime;
        this.numberOfSeats = numberOfSeats;
        this.seatType = seatType;
        this.totalPrice = totalPrice;
        this.status = status;
    }

    // Getters and Setters - used to get and set each field value

    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getMovieId() { return movieId; }
    public void setMovieId(int movieId) { this.movieId = movieId; }

    public String getShowTime() { return showTime; }
    public void setShowTime(String showTime) { this.showTime = showTime; }

    public int getNumberOfSeats() { return numberOfSeats; }
    public void setNumberOfSeats(int numberOfSeats) { this.numberOfSeats = numberOfSeats; }

    public String getSeatType() { return seatType; }
    public void setSeatType(String seatType) { this.seatType = seatType; }

    public double getTotalPrice() { return totalPrice; }
    public void setTotalPrice(double totalPrice) { this.totalPrice = totalPrice; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getBookingDate() { return bookingDate; }
    public void setBookingDate(Timestamp bookingDate) { this.bookingDate = bookingDate; }

    public String getMovieTitle() { return movieTitle; }
    public void setMovieTitle(String movieTitle) { this.movieTitle = movieTitle; }

    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }

    public String getMoviePoster() { return moviePoster; }
    public void setMoviePoster(String moviePoster) { this.moviePoster = moviePoster; }
}

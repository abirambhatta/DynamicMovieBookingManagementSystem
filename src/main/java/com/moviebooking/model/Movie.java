package com.moviebooking.model;

import java.sql.Date;

/**
 * This class stores movie details like title, genre, director.
 * Used to pass movie data between servlet and database.
 * Shown on browse movies page, movie details page, etc.
 */
public class Movie {
    // Unique ID for the movie (from database)
    private int movieId;
    // Movie title (e.g. "Avengers")
    private String title;
    // Movie genre like Action, Drama, Comedy
    private String genre;
    // Name of the movie director
    private String director;
    // Movie length in minutes
    private int duration;
    // Movie language like English, Hindi, Nepali
    private String language;
    // Date when the movie was released
    private Date releaseDate;
    // Start date when movie starts showing in theater
    private Date startDate;
    // End date when movie stops showing in theater
    private Date endDate;
    // Short description about the movie
    private String description;
    // File name of the movie poster image
    private String posterImage;
    // Movie rating out of 10
    private double rating;
    // Movie format like 2D, 3D, IMAX
    private String format;
    // Age rating like G, PG, R
    private String ageRating;

    // Empty constructor - used to create movie object and set values later
    public Movie() {}

    // Constructor with all fields including start and end date
    // Used when adding a new movie with show dates
    public Movie(String title, String genre, String director, int duration, String language, 
                 Date releaseDate, Date startDate, Date endDate, String description, String posterImage, double rating, String format, String ageRating) {
        this.title = title;
        this.genre = genre;
        this.director = director;
        this.duration = duration;
        this.language = language;
        this.releaseDate = releaseDate;
        this.startDate = startDate;
        this.endDate = endDate;
        this.description = description;
        this.posterImage = posterImage;
        this.rating = rating;
        this.format = format;
        this.ageRating = ageRating;
    }

    // Constructor without start and end date
    // Used when updating a movie (dates may not change)
    public Movie(String title, String genre, String director, int duration, String language, 
                 Date releaseDate, String description, String posterImage, double rating, String format, String ageRating) {
        this.title = title;
        this.genre = genre;
        this.director = director;
        this.duration = duration;
        this.language = language;
        this.releaseDate = releaseDate;
        this.description = description;
        this.posterImage = posterImage;
        this.rating = rating;
        this.format = format;
        this.ageRating = ageRating;
    }

    // Getters and Setters - used to get and set each field value

    public int getMovieId() { return movieId; }
    public void setMovieId(int movieId) { this.movieId = movieId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getGenre() { return genre; }
    public void setGenre(String genre) { this.genre = genre; }

    public String getDirector() { return director; }
    public void setDirector(String director) { this.director = director; }

    public int getDuration() { return duration; }
    public void setDuration(int duration) { this.duration = duration; }

    public String getLanguage() { return language; }
    public void setLanguage(String language) { this.language = language; }

    public Date getReleaseDate() { return releaseDate; }
    public void setReleaseDate(Date releaseDate) { this.releaseDate = releaseDate; }

    public Date getStartDate() { return startDate; }
    public void setStartDate(Date startDate) { this.startDate = startDate; }

    public Date getEndDate() { return endDate; }
    public void setEndDate(Date endDate) { this.endDate = endDate; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getPosterImage() { return posterImage; }
    public void setPosterImage(String posterImage) { this.posterImage = posterImage; }

    public double getRating() { return rating; }
    public void setRating(double rating) { this.rating = rating; }

    public String getFormat() { return format; }
    public void setFormat(String format) { this.format = format; }

    public String getAgeRating() { return ageRating; }
    public void setAgeRating(String ageRating) { this.ageRating = ageRating; }
}

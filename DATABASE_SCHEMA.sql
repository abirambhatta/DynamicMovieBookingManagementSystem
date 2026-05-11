-- ==============================================================================
-- Movie Booking Management System - Database Schema
-- ==============================================================================

CREATE DATABASE IF NOT EXISTS movie_booking_db;
USE movie_booking_db;

-- Table: Users
-- Stores profile and authentication data for customers and administrators
CREATE TABLE IF NOT EXISTS users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) DEFAULT 'user',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reset_otp VARCHAR(6) NULL,
    otp_expiry TIMESTAMP NULL
);

-- Table: Movies
-- Contains movie metadata, visual assets, and dynamic pricing configurations
CREATE TABLE IF NOT EXISTS movies (
    movie_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    genre VARCHAR(100),
    director VARCHAR(100),
    duration INT NOT NULL,
    language VARCHAR(50),
    release_date DATE,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    description TEXT,
    poster_image VARCHAR(255),
    format VARCHAR(20) DEFAULT '2D',
    age_rating VARCHAR(10) DEFAULT 'PG',
    trailer_url VARCHAR(255),
    cast_list TEXT,
    price_standard DOUBLE NULL,
    price_premium DOUBLE NULL,
    price_recliner DOUBLE NULL,
    price_vip DOUBLE NULL,
    is_active BOOLEAN DEFAULT TRUE
);

-- Table: Show Times
-- Links movies to specific dates, times, and auditorium locations
CREATE TABLE IF NOT EXISTS show_times (
    show_id INT AUTO_INCREMENT PRIMARY KEY,
    movie_id INT NOT NULL,
    show_date DATE NOT NULL,
    show_time TIME NOT NULL,
    hall VARCHAR(50) DEFAULT 'Audi 01',
    FOREIGN KEY (movie_id) REFERENCES movies(movie_id) ON DELETE CASCADE
);

-- Table: Bookings
-- Record of seat reservations and transactional details
CREATE TABLE IF NOT EXISTS bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    movie_id INT NOT NULL,
    show_time VARCHAR(100) NOT NULL,
    number_of_seats INT NOT NULL,
    seat_type TEXT NOT NULL,
    total_price DOUBLE NOT NULL,
    status VARCHAR(50) DEFAULT 'Confirmed',
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE RESTRICT,
    FOREIGN KEY (movie_id) REFERENCES movies(movie_id) ON DELETE RESTRICT
);

-- Table: Hall Configuration
-- Defines seat mapping, row tiers, and visual layout for each auditorium
CREATE TABLE IF NOT EXISTS hall_config (
    hall_name VARCHAR(100) PRIMARY KEY,
    seats_per_row INT NOT NULL DEFAULT 12,
    standard_rows VARCHAR(100) DEFAULT 'A,B,C,D',
    premium_rows VARCHAR(100) DEFAULT 'E',
    recliner_rows VARCHAR(100) DEFAULT '',
    vip_rows VARCHAR(100) DEFAULT 'F',
    layout_map TEXT
);

-- Table: System Settings
-- Configuration parameters for the application logic
CREATE TABLE IF NOT EXISTS system_settings (
    setting_key VARCHAR(100) PRIMARY KEY,
    setting_value TEXT
);

-- ==============================================================================
-- Initial Data Population
-- ==============================================================================

-- Create system administrator account
INSERT IGNORE INTO users (full_name, email, phone, password, role) 
VALUES ('Super Admin', 'admin@moviemint.com', '0000000000', '4UvNsuX7aCADBV415I53InOaeOJreO0I5Gx9rmHNWiI2F1Ckux5Ut++oQPOYqFQM', 'admin');

-- Set default global pricing and availability
INSERT IGNORE INTO system_settings (setting_key, setting_value) VALUES 
('PRICE_STANDARD', '200.0'),
('PRICE_PREMIUM', '350.0'),
('PRICE_RECLINER', '500.0'),
('PRICE_VIP', '750.0'),
('AVAILABLE_HALLS', 'Audi 01,Audi 02,Audi 03');

-- Initialize default hall configurations
INSERT IGNORE INTO hall_config (hall_name, seats_per_row, standard_rows, premium_rows, recliner_rows, vip_rows, layout_map) VALUES 
('Audi 01', 12, 'A,B,C,D', 'E', '', 'F', 'S S S S S S S S S S S S|S S S S S S S S S S S S|S S S S S S S S S S S S|S S S S S S S S S S S S|P P P P P P P P P P P P|V V V V V V V V V V V V'),
('Audi 02', 12, 'A,B,C,D', 'E', '', 'F', 'S S S S S S S S S S S S|S S S S S S S S S S S S|S S S S S S S S S S S S|S S S S S S S S S S S S|P P P P P P P P P P P P|V V V V V V V V V V V V'),
('Audi 03', 12, 'A,B,C,D', 'E', '', 'F', 'S S S S S S S S S S S S|S S S S S S S S S S S S|S S S S S S S S S S S S|S S S S S S S S S S S S|P P P P P P P P P P P P|V V V V V V V V V V V V');

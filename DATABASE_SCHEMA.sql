-- ==============================================================================
-- 🎬 Movie Booking Management System - Master Database Schema
-- Use this file to recreate the entire database structure from scratch.
-- ==============================================================================

-- Create the database
CREATE DATABASE IF NOT EXISTS movie_booking_db;
USE movie_booking_db;

-- --------------------------------------------------------
-- 1. USERS TABLE
-- Handles both normal users and administrators
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL, -- Stored as Hashed Password
    role VARCHAR(20) DEFAULT 'user', -- 'user' or 'admin'
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reset_otp VARCHAR(6) NULL, -- For password reset feature
    otp_expiry TIMESTAMP NULL -- Expiration time for the OTP
);

-- --------------------------------------------------------
-- 2. MOVIES TABLE
-- Master catalog for all movies, including soft deletes and custom pricing
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS movies (
    movie_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    genre VARCHAR(100),
    director VARCHAR(100),
    duration INT NOT NULL, -- In minutes
    language VARCHAR(50),
    release_date DATE,
    start_date DATE NOT NULL, -- When it starts showing in cinema
    end_date DATE NOT NULL,   -- When it stops showing in cinema
    description TEXT,
    poster_image VARCHAR(255),
    format VARCHAR(20) DEFAULT '2D', -- 2D, 3D, IMAX, etc.
    age_rating VARCHAR(10) DEFAULT 'PG',
    trailer_url VARCHAR(255), -- YouTube embed link
    cast_list TEXT,
    price_standard DOUBLE NULL, -- Custom price overrides
    price_premium DOUBLE NULL,
    price_recliner DOUBLE NULL,
    price_vip DOUBLE NULL,
    is_active BOOLEAN DEFAULT TRUE -- For Soft Deletes (0 = hidden, 1 = active)
);

-- --------------------------------------------------------
-- 3. SHOW TIMES TABLE
-- The schedule linking movies to specific dates, times, and halls
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS show_times (
    show_id INT AUTO_INCREMENT PRIMARY KEY,
    movie_id INT NOT NULL,
    show_date DATE NOT NULL,
    show_time TIME NOT NULL,
    hall VARCHAR(50) DEFAULT 'Audi 01',
    FOREIGN KEY (movie_id) REFERENCES movies(movie_id) ON DELETE CASCADE
);

-- --------------------------------------------------------
-- 4. BOOKINGS TABLE
-- The transactional record of all ticket sales
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    movie_id INT NOT NULL,
    show_time VARCHAR(100) NOT NULL, -- e.g., "2026-04-25 14:30 - Audi 01"
    number_of_seats INT NOT NULL,
    seat_type TEXT NOT NULL, -- e.g., "A1, A2, B4"
    total_price DOUBLE NOT NULL,
    status VARCHAR(50) DEFAULT 'Confirmed', -- 'Confirmed' or 'Cancelled'
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE RESTRICT,
    FOREIGN KEY (movie_id) REFERENCES movies(movie_id) ON DELETE RESTRICT
);

-- --------------------------------------------------------
-- 5. HALL CONFIGURATION TABLE
-- Defines the physical layout and tier mapping for each cinema hall
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS hall_config (
    hall_name VARCHAR(100) PRIMARY KEY,
    seats_per_row INT NOT NULL DEFAULT 12,
    standard_rows VARCHAR(100) DEFAULT 'A,B,C,D',
    premium_rows VARCHAR(100) DEFAULT 'E',
    recliner_rows VARCHAR(100) DEFAULT '',
    vip_rows VARCHAR(100) DEFAULT 'F',
    layout_map TEXT -- e.g., "S S S | P P P | V V V" defining the visual grid
);

-- --------------------------------------------------------
-- 6. SYSTEM SETTINGS TABLE
-- Global variables for the application
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS system_settings (
    setting_key VARCHAR(100) PRIMARY KEY,
    setting_value TEXT
);

-- ==============================================================================
-- DEFAULT DATA SEEDING (Run this to initialize a fresh system)
-- ==============================================================================

-- 1. Create Default Admin Account (Password: admin123)
-- Note: Replace with actual hashed password in production
INSERT IGNORE INTO users (full_name, email, phone, password, role) 
VALUES ('Super Admin', 'admin@moviebooking.com', '0000000000', 'admin123', 'admin');

-- 2. Seed Default Global Settings
INSERT IGNORE INTO system_settings (setting_key, setting_value) VALUES 
('PRICE_STANDARD', '200.0'),
('PRICE_PREMIUM', '350.0'),
('PRICE_RECLINER', '500.0'),
('PRICE_VIP', '750.0'),
('AVAILABLE_HALLS', 'Audi 01,Audi 02,Audi 03');

-- 3. Seed Default Hall Configurations
INSERT IGNORE INTO hall_config (hall_name, seats_per_row, standard_rows, premium_rows, recliner_rows, vip_rows, layout_map) VALUES 
('Audi 01', 12, 'A,B,C,D', 'E', '', 'F', 'S S S S S S S S S S S S|S S S S S S S S S S S S|S S S S S S S S S S S S|S S S S S S S S S S S S|P P P P P P P P P P P P|V V V V V V V V V V V V'),
('Audi 02', 12, 'A,B,C,D', 'E', '', 'F', 'S S S S S S S S S S S S|S S S S S S S S S S S S|S S S S S S S S S S S S|S S S S S S S S S S S S|P P P P P P P P P P P P|V V V V V V V V V V V V'),
('Audi 03', 12, 'A,B,C,D', 'E', '', 'F', 'S S S S S S S S S S S S|S S S S S S S S S S S S|S S S S S S S S S S S S|S S S S S S S S S S S S|P P P P P P P P P P P P|V V V V V V V V V V V V');

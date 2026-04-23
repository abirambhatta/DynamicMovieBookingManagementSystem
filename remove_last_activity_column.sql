-- Remove last_activity column since we're not using session tracking
-- Run this SQL in your MySQL database

ALTER TABLE users DROP COLUMN last_activity;

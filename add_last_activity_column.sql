-- Add last_activity column to track user sessions
-- Run this SQL in your MySQL database

ALTER TABLE users ADD COLUMN last_activity TIMESTAMP NULL DEFAULT NULL AFTER created_at;

-- Update existing users to have NULL last_activity (they are offline)
UPDATE users SET last_activity = NULL;

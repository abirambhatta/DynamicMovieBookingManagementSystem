-- Add OTP columns to users table for 2FA password reset
ALTER TABLE users ADD COLUMN reset_otp VARCHAR(6) NULL;
ALTER TABLE users ADD COLUMN otp_expiry DATETIME NULL;

-- Create index for faster OTP lookups
CREATE INDEX idx_reset_otp ON users(reset_otp);

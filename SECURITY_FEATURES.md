# MovieMint - Security Features

## Implemented Features

### 1. Two-Factor Authentication (2FA) with OTP for Password Reset

**How it works:**
1. User enters email on forgot password page
2. System generates 6-digit OTP and sends via email
3. User enters OTP (valid for 10 minutes)
4. After verification, user can set new password
5. OTP is cleared after successful password reset

**Files:**
- `ForgotPasswordServlet.java` - 3-step OTP verification flow
- `forgotPassword.jsp` - Multi-step UI with OTP input and countdown timer
- `OtpUtil.java` - OTP generation and expiry validation
- `UserDao.java` - OTP storage and verification methods

**Database:**
- `reset_otp` VARCHAR(6) - Stores the OTP
- `otp_expiry` DATETIME - Stores OTP expiry time

### 2. Email Notifications via Google SMTP

**Features:**
- Sends OTP email during password reset (10-minute expiry)
- Sends booking confirmation email with ticket details
- HTML formatted emails with MovieMint branding

**Configuration:**
- SMTP Server: smtp.gmail.com:587
- TLS Enabled: Yes
- Configured in `EmailService.java`

**Files:**
- `EmailService.java` - Handles OTP and ticket emails
- `BookTicketServlet.java` - Sends ticket email after successful booking
- `ForgotPasswordServlet.java` - Sends OTP email during password reset

### 3. Password Encryption with PBKDF2

**Security Details:**
- Algorithm: PBKDF2 with SHA-256
- Iterations: 10,000 for security
- Salt: 16-byte random salt per password
- Constant-time comparison to prevent timing attacks

**How it works:**
- Passwords are hashed during registration
- Passwords are hashed during password reset
- Login verifies password using secure comparison
- Passwords are never stored in plain text

**Files:**
- `PasswordUtil.java` - PBKDF2-based password hashing
- `UserService.java` - Uses PasswordUtil for registration and login
- `ForgotPasswordServlet.java` - Hashes new password during reset
- `UserDao.java` - Stores and retrieves hashed passwords

## Security Benefits

✅ **Password Protection**
- All passwords encrypted with 10,000 iterations
- Unique salt per password
- Resistant to rainbow table attacks
- Resistant to brute force attacks

✅ **2FA Protection**
- OTP expires after 10 minutes
- One-time use only
- Prevents unauthorized password resets

✅ **Email Verification**
- Confirms user identity via email
- Sends booking confirmations
- Audit trail of password resets

## Usage

### Password Reset with OTP:
1. Go to `/forgotPassword`
2. Enter registered email
3. Check email for 6-digit OTP
4. Enter OTP within 10 minutes
5. Set new password
6. Login with new password

### Booking Confirmation:
1. Login as user
2. Browse and book a movie
3. Receive confirmation email with ticket details
4. Email includes booking ID, movie, showtime, seats, and price

## Technical Notes

- OTP stored in database with expiry timestamp
- Email sending is synchronous (blocks until sent)
- Session tokens used for authentication
- All passwords hashed before database storage
- Login compares hashed passwords securely

## Dependencies

- `javax.mail-1.6.2.jar` - JavaMail API for email sending
- `jakarta.activation-1.2.2.jar` - Jakarta Activation for email attachments
- Both JARs located in `WEB-INF/lib/`

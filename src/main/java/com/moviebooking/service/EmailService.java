package com.moviebooking.service;

import javax.mail.*;
import javax.mail.internet.*;
import javax.activation.*;
import javax.mail.util.ByteArrayDataSource;
import java.util.Properties;
import com.moviebooking.util.HtmlToPdfConverter;
import com.moviebooking.util.EnvLoader;

/**
 * Service class for sending emails via Google SMTP.
 * Handles OTP emails for password reset and booking confirmation emails with PDF ticket attachment.
 * Uses Gmail SMTP server with TLS encryption.
 */
public class EmailService {
    private static final String SENDER_EMAIL = EnvLoader.get("SENDER_EMAIL");
    private static final String APP_PASSWORD = EnvLoader.get("EMAIL_APP_PASSWORD");

    /**
     * Send OTP email for password reset.
     * Email contains a 6-digit OTP valid for 10 minutes.
     * @param recipientEmail the email address to send OTP to
     * @param otp the 6-digit OTP to include in email
     * @return true if email sent successfully, false otherwise
     */
    public static boolean sendOtpEmail(String recipientEmail, String otp) {
        try {
            System.out.println("Attempting to send OTP email to: " + recipientEmail);
            
            Properties props = new Properties();
            props.put("mail.smtp.host", "smtp.gmail.com");
            props.put("mail.smtp.port", "587");
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.starttls.required", "true");
            props.put("mail.smtp.ssl.protocols", "TLSv1.2");
            props.put("mail.smtp.connectiontimeout", "10000");
            props.put("mail.smtp.timeout", "10000");
            props.put("mail.smtp.writetimeout", "10000");

            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(SENDER_EMAIL, APP_PASSWORD);
                }
            });

            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SENDER_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject("MovieMint - Password Reset OTP");

            String htmlContent = "<html><body style=\"font-family: Arial, sans-serif;\">" +
                    "<div style=\"max-width: 600px; margin: 0 auto; padding: 20px;\">" +
                    "<h2 style=\"color: #dc143c;\">Password Reset Request</h2>" +
                    "<p>You requested to reset your MovieMint password. Use the OTP below to proceed:</p>" +
                    "<div style=\"background-color: #f8f9fa; padding: 20px; border-radius: 8px; text-align: center; margin: 20px 0;\">" +
                    "<h1 style=\"color: #dc143c; letter-spacing: 5px;\">" + otp + "</h1>" +
                    "</div>" +
                    "<p style=\"color: #6c757d;\">This OTP is valid for 10 minutes only.</p>" +
                    "<p style=\"color: #6c757d;\">If you didn't request this, please ignore this email.</p>" +
                    "<hr style=\"border: none; border-top: 1px solid #e9ecef;\">" +
                    "<p style=\"color: #6c757d; font-size: 12px;\">MovieMint - Your Cinema Booking Platform</p>" +
                    "</div></body></html>";

            message.setContent(htmlContent, "text/html; charset=utf-8");
            
            Transport.send(message);
            System.out.println("✓ OTP email sent successfully to: " + recipientEmail);
            return true;
            
        } catch (Exception e) {
            System.err.println("✗ Failed to send OTP email: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Send booking confirmation email with PDF ticket attachment.
     * Converts the ticket HTML (same design as ticketConfirmation.jsp) to PDF and attaches it.
     * @param recipientEmail the email address to send ticket to
     * @param recipientName the name of the person who booked
     * @param movieTitle the title of the movie booked
     * @param showTime the show time of the movie
     * @param hall the hall/auditorium name
     * @param seats the seat numbers booked
     * @param numberOfSeats number of seats booked
     * @param totalPrice total price paid for the booking
     * @param bookingId the booking ID for reference
     * @return true if email sent successfully, false otherwise
     */
    public static boolean sendTicketEmail(String recipientEmail, String recipientName, String movieTitle, 
                                          String showTime, String hall, String seats, int numberOfSeats, 
                                          double totalPrice, String bookingId) {
        try {
            System.out.println("Attempting to send ticket email to: " + recipientEmail);
            
            Properties props = new Properties();
            props.put("mail.smtp.host", "smtp.gmail.com");
            props.put("mail.smtp.port", "587");
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.starttls.required", "true");
            props.put("mail.smtp.ssl.protocols", "TLSv1.2");
            props.put("mail.smtp.connectiontimeout", "10000");
            props.put("mail.smtp.timeout", "10000");
            props.put("mail.smtp.writetimeout", "10000");

            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(SENDER_EMAIL, APP_PASSWORD);
                }
            });

            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SENDER_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            
            String orderRef = "MBK-" + String.format("%05d", Integer.parseInt(bookingId));
            message.setSubject("MovieMint - Your Booking Confirmation " + orderRef);
            
            // Create multipart message for text + PDF attachment
            Multipart multipart = new MimeMultipart();

            // Part 1: HTML email body
            MimeBodyPart htmlPart = new MimeBodyPart();
            String htmlContent = "<html><body style=\"font-family: Arial, sans-serif;\">" +
                    "<div style=\"max-width: 600px; margin: 0 auto; padding: 20px;\">" +
                    "<h2 style=\"color: #dc143c;\">🎬 Booking Confirmed!</h2>" +
                    "<p>Hi " + recipientName + ",</p>" +
                    "<p>Your movie ticket has been successfully booked. Here are your booking details:</p>" +
                    "<div style=\"background-color: #f8f9fa; padding: 20px; border-radius: 8px; margin: 20px 0;\">" +
                    "<p><strong>Order Reference:</strong> " + orderRef + "</p>" +
                    "<p><strong>Movie:</strong> " + movieTitle + "</p>" +
                    "<p><strong>Show Time:</strong> " + showTime + "</p>" +
                    "<p><strong>Hall:</strong> " + hall + "</p>" +
                    "<p><strong>Seats:</strong> " + seats + "</p>" +
                    "<p><strong>Number of Seats:</strong> " + numberOfSeats + "</p>" +
                    "<p><strong>Total Price:</strong> Rs. " + totalPrice + "</p>" +
                    "</div>" +
                    "<p style=\"color: #6c757d;\">📎 Your ticket is attached as a PDF file.</p>" +
                    "<p style=\"color: #6c757d;\">⏰ Please arrive 15 minutes before the show time.</p>" +
                    "<p style=\"color: #6c757d;\">📱 Show this ticket at the cinema entrance.</p>" +
                    "<hr style=\"border: none; border-top: 1px solid #e9ecef;\">" +
                    "<p style=\"color: #6c757d; font-size: 12px;\">MovieMint - Your Cinema Booking Platform</p>" +
                    "</div></body></html>";
            htmlPart.setContent(htmlContent, "text/html; charset=utf-8");
            multipart.addBodyPart(htmlPart);

            // Part 2: PDF ticket attachment (converted from ticket JSP HTML)
            try {
                byte[] pdfTicket = HtmlToPdfConverter.generateTicketPdf(orderRef, movieTitle, showTime, 
                                                                        hall, seats, recipientName, 
                                                                        numberOfSeats, totalPrice, bookingId);
                if (pdfTicket != null) {
                    MimeBodyPart pdfPart = new MimeBodyPart();
                    DataSource source = new ByteArrayDataSource(pdfTicket, "application/pdf");
                    pdfPart.setDataHandler(new DataHandler(source));
                    pdfPart.setFileName("MovieMint_Ticket_" + orderRef + ".pdf");
                    multipart.addBodyPart(pdfPart);
                    System.out.println("✓ PDF ticket generated from HTML and attached");
                } else {
                    System.err.println("⚠ Failed to generate PDF ticket");
                }
            } catch (Exception e) {
                System.err.println("⚠ Error generating PDF: " + e.getMessage());
                e.printStackTrace();
            }

            message.setContent(multipart);
            
            Transport.send(message);
            System.out.println("✓ Ticket email sent successfully to: " + recipientEmail);
            return true;
            
        } catch (Exception e) {
            System.err.println("✗ Failed to send ticket email: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}

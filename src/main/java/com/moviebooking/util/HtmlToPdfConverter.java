package com.moviebooking.util;

import com.itextpdf.text.Document;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.pdf.PdfWriter;
import com.itextpdf.tool.xml.XMLWorkerHelper;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.nio.charset.StandardCharsets;

/**
 * Utility class to convert HTML ticket to PDF.
 * Uses the existing ticket HTML design and converts it to PDF format.
 */
public class HtmlToPdfConverter {

    /**
     * Convert ticket HTML to PDF.
     * @param orderRef booking reference number
     * @param movieTitle movie name
     * @param showTime show date and time
     * @param hall hall/auditorium name
     * @param seats seat numbers
     * @param userName customer name
     * @param numberOfSeats number of seats
     * @param totalPrice ticket price
     * @param bookingId booking ID
     * @return byte array of PDF document
     */
    public static byte[] generateTicketPdf(String orderRef, String movieTitle, String showTime, 
                                          String hall, String seats, String userName, 
                                          int numberOfSeats, double totalPrice, String bookingId) {
        try {
            // Generate HTML content using the same design as ticket JSP
            String htmlContent = generateTicketHtml(orderRef, movieTitle, showTime, hall, 
                                                   seats, userName, numberOfSeats, totalPrice, bookingId);

            // Convert HTML to PDF
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            Document document = new Document(PageSize.A4);
            PdfWriter writer = PdfWriter.getInstance(document, baos);
            document.open();

            // Parse HTML and write to PDF
            XMLWorkerHelper.getInstance().parseXHtml(writer, document,
                new ByteArrayInputStream(htmlContent.getBytes(StandardCharsets.UTF_8)));

            document.close();
            return baos.toByteArray();

        } catch (Exception e) {
            System.err.println("Error generating PDF: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    /**
     * Generate HTML content for the ticket using the same design as ticketConfirmation.jsp
     */
    private static String generateTicketHtml(String orderRef, String movieTitle, String showTime, 
                                            String hall, String seats, String userName, 
                                            int numberOfSeats, double totalPrice, String bookingId) {
        return "<!DOCTYPE html>" +
            "<html>" +
            "<head>" +
            "<meta charset='UTF-8'/>" +
            "<style>" +
            "body { font-family: Arial, sans-serif; margin: 0; padding: 20px; background: #fff; }" +
            ".ticket-card { max-width: 600px; margin: 0 auto; border: 2px solid #dc143c; border-radius: 15px; overflow: hidden; }" +
            ".ticket-header { background: linear-gradient(135deg, #dc143c, #9b0c0c); padding: 30px; color: white; text-align: center; }" +
            ".checkmark { font-size: 48px; margin-bottom: 10px; }" +
            ".ticket-header h1 { font-size: 24px; margin: 10px 0; }" +
            ".ticket-header p { font-size: 14px; margin: 5px 0; }" +
            ".ticket-body { padding: 30px; }" +
            ".movie-title { text-align: center; font-size: 22px; font-weight: bold; color: #141d23; margin-bottom: 20px; }" +
            ".badge { display: inline-block; padding: 5px 15px; background: #e8f4f8; color: #2980b9; border-radius: 20px; font-size: 11px; font-weight: bold; margin: 5px; }" +
            ".info-grid { margin: 20px 0; }" +
            ".info-item { padding: 12px; margin: 8px 0; background: #f9fbfd; border: 1px solid #e8edf2; border-radius: 8px; }" +
            ".info-label { font-size: 10px; font-weight: bold; text-transform: uppercase; color: #5c3f3f; margin-bottom: 5px; }" +
            ".info-value { font-size: 14px; font-weight: bold; color: #141d23; }" +
            ".info-value.price { font-size: 18px; color: #dc143c; }" +
            ".qr-section { text-align: center; margin: 20px 0; padding: 20px; border-top: 2px dashed #e0e0e0; }" +
            ".qr-label { font-size: 11px; font-weight: bold; text-transform: uppercase; color: #5c3f3f; margin-bottom: 10px; }" +
            ".ticket-footer { background: #f9fbfd; padding: 15px; text-align: center; border-top: 1px solid #e8edf2; }" +
            ".ticket-footer p { font-size: 11px; color: #5d5f5f; margin: 5px 0; }" +
            "</style>" +
            "</head>" +
            "<body>" +
            "<div class='ticket-card'>" +
            "<div class='ticket-header'>" +
            "<div class='checkmark'>✓</div>" +
            "<h1>Booking Confirmed!</h1>" +
            "<p>Your tickets are ready. Show this at the cinema entrance.</p>" +
            "</div>" +
            "<div class='ticket-body'>" +
            "<div class='movie-title'>" + movieTitle + "</div>" +
            "<div style='text-align: center;'>" +
            "<span class='badge'>Order " + orderRef + "</span>" +
            "</div>" +
            "<div class='info-grid'>" +
            "<div class='info-item'>" +
            "<div class='info-label'>Show Time</div>" +
            "<div class='info-value'>" + showTime + "</div>" +
            "</div>" +
            "<div class='info-item'>" +
            "<div class='info-label'>Hall</div>" +
            "<div class='info-value'>" + hall + "</div>" +
            "</div>" +
            "<div class='info-item'>" +
            "<div class='info-label'>Seats</div>" +
            "<div class='info-value'>" + seats + "</div>" +
            "</div>" +
            "<div class='info-item'>" +
            "<div class='info-label'>Number of Seats</div>" +
            "<div class='info-value'>" + numberOfSeats + "</div>" +
            "</div>" +
            "<div class='info-item'>" +
            "<div class='info-label'>Customer</div>" +
            "<div class='info-value'>" + userName + "</div>" +
            "</div>" +
            "<div class='info-item'>" +
            "<div class='info-label'>Total Amount Paid</div>" +
            "<div class='info-value price'>Rs. " + String.format("%.2f", totalPrice) + "</div>" +
            "</div>" +
            "</div>" +
            "<div class='qr-section'>" +
            "<div class='qr-label'>Scan at Entrance</div>" +
            "<img src='https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=MOVIEMINT-" + orderRef + "-" + showTime + "' width='150' height='150' alt='QR Code'/>" +
            "</div>" +
            "</div>" +
            "<div class='ticket-footer'>" +
            "<p>Please carry a photo ID along with this ticket.</p>" +
            "<p>Doors open 30 minutes before showtime. No late entry.</p>" +
            "<p>MovieMint - Your Cinema Booking Platform</p>" +
            "</div>" +
            "</div>" +
            "</body>" +
            "</html>";
    }
}

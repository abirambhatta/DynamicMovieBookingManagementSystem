# iText PDF Library Setup (HTML to PDF)

## Required JAR Files

Download and add these JAR files to convert your ticket JSP HTML to PDF:

### 1. iText PDF Core
- Download: https://repo1.maven.org/maven2/com/itextpdf/itextpdf/5.5.13.3/itextpdf-5.5.13.3.jar
- File: `itextpdf-5.5.13.3.jar`

### 2. iText XMLWorker (for HTML to PDF conversion)
- Download: https://repo1.maven.org/maven2/com/itextpdf/tool/xmlworker/5.5.13.3/xmlworker-5.5.13.3.jar
- File: `xmlworker-5.5.13.3.jar`

## Installation Steps

1. Download both JAR files from the links above
2. Copy them to: `src/main/webapp/WEB-INF/lib/`
3. Right-click project → Properties → Java Build Path → Libraries
4. Click "Add JARs" → Select both JAR files
5. Click Apply and Close
6. Clean and rebuild project
7. Restart Tomcat server

## What You Get

Your existing ticket JSP design will be converted to PDF and sent via email!

✅ **PDF Ticket Attachment** with:
- Same design as your ticketConfirmation.jsp
- MovieMint branding with red gradient header
- Checkmark confirmation icon
- Movie title and order reference
- All booking details in styled boxes
- QR code for scanning at entrance
- Footer with instructions
- Professional A4 format ready to print

## How It Works

1. User books a ticket
2. System takes your ticket JSP HTML design
3. Converts it to PDF using iText XMLWorker
4. Attaches PDF to confirmation email
5. User receives `MovieMint_Ticket_MBK-00011.pdf`

## Benefits

✅ Uses your existing ticket design (no need to recreate)
✅ Consistent look between web and PDF
✅ Easy to update (just modify the JSP)
✅ Professional PDF output
✅ Includes QR code automatically

## Test It

1. Add both JAR files
2. Restart Tomcat
3. Book a movie ticket
4. Check your email for PDF attachment
5. Open PDF - it will look like your ticket JSP!

## Troubleshooting

**Compilation errors?**
- Make sure both JARs are in `WEB-INF/lib`
- Clean project: Project → Clean
- Restart Eclipse
- Restart Tomcat

**PDF not generating?**
- Check console logs for errors
- Verify both JARs are added to build path
- Make sure all booking details are passed correctly

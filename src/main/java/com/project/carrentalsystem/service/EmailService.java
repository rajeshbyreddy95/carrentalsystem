package com.project.carrentalsystem.service;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import java.util.HashMap;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class EmailService {
    private final JavaMailSender mailSender;
    
    @Value("${app.mail.from:rajeshbyreddy95@gmail.com}")
    private String fromEmail;
    
    @Value("${app.mail.from-name:DriveHub Car Rental}")
    private String fromName;
    
    // In-memory storage for development (stores OTP for console display)
    private static final Map<String, String> otpLog = new HashMap<>();

    public void sendOtp(String toEmail, String otp) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
            
            try {
                helper.setFrom(fromEmail, fromName);
            } catch (java.io.UnsupportedEncodingException e) {
                helper.setFrom(fromEmail);
            }
            
            helper.setTo(toEmail);
            helper.setSubject("Your OTP Verification Code - DriveHub");
            
            // Create beautiful HTML email template
            String htmlContent = buildOtpEmailTemplate(otp, toEmail);
            helper.setText(htmlContent, true);
            
            mailSender.send(message);
            otpLog.put(toEmail, otp);
            
            System.out.println("✅ Email sent successfully to: " + toEmail);
        } catch (MessagingException e) {
            // For development: log OTP to console when email fails
            System.out.println("\n═══════════════════════════════════════════════════════════════");
            System.out.println("📧 EMAIL SERVICE - DEVELOPMENT MODE (Failed to send)");
            System.out.println("═══════════════════════════════════════════════════════════════");
            System.out.println("Email to: " + toEmail);
            System.out.println("Subject: Your OTP Verification Code - DriveHub");
            System.out.println("═══════════════════════════════════════════════════════════════");
            System.out.println("🔐 OTP CODE: " + otp);
            System.out.println("═══════════════════════════════════════════════════════════════");
            System.out.println("Reason: " + e.getMessage());
            System.out.println("═══════════════════════════════════════════════════════════════\n");
            
            otpLog.put(toEmail, otp);
        }
    }
    
    private String buildOtpEmailTemplate(String otp, String userEmail) {
        return "<!DOCTYPE html>\n" +
                "<html lang=\"en\">\n" +
                "<head>\n" +
                "    <meta charset=\"UTF-8\">\n" +
                "    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n" +
                "    <title>DriveHub - OTP Verification</title>\n" +
                "    <style>\n" +
                "        * { margin: 0; padding: 0; box-sizing: border-box; }\n" +
                "        body { font-family: 'Sora', 'Poppins', sans-serif; line-height: 1.6; color: #333; }\n" +
                "        .container { max-width: 600px; margin: 0 auto; background: #f8f9fa; }\n" +
                "        .header { background: linear-gradient(135deg, #2563eb 0%, #1e40af 100%); padding: 40px 20px; text-align: center; color: white; }\n" +
                "        .header h1 { font-size: 28px; margin-bottom: 10px; font-weight: 700; }\n" +
                "        .header p { font-size: 14px; opacity: 0.9; }\n" +
                "        .content { padding: 40px 30px; background: white; margin: 20px; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }\n" +
                "        .greeting { font-size: 18px; font-weight: 600; color: #1e293b; margin-bottom: 20px; }\n" +
                "        .description { font-size: 14px; color: #64748b; margin-bottom: 30px; line-height: 1.8; }\n" +
                "        .otp-box { background: linear-gradient(135deg, #e0e7ff 0%, #f3e8ff 100%); border: 2px solid #2563eb; border-radius: 12px; padding: 30px; text-align: center; margin: 30px 0; }\n" +
                "        .otp-label { font-size: 12px; color: #64748b; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 10px; }\n" +
                "        .otp-code { font-size: 48px; font-weight: 800; color: #2563eb; letter-spacing: 8px; font-family: 'Courier New', monospace; font-weight: 700; }\n" +
                "        .otp-validity { font-size: 12px; color: #ef4444; margin-top: 15px; }\n" +
                "        .security-info { background: #f0f9ff; border-left: 4px solid #2563eb; padding: 15px; margin: 25px 0; border-radius: 4px; }\n" +
                "        .security-info strong { color: #1e40af; }\n" +
                "        .security-info p { font-size: 13px; color: #475569; margin: 5px 0; }\n" +
                "        .footer { background: #f1f5f9; padding: 20px 30px; text-align: center; border-top: 1px solid #e2e8f0; margin-top: 30px; }\n" +
                "        .footer p { font-size: 12px; color: #64748b; margin: 5px 0; }\n" +
                "        .divider { height: 1px; background: #e2e8f0; margin: 20px 0; }\n" +
                "        .social-links { text-align: center; margin: 20px 0; }\n" +
                "        .social-links a { display: inline-block; width: 40px; height: 40px; background: #2563eb; color: white; border-radius: 50%; text-decoration: none; line-height: 40px; margin: 0 5px; font-size: 16px; }\n" +
                "        .social-links a:hover { background: #1e40af; }\n" +
                "        .button { display: inline-block; background: linear-gradient(135deg, #2563eb 0%, #1e40af 100%); color: white; padding: 12px 30px; border-radius: 8px; text-decoration: none; font-weight: 600; margin: 20px 0; }\n" +
                "        .button:hover { opacity: 0.9; }\n" +
                "        .warning { background: #fef2f2; border: 1px solid #fecaca; color: #991b1b; padding: 12px; border-radius: 6px; font-size: 13px; margin-top: 20px; }\n" +
                "    </style>\n" +
                "</head>\n" +
                "<body>\n" +
                "    <div class=\"container\">\n" +
                "        <!-- Header -->\n" +
                "        <div class=\"header\">\n" +
                "            <h1>🚗 DriveHub</h1>\n" +
                "            <p>Car Rental System</p>\n" +
                "        </div>\n" +
                "\n" +
                "        <!-- Main Content -->\n" +
                "        <div class=\"content\">\n" +
                "            <p class=\"greeting\">Hello! 👋</p>\n" +
                "            \n" +
                "            <p class=\"description\">\n" +
                "                Thank you for registering with DriveHub! We're excited to help you find the perfect car for your needs.\n" +
                "            </p>\n" +
                "            \n" +
                "            <p class=\"description\">\n" +
                "                To complete your account verification, please use the following One-Time Password (OTP):\n" +
                "            </p>\n" +
                "            \n" +
                "            <!-- OTP Box -->\n" +
                "            <div class=\"otp-box\">\n" +
                "                <div class=\"otp-label\">Your Verification Code</div>\n" +
                "                <div class=\"otp-code\">" + otp + "</div>\n" +
                "                <div class=\"otp-validity\">⏱️ Valid for 5 minutes only</div>\n" +
                "            </div>\n" +
                "            \n" +
                "            <!-- Security Info -->\n" +
                "            <div class=\"security-info\">\n" +
                "                <strong>🔒 Security Notice:</strong>\n" +
                "                <p>✓ Never share this OTP with anyone</p>\n" +
                "                <p>✓ DriveHub staff will never ask for your OTP</p>\n" +
                "                <p>✓ This code expires in 5 minutes</p>\n" +
                "            </div>\n" +
                "            \n" +
                "            <p class=\"description\">\n" +
                "                If you didn't request this OTP, please ignore this email and your account will not be created.\n" +
                "            </p>\n" +
                "            \n" +
                "            <!-- Warning -->\n" +
                "            <div class=\"warning\">\n" +
                "                ⚠️ If you continue to have trouble accessing your account, please contact our support team at support@drivehub.com\n" +
                "            </div>\n" +
                "        </div>\n" +
                "        \n" +
                "        <!-- Footer -->\n" +
                "        <div class=\"footer\">\n" +
                "            <div class=\"divider\"></div>\n" +
                "            <p><strong>DriveHub Car Rental System</strong></p>\n" +
                "            <p>📧 Email: support@drivehub.com</p>\n" +
                "            <p>📞 Phone: +91 9876-543-210</p>\n" +
                "            <p>🌐 Website: www.drivehub.com</p>\n" +
                "            <div class=\"social-links\">\n" +
                "                <a href=\"#\" title=\"Facebook\">f</a>\n" +
                "                <a href=\"#\" title=\"Twitter\">𝕏</a>\n" +
                "                <a href=\"#\" title=\"Instagram\">📷</a>\n" +
                "            </div>\n" +
                "            <p style=\"margin-top: 20px; font-size: 11px; color: #94a3b8;\">\n" +
                "                This is an automated message from DriveHub. Please do not reply to this email.\n" +
                "            </p>\n" +
                "        </div>\n" +
                "    </div>\n" +
                "</body>\n" +
                "</html>";
    }
    
    // For testing: retrieve logged OTP
    public static String getLoggedOtp(String email) {
        return otpLog.get(email);
    }
}
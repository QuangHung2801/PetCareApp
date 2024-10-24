package com.example.pet_app_service.service;

import com.example.pet_app_service.entity.PasswordResetToken;
import jakarta.mail.MessagingException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.example.pet_app_service.repository.PasswordResetTokenRepository;
import java.time.LocalDateTime;
import java.util.Optional;
import java.util.Random;

@Service
public class PasswordResetService {

    @Autowired
    private EmailService emailService;

    @Autowired
    private PasswordResetTokenRepository tokenRepository;

    public void sendResetEmail(String email) throws MessagingException {
        // Check if email is registered
        if (!isEmailRegistered(email)) {
            throw new IllegalArgumentException("Email not registered");
        }

        // Generate OTP
        String otp = generateOTP();

        // Save OTP to database with email and expiry time (1 hour)
        PasswordResetToken resetToken = new PasswordResetToken();
        resetToken.setToken(otp);
        resetToken.setEmail(email);
        resetToken.setExpiryDate(LocalDateTime.now().plusHours(1));
        tokenRepository.save(resetToken);

        // Send OTP via email
        String subject = "Password Reset OTP";
        String body = "Your OTP for password reset is: " + otp;
        emailService.sendSimpleEmail(email, subject, body);
    }

    private String generateOTP() {
        return String.format("%06d", new Random().nextInt(999999));
    }

    private boolean isEmailRegistered(String email) {
        // Implement logic to check if email exists in UserRepository
        return true; // Temporary stub, replace with actual check
    }
}

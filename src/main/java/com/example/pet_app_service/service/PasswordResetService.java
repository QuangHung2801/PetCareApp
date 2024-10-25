package com.example.pet_app_service.service;

import com.example.pet_app_service.entity.PasswordResetToken;
import com.example.pet_app_service.entity.User;
import com.example.pet_app_service.repository.PasswordResetTokenRepository;
import com.example.pet_app_service.repository.UserRepository;
import jakarta.mail.MessagingException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Optional;
import java.util.Random;

@Service
public class PasswordResetService {

    @Autowired
    private EmailService emailService;

    @Autowired
    private PasswordResetTokenRepository tokenRepository;

    @Autowired
    private UserRepository userRepository; // Khai báo UserRepository

    @Autowired
    private PasswordEncoder passwordEncoder; // Khai báo PasswordEncoder

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

    public boolean validatePasswordResetToken(String token) {
        Optional<PasswordResetToken> resetToken = tokenRepository.findByToken(token);
        return resetToken.isPresent() && resetToken.get().getExpiryDate().isAfter(LocalDateTime.now());
    }

    public void updatePassword(String token, String newPassword) {
        Optional<PasswordResetToken> resetToken = tokenRepository.findByToken(token);
        if (resetToken.isEmpty() || resetToken.get().getExpiryDate().isBefore(LocalDateTime.now())) {
            throw new IllegalArgumentException("Invalid or expired token");
        }

        // Get the email associated with the token
        String email = resetToken.get().getEmail();

        // Find the user by email
        Optional<User> userOptional = userRepository.findByEmail(email);
        if (userOptional.isEmpty()) {
            throw new IllegalArgumentException("User not found");
        }

        // Update the password
        User user = userOptional.get();
        user.setPassword(passwordEncoder.encode(newPassword));
        userRepository.save(user);

        // Remove the used token
        tokenRepository.delete(resetToken.get());
    }

    private String generateOTP() {
        return String.format("%06d", new Random().nextInt(999999));
    }

    private boolean isEmailRegistered(String email) {
        return userRepository.findByEmail(email).isPresent();
    }
}

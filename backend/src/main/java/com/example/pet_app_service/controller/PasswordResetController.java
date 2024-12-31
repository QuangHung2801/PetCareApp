package com.example.pet_app_service.controller;

import com.example.pet_app_service.service.PasswordResetService;
import jakarta.mail.MessagingException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/password-reset")
public class PasswordResetController {

    @Autowired
    private PasswordResetService passwordResetService;

    @PostMapping("/request")
    public ResponseEntity<String> requestPasswordReset(@RequestBody Map<String, String> request) {
        String email = request.get("email");
        try {
            passwordResetService.sendResetEmail(email);
            return ResponseEntity.ok("Password reset link sent to email: " + email);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        } catch (MessagingException e) {
            throw new RuntimeException(e);
        }
    }

    @PostMapping("/verify-token")
    public ResponseEntity<String> validateResetToken(@RequestBody Map<String, String> request) {
        String token = request.get("token");
        boolean isValid = passwordResetService.validatePasswordResetToken(token);
        if (isValid) {
            return ResponseEntity.ok("Token is valid.");
        } else {
            return ResponseEntity.badRequest().body("Invalid or expired token.");
        }
    }

    @PostMapping("/reset")
    public ResponseEntity<String> resetPassword(@RequestBody Map<String, String> request) {
        String token = request.get("token");
        String newPassword = request.get("newPassword");
        try {
            passwordResetService.updatePassword(token, newPassword);
            return ResponseEntity.ok("Password has been successfully reset.");
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
}

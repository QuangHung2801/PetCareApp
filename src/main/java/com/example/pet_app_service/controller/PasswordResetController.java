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
}

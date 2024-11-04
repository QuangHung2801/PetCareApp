package com.example.pet_app_service.controller;

import com.example.pet_app_service.entity.User;
import com.example.pet_app_service.service.UserDetailsServiceImpl;
import com.example.pet_app_service.service.UserService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.web.bind.annotation.*;
import jakarta.servlet.http.HttpSession;

import java.util.*;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    @Autowired
    private UserService userService;

    @Autowired
    private HttpSession session;

    @Autowired
    private UserDetailsServiceImpl userDetailsService;

    @PostMapping("/register")
    public ResponseEntity<User> register(@Valid @RequestBody User user) {
        try {
            User registeredUser = userService.register(user);
            return ResponseEntity.ok(registeredUser);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(null);
        }
    }

    @PostMapping("/login")
    public ResponseEntity<String> login(@Valid @RequestBody Map<String, String> loginData, HttpServletRequest request) {
        String phone = loginData.get("phone");
        String password = loginData.get("password");
        System.out.println("Authentication Info: " + SecurityContextHolder.getContext().getAuthentication());
        try {
            User user = userService.login(phone, password);
            UserDetails userDetails = userDetailsService.loadUserByUsername(phone);

            // Thiết lập thông tin chi tiết
            UsernamePasswordAuthenticationToken auth = new UsernamePasswordAuthenticationToken(
                    userDetails, null, userDetails.getAuthorities());
            auth.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
            SecurityContextHolder.getContext().setAuthentication(auth);
            System.out.println("Authentication Info: " + SecurityContextHolder.getContext().getAuthentication());
            return ResponseEntity.ok("Đăng nhập thành công");
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Thông tin đăng nhập không hợp lệ");
        }


    }

    @GetMapping("/check-auth")
    public ResponseEntity<String> checkAuth() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        System.out.println("Authentication Info: " + auth);
        if (auth != null && !(auth instanceof AnonymousAuthenticationToken)) {
            return ResponseEntity.ok("User is authenticated: " + auth.getName());
        }
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("User is not authenticated.");
    }


}

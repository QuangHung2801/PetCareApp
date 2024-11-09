package com.example.pet_app_service.controller;

import com.example.pet_app_service.entity.Role;
import com.example.pet_app_service.entity.User;
import com.example.pet_app_service.service.RoleService;
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
    private RoleService roleService;
    @Autowired
    private HttpSession session;

    @Autowired
    private UserDetailsServiceImpl userDetailsService;

    @PostMapping("/register")
    public ResponseEntity<User> register(@Valid @RequestBody User user) {
        try {
            // Gán vai trò user mặc định
            Set<Role> roles = new HashSet<>();
            Role userRole = roleService.findByName("USER");
            roles.add(userRole);
            user.setRoles(roles);

            User registeredUser = userService.register(user);
            return ResponseEntity.ok(registeredUser);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(null);
        }
    }

    @PostMapping("/login")
    public ResponseEntity<Map<String, Object>> login(@Valid @RequestBody Map<String, String> loginData, HttpServletRequest request) {
        String phone = loginData.get("phone");
        String password = loginData.get("password");
        try {
            User user=userService.login(phone, password);
            UsernamePasswordAuthenticationToken authentication = new UsernamePasswordAuthenticationToken(
                    user.getPhone(), user.getPassword(), Collections.singletonList(new SimpleGrantedAuthority("ROLE_USER")));
            SecurityContextHolder.getContext().setAuthentication(authentication);

            // Đặt chi tiết xác thực vào phiên
            request.getSession().setAttribute("SPRING_SECURITY_CONTEXT", SecurityContextHolder.getContext());
            Map<String, Object> response = new HashMap<>();
            response.put("message", "Đăng nhập thành công");
            response.put("userId", user.getId()); // Include userId in the response
            response.put("phone", user.getPhone());
//            response.put("name", user.getName());

            return ResponseEntity.ok(response);
        } catch (RuntimeException e) {
            System.out.println("Login failed: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Collections.singletonMap("message", "Thông tin đăng nhập không hợp lệ"));
        }


    }

    @GetMapping("/check-auth")
    public ResponseEntity<String> checkAuth() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && !(auth instanceof AnonymousAuthenticationToken)) {
            return ResponseEntity.ok("User is authenticated: " + auth.getName());
        }
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("User is not authenticated.");
    }

    @PostMapping("/logout")
    public ResponseEntity<String> logout(HttpServletRequest request) {
        // Invalidate session to clear authentication and logout user
        request.getSession().invalidate();
        SecurityContextHolder.clearContext(); // Clear authentication details

        return ResponseEntity.ok("Đăng xuất thành công");
    }


}

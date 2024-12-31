package com.example.pet_app_service.controller;

import com.example.pet_app_service.entity.Appointment;
import com.example.pet_app_service.entity.PartnerInfo;
import com.example.pet_app_service.entity.User;
import com.example.pet_app_service.repository.AppointmentRepository;
import com.example.pet_app_service.repository.PartnerInfoRepository;
import com.example.pet_app_service.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/admin/appointments")
public class AdminAppointmentController {
    @Autowired
    private AppointmentRepository appointmentRepository;

    @Autowired
    private UserService userService;

    @Autowired
    private PartnerInfoRepository partnerInfoRepository;

    // Kiểm tra xác thực người dùng
    private User getAuthenticatedUser() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || auth instanceof AnonymousAuthenticationToken) {
            return null;
        }
        String currentUserPhone = auth.getName();
        return userService.findByPhone(currentUserPhone);
    }

    @GetMapping("/pending")
    public ResponseEntity<?> getPendingAppointments() {
        User currentUser = getAuthenticatedUser();
        if (currentUser == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("User is not authenticated.");
        }

        List<Appointment> appointments;

        // Kiểm tra vai trò Admin
        boolean isAdmin = currentUser.getRoles().stream()
                .anyMatch(role -> role.getName().equalsIgnoreCase("ADMIN"));

        if (isAdmin) {
            // Admin: lấy toàn bộ lịch hẹn đang chờ xử lý
            appointments = appointmentRepository.findByStatus(Appointment.Status.PENDING);
        } else {
            // User: chỉ lấy lịch hẹn của chính người dùng
            appointments = appointmentRepository.findByStatusAndUser(Appointment.Status.PENDING, currentUser);
        }

        return ResponseEntity.ok(appointments);
    }

    @GetMapping("/confirmed")
    public ResponseEntity<?> getConfirmedAppointments() {
        User currentUser = getAuthenticatedUser();
        if (currentUser == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("User is not authenticated.");
        }

        List<Appointment> appointments;

        // Kiểm tra vai trò Admin
        boolean isAdmin = currentUser.getRoles().stream()
                .anyMatch(role -> role.getName().equalsIgnoreCase("ADMIN"));

        if (isAdmin) {
            // Admin: lấy toàn bộ lịch hẹn đã được xác nhận
            appointments = appointmentRepository.findByStatus(Appointment.Status.CONFIRMED);
        } else {
            // User: chỉ lấy lịch hẹn của chính người dùng
            appointments = appointmentRepository.findByStatusAndUser(Appointment.Status.CONFIRMED, currentUser);
        }

        return ResponseEntity.ok(appointments);
    }

    @GetMapping("/rejected")
    public ResponseEntity<?> getCancelledAppointments() {
        User currentUser = getAuthenticatedUser();
        if (currentUser == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("User is not authenticated.");
        }

        List<Appointment> appointments;

        // Kiểm tra vai trò Admin
        boolean isAdmin = currentUser.getRoles().stream()
                .anyMatch(role -> role.getName().equalsIgnoreCase("ADMIN"));

        if (isAdmin) {
            // Admin: lấy toàn bộ lịch hẹn đã bị từ chối
            appointments = appointmentRepository.findByStatus(Appointment.Status.REJECTED);
        } else {
            // User: chỉ lấy lịch hẹn của chính người dùng
            appointments = appointmentRepository.findByStatusAndUser(Appointment.Status.REJECTED, currentUser);
        }

        return ResponseEntity.ok(appointments);
    }
    @PutMapping("/confirm/{id}")
    public ResponseEntity<String> confirmAppointment(@PathVariable Long id) {
        User currentUser = getAuthenticatedUser();
        if (currentUser == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("User is not authenticated.");
        }

        Optional<Appointment> appointment = appointmentRepository.findById(id);
        if (appointment.isPresent()) {
            appointment.get().setStatus(Appointment.Status.CONFIRMED);
            appointmentRepository.save(appointment.get());
            return ResponseEntity.ok("Lịch hẹn đã được xác nhận.");
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Lịch hẹn không tồn tại.");
        }
    }

    @PutMapping("/reject/{id}")
    public ResponseEntity<String> rejectAppointment(@PathVariable Long id) {
        User currentUser = getAuthenticatedUser();
        if (currentUser == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("User is not authenticated.");
        }

        Optional<Appointment> appointment = appointmentRepository.findById(id);
        if (appointment.isPresent()) {
            appointment.get().setStatus(Appointment.Status.REJECTED);
            appointmentRepository.save(appointment.get());
            return ResponseEntity.ok("Lịch hẹn đã bị từ chối.");
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Lịch hẹn không tồn tại.");
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<String> updateAppointmentStatus(
            @PathVariable Long id, @RequestBody Map<String, String> payload) {
        User currentUser = getAuthenticatedUser();
        if (currentUser == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("User is not authenticated.");
        }

        Optional<Appointment> appointmentOptional = appointmentRepository.findById(id);
        if (appointmentOptional.isPresent()) {
            Appointment appointment = appointmentOptional.get();
            String status = payload.get("status");
            try {
                Appointment.Status updatedStatus = Appointment.Status.valueOf(status.toUpperCase());
                appointment.setStatus(updatedStatus);
                appointmentRepository.save(appointment);
                return ResponseEntity.ok("Appointment status updated successfully.");
            } catch (IllegalArgumentException e) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Invalid status provided.");
            }
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Appointment not found.");
        }
    }



}

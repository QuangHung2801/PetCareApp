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
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/partner/appointments")
public class PartnerAppointmentController {
    @Autowired
    private AppointmentRepository appointmentRepository;

    @Autowired
    private UserService userService;

    @Autowired
    private PartnerInfoRepository partnerInfoRepository;

    @GetMapping("/info/{userId}")
    public ResponseEntity<?> getPartnerInfoByUserId(@PathVariable Long userId) {
        Optional<PartnerInfo> partnerInfo = partnerInfoRepository.findByUserId(userId);
        if (partnerInfo.isPresent()) {
            return ResponseEntity.ok(partnerInfo.get());
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Partner not found");
        }
    }
    // Kiểm tra xác thực người dùng
    private User getAuthenticatedUser() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || auth instanceof AnonymousAuthenticationToken) {
            return null;
        }
        String currentUserPhone = auth.getName();
        return userService.findByPhone(currentUserPhone);
    }

    // Kiểm tra vai trò Partner
    private boolean isPartner(User user) {
        return user.getRoles().stream()
                .anyMatch(role -> role.getName().equalsIgnoreCase("PARTNER"));
    }

    @GetMapping("/pending")
    public ResponseEntity<?> getPendingAppointments(@RequestParam Long partnerId) {
        User currentUser = getAuthenticatedUser();
        if (currentUser == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("User is not authenticated.");
        }

        if (!isPartner(currentUser)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("Access Denied: Only partners can view pending appointments.");
        }

        List<Appointment> appointments = appointmentRepository.findByPartnerIdAndStatus(partnerId,Appointment.Status.PENDING);
        return ResponseEntity.ok(appointments);
    }

    @GetMapping("/confirmed")
    public ResponseEntity<?> getConfirmedAppointments(@RequestParam Long partnerId) {
        User currentUser = getAuthenticatedUser();
        if (currentUser == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("User is not authenticated.");
        }

        if (!isPartner(currentUser)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("Access Denied: Only partners can view confirmed appointments.");
        }

        List<Appointment> appointments = appointmentRepository.findByPartnerIdAndStatus(partnerId,Appointment.Status.CONFIRMED);
        return ResponseEntity.ok(appointments);
    }

    @GetMapping("/rejected")
    public ResponseEntity<?> getCancelledAppointments(@RequestParam Long partnerId) {
        User currentUser = getAuthenticatedUser();
        if (currentUser == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("User is not authenticated.");
        }

        if (!isPartner(currentUser)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("Access Denied: Only partners can view cancelled appointments.");
        }

        List<Appointment> appointments = appointmentRepository.findByPartnerIdAndStatus(partnerId,Appointment.Status.REJECTED);
        return ResponseEntity.ok(appointments);
    }

    @PutMapping("/confirm/{id}")
    public ResponseEntity<String> confirmAppointment(@PathVariable Long id) {
        User currentUser = getAuthenticatedUser();
        if (currentUser == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("User is not authenticated.");
        }

        if (!isPartner(currentUser)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("Access Denied: Only partners can confirm appointments.");
        }

        Optional<Appointment> appointment = appointmentRepository.findById(id);
        if (appointment.isPresent()) {
            appointment.get().setStatus(Appointment.Status.CONFIRMED);
            appointmentRepository.save(appointment.get());
            return ResponseEntity.ok("Appointment has been confirmed.");
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Appointment not found.");
        }
    }

    @PutMapping("/reject/{id}")
    public ResponseEntity<String> rejectAppointment(@PathVariable Long id) {
        User currentUser = getAuthenticatedUser();
        if (currentUser == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("User is not authenticated.");
        }

        if (!isPartner(currentUser)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("Access Denied: Only partners can reject appointments.");
        }

        Optional<Appointment> appointment = appointmentRepository.findById(id);
        if (appointment.isPresent()) {
            appointment.get().setStatus(Appointment.Status.REJECTED);
            appointmentRepository.save(appointment.get());
            return ResponseEntity.ok("Appointment has been rejected.");
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Appointment not found.");
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<String> updateAppointmentStatus(
            @PathVariable Long id, @RequestBody Map<String, String> payload) {
        User currentUser = getAuthenticatedUser();
        if (currentUser == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("User is not authenticated.");
        }

        if (!isPartner(currentUser)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("Access Denied: Only partners can update appointment status.");
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

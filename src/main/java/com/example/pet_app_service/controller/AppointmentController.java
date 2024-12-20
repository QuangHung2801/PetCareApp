package com.example.pet_app_service.controller;

import com.example.pet_app_service.entity.*;
import com.example.pet_app_service.service.*;
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
@RequestMapping("/api/appointments")
public class AppointmentController {

    @Autowired
    private ReviewService reviewService;
    @Autowired
    private PetProfileService petProfileService;
    @Autowired
    private UserService userService;
    @Autowired
    private PartnerInfoService partnerInfoService;
    @Autowired
    private AppointmentService appointmentService;

    @PostMapping("/book/{petId}/{partnerId}")
    public ResponseEntity<?> createAppointment(
            @RequestBody Appointment appointmentRequest,
            @PathVariable Long petId,
            @PathVariable Long partnerId) {

        // Xác thực người dùng hiện tại
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || auth instanceof AnonymousAuthenticationToken) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("User is not authenticated.");
        }

        String currentUserPhone = auth.getName();
        User currentUser = userService.findByPhone(currentUserPhone);
        if (currentUser == null) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("User not found.");
        }

        // Lấy thông tin PetProfile từ petId
        PetProfile petProfile = petProfileService.findPetProfileById(petId);
        if (petProfile == null) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Pet not found.");
        }

        // Lấy thông tin đối tác từ partnerId
        Optional<PartnerInfo> partnerInfo = partnerInfoService.findById(partnerId);
        if (!partnerInfo.isPresent()) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Partner not found.");
        }

        // Tạo lịch hẹn
        Appointment appointment = new Appointment();
        appointment.setPetProfile(petProfile);
        appointment.setUser(currentUser);
        partnerInfo.ifPresent(appointment::setPartner);
        appointment.setReason(appointmentRequest.getReason());
        appointment.setDate(appointmentRequest.getDate());
        appointment.setTime(appointmentRequest.getTime());
        appointment.setServiceType(appointmentRequest.getServiceType()); // Lấy từ request
        appointment.setStatus(Appointment.Status.PENDING);

        // Lưu lịch hẹn
        appointmentService.saveAppointment(appointment);

        return ResponseEntity.status(HttpStatus.CREATED).body(appointment);
    }

    @PostMapping("/review/{appointmentId}")
    public ResponseEntity<?> addReview(
            @PathVariable Long appointmentId,
            @RequestParam int rating,
            @RequestParam String comment,
            @RequestParam(required = false) Long userId) {

        // Authenticate user
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || auth.getName() == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("User is not authenticated.");
        }


        try {
            reviewService.addReview(appointmentId, rating, comment);
            return ResponseEntity.status(HttpStatus.CREATED).body("Review added successfully.");
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        }
    }

    @GetMapping("/completed")
    public ResponseEntity<?> getCompletedAppointments(@RequestParam String userId) {
        User currentUser = userService.findById(Long.parseLong(userId));
        if (currentUser == null) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("User not found.");
        }

        List<Appointment> completedAppointments = appointmentService.findAppointmentsByUserAndStatus(currentUser, Appointment.Status.COMPLETED);
        if (completedAppointments.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("No completed appointments found.");
        }

        return ResponseEntity.ok(completedAppointments);
    }

    @GetMapping("/pending")
    public ResponseEntity<?> getPendingAppointments(@RequestParam String userId) {
        User currentUser = userService.findById(Long.parseLong(userId));
        if (currentUser == null) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("User not found.");
        }

        List<Appointment> completedAppointments = appointmentService.findAppointmentsByUserAndStatus(currentUser, Appointment.Status.PENDING);
        if (completedAppointments.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("No completed appointments found.");
        }

        return ResponseEntity.ok(completedAppointments);
    }

    @GetMapping("/confirmed")
    public ResponseEntity<?> getConfirmedAppointments(@RequestParam String userId) {
        User currentUser = userService.findById(Long.parseLong(userId));
        if (currentUser == null) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("User not found.");
        }

        List<Appointment> completedAppointments = appointmentService.findAppointmentsByUserAndStatus(currentUser, Appointment.Status.CONFIRMED);
        if (completedAppointments.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("No completed appointments found.");
        }

        return ResponseEntity.ok(completedAppointments);
    }

    @GetMapping("/rejected")
    public ResponseEntity<?> getRejectedAppointments(@RequestParam String userId) {
        User currentUser = userService.findById(Long.parseLong(userId));
        if (currentUser == null) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("User not found.");
        }

        List<Appointment> completedAppointments = appointmentService.findAppointmentsByUserAndStatus(currentUser, Appointment.Status.REJECTED);
        if (completedAppointments.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("No completed appointments found.");
        }

        return ResponseEntity.ok(completedAppointments);
    }

}

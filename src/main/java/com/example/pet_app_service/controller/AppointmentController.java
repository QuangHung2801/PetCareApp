package com.example.pet_app_service.controller;

import com.example.pet_app_service.entity.Appointment;
import com.example.pet_app_service.entity.PetProfile;
import com.example.pet_app_service.service.AppointmentService;
import com.example.pet_app_service.service.PetProfileService;
import com.example.pet_app_service.service.UserService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/appointments")
public class AppointmentController {

    @Autowired
    private AppointmentService appointmentService;

    @Autowired
    private PetProfileService petProfileService;

    @Autowired
    private UserService userService;

    @PostMapping("/book/{petId}")
    public ResponseEntity<?> createAppointment(@RequestBody Appointment appointmentRequest, @PathVariable Long petId, HttpServletRequest servletRequest) {

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || auth instanceof AnonymousAuthenticationToken) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("User is not authenticated.");
        }

        String currentUserPhone = auth.getName();
        var currentUser = userService.findByPhone(currentUserPhone);

        if (currentUser == null) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("User not found.");
        }

        // Lấy thông tin PetProfile bằng petId
        PetProfile petProfile = petProfileService.findPetProfileById(petId);
        if (petProfile == null) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Pet not found.");
        }

        // Tạo và lưu appointment
        Appointment appointment = new Appointment();
        appointment.setPetProfile(petProfile);
        appointment.setUser(currentUser);
        appointment.setReason(appointmentRequest.getReason());
        appointment.setDate(appointmentRequest.getDate());
        appointment.setTime(appointmentRequest.getTime());
        appointment.setStatus(Appointment.Status.PENDING);

        appointmentService.saveAppointment(appointment);
        return ResponseEntity.status(HttpStatus.CREATED).body(appointment);
    }
}

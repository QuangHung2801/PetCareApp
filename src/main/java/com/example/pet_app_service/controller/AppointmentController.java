package com.example.pet_app_service.controller;

import com.example.pet_app_service.entity.*;
import com.example.pet_app_service.repository.ServiceRepository;
import com.example.pet_app_service.service.AppointmentService;
import com.example.pet_app_service.service.PartnerInfoService;
import com.example.pet_app_service.service.PetProfileService;
import com.example.pet_app_service.service.UserService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/appointments")
public class AppointmentController {
    @Autowired
    private ServiceRepository serviceRepository;

    @Autowired
    private PetProfileService petProfileService;
    @Autowired
    private UserService userService;
    @Autowired
    private PartnerInfoService partnerInfoService;
    @Autowired
    private AppointmentService appointmentService;

    @PostMapping("/book/{petId}/{serviceId}/{partnerId}")
    public ResponseEntity<?> createAppointment(
            @RequestBody Appointment appointmentRequest,
            @PathVariable Long petId,
            @PathVariable Long serviceId,
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

        // Lấy thông tin dịch vụ từ serviceId
        PetService selectedService = serviceRepository.findById(serviceId)
                .orElseThrow(() -> new RuntimeException("Service not found"));

        // Lấy thông tin đối tác từ partnerId
        Optional<PartnerInfo> partnerInfo = partnerInfoService.findById(partnerId);
        if (!partnerInfo.isPresent()) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Partner not found.");
        }

        // Tạo lịch hẹn
        Appointment appointment = new Appointment();
        appointment.setPet(appointmentRequest.getPet());
        appointment.setPetProfile(petProfile);
        appointment.setUser(currentUser);
        partnerInfo.ifPresent(appointment::setPartner);
        appointment.setService(selectedService);
        appointment.setReason(appointmentRequest.getReason());
        appointment.setDate(appointmentRequest.getDate());
        appointment.setTime(appointmentRequest.getTime());
        appointment.setStatus(Appointment.Status.PENDING);

        // Lưu lịch hẹn
        appointmentService.saveAppointment(appointment);

        return ResponseEntity.status(HttpStatus.CREATED).body(appointment);
    }


//
//    @PostMapping("/book/{petId}/{serviceId}")
//    public ResponseEntity<?> createAppointment(@RequestBody Appointment appointmentRequest, @PathVariable Long petId,
//                                               @PathVariable Long serviceId, HttpServletRequest servletRequest) {
//
//        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
//        if (auth == null || auth instanceof AnonymousAuthenticationToken) {
//            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("User is not authenticated.");
//        }
//        PetService selectedService = serviceRepository.findById(serviceId)
//                .orElseThrow(() -> new RuntimeException("Dịch vụ không tồn tại"));
//        if (selectedService == null) {
//            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("dich vu khong tim thay.");
//        }
//        String currentUserPhone = auth.getName();
//        var currentUser = userService.findByPhone(currentUserPhone);
//
//        if (currentUser == null) {
//            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("User not found.");
//        }
//
//        // Lấy thông tin PetProfile bằng petId
//        PetProfile petProfile = petProfileService.findPetProfileById(petId);
//        if (petProfile == null) {
//            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Pet not found.");
//        }
//
//        // Tạo và lưu appointment
//        Appointment appointment = new Appointment();
//        appointment.setPetProfile(petProfile);
//        appointment.setUser(currentUser);
//        appointment.setReason(appointmentRequest.getReason());
//        appointment.setDate(appointmentRequest.getDate());
//        appointment.setTime(appointmentRequest.getTime());
//        appointment.setService(selectedService);
//        appointment.setStatus(Appointment.Status.PENDING);
//
//        appointmentService.saveAppointment(appointment);
//        return ResponseEntity.status(HttpStatus.CREATED).body(appointment);
//    }
}

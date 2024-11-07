package com.example.pet_app_service.controller;

import com.example.pet_app_service.entity.Appointment;
import com.example.pet_app_service.repository.AppointmentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/admin/appointments")
public class AdminAppointmentController {
    @Autowired
    private AppointmentRepository appointmentRepository;

    @GetMapping("/pending")
    public List<Appointment> getPendingAppointments() {
        return appointmentRepository.findByStatus(Appointment.Status.PENDING);
    }

    @PutMapping("/confirm/{id}")
    public ResponseEntity<String> confirmAppointment(@PathVariable Long id) {
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
        Optional<Appointment> appointmentOptional = appointmentRepository.findById(id);
        if (appointmentOptional.isPresent()) {
            Appointment appointment = appointmentOptional.get();
            String status = payload.get("status");
            try {
                Appointment.Status updatedStatus = Appointment.Status.valueOf(status.toUpperCase());
                appointment.setStatus(updatedStatus); // Update status
                appointmentRepository.save(appointment); // Save existing appointment, no new creation
                return ResponseEntity.ok("Appointment status updated successfully.");
            } catch (IllegalArgumentException e) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Invalid status provided.");
            }
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Appointment not found.");
        }
    }
}

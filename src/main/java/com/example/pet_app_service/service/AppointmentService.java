package com.example.pet_app_service.service;

import com.example.pet_app_service.entity.Appointment;
import com.example.pet_app_service.repository.AppointmentRepository;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class AppointmentService {

    private final AppointmentRepository appointmentRepository;

    public List<Appointment> getAppointmentsByUserId(Long userId) {
        return appointmentRepository.findByUserId(userId);
    }

    @Autowired
    public AppointmentService(AppointmentRepository appointmentRepository) {
        this.appointmentRepository = appointmentRepository;
    }





    // Lấy lịch hẹn theo ID
    public Optional<Appointment> findById(Long appointmentId) {
        return appointmentRepository.findById(appointmentId);
    }



    // Lấy danh sách lịch hẹn theo Partner ID
    public List<Appointment> findAppointmentsByPartner(Long partnerId) {
        return appointmentRepository.findByPartnerId(partnerId);
    }
    @Transactional
    public boolean updateAppointmentStatus(Long appointmentId, Appointment status) {
        Optional<Appointment> optionalAppointment = appointmentRepository.findById(appointmentId);

        if (optionalAppointment.isPresent()) {
            Appointment appointment = optionalAppointment.get();
            appointment.setStatus(status.getStatus());
            appointmentRepository.save(appointment);
            return true;
        }

        return false;
    }

    public Appointment createAppointment(Appointment appointment) {
        return appointmentRepository.save(appointment);
    }
    public Appointment saveAppointment(Appointment appointment) {
        return appointmentRepository.save(appointment);
    }

    public List<Appointment> getAllAppointments() {
        return appointmentRepository.findAll();
    }
}
package com.example.pet_app_service.repository;

import com.example.pet_app_service.entity.Appointment;
import com.example.pet_app_service.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AppointmentRepository extends JpaRepository<Appointment, Long> {
    List<Appointment> findByUserId(Long userId);
    List<Appointment> findByStatus(Appointment.Status status);
    List<Appointment> findByStatusAndUser(Appointment.Status status, User user);
    List<Appointment> findByPartnerId(Long partnerId);
    List<Appointment> findByPartnerIdAndStatus(Long partnerId, Appointment.Status status);
}
package com.example.pet_app_service.repository;

import com.example.pet_app_service.entity.Appointment;
import com.example.pet_app_service.entity.PartnerInfo;
import com.example.pet_app_service.entity.Review;
import com.example.pet_app_service.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface ReviewRepository extends JpaRepository<Review, Long> {
    List<Review> findByAppointmentPartner(PartnerInfo partner);

    boolean existsByAppointment(Appointment appointment);
}
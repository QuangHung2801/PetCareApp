package com.example.pet_app_service.repository;

import com.example.pet_app_service.entity.PartnerInfo;
import com.example.pet_app_service.entity.Review;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ReviewRepository extends JpaRepository<Review, Long> {
    List<Review> findByAppointmentPartner(PartnerInfo partner);
}
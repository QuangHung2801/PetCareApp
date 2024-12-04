package com.example.pet_app_service.service;

import com.example.pet_app_service.entity.Appointment;
import com.example.pet_app_service.entity.PartnerInfo;
import com.example.pet_app_service.entity.Review;
import com.example.pet_app_service.repository.AppointmentRepository;
import com.example.pet_app_service.repository.PartnerInfoRepository;
import com.example.pet_app_service.repository.ReviewRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class ReviewService {

    @Autowired
    private ReviewRepository reviewRepository;

    @Autowired
    private AppointmentRepository appointmentRepository;

    @Autowired
    private PartnerInfoRepository partnerInfoRepository;

    @Transactional
    public void addReview(Long appointmentId, int rating, String comment) {
        Appointment appointment = appointmentRepository.findById(appointmentId).orElseThrow(() -> new RuntimeException("Appointment not found"));
        if (appointment.canBeReviewed()) {
            Review review = new Review();
            review.setAppointment(appointment);
            review.setRating(rating);
            review.setComment(comment);
            review.setUser(appointment.getUser());
            reviewRepository.save(review);

            // Cập nhật điểm đánh giá trung bình cho đối tác
            updatePartnerAverageRating(appointment.getPartner());
        } else {
            throw new RuntimeException("Appointment is not completed or already reviewed");
        }
    }

    private void updatePartnerAverageRating(PartnerInfo partner) {
        List<Review> reviews = reviewRepository.findByAppointmentPartner(partner);
        double averageRating = reviews.stream()
                .mapToInt(Review::getRating)
                .average()
                .orElse(0.0);
        partner.setAverageRating(averageRating);
        partnerInfoRepository.save(partner);
    }
}

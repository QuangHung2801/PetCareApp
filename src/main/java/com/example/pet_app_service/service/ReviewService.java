package com.example.pet_app_service.service;

import com.example.pet_app_service.entity.Appointment;
import com.example.pet_app_service.entity.PartnerInfo;
import com.example.pet_app_service.entity.Review;
import com.example.pet_app_service.entity.User;
import com.example.pet_app_service.repository.AppointmentRepository;
import com.example.pet_app_service.repository.PartnerInfoRepository;
import com.example.pet_app_service.repository.ReviewRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

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
        Appointment appointment = appointmentRepository.findById(appointmentId)
                .orElseThrow(() -> new RuntimeException("Lịch hẹn không tồn tại"));

        // Kiểm tra trạng thái lịch hẹn
        if (!appointment.canBeReviewed()) {
            throw new RuntimeException("Lịch hẹn chưa hoàn tất hoặc không hợp lệ để đánh giá");
        }

        // Kiểm tra xem đã có đánh giá nào cho lịch hẹn này chưa
        boolean hasReview = reviewRepository.existsByAppointment(appointment);
        if (hasReview) {
            throw new RuntimeException("Lịch hẹn đã được đánh giá trước đó");
        }

        // Tạo đánh giá mới
        Review review = new Review();
        review.setAppointment(appointment);
        review.setRating(rating);
        review.setComment(comment);
        review.setUser(appointment.getUser());
        reviewRepository.save(review);

        // Cập nhật điểm đánh giá trung bình của đối tác
        updatePartnerAverageRating(appointment.getPartner());
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

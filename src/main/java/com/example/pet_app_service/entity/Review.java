package com.example.pet_app_service.entity;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@Entity
public class Review {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private int rating; // Điểm đánh giá (từ 1 đến 5)

    @Column(length = 500)
    private String comment; // Bình luận của người dùng

    @Column(nullable = false)
    private LocalDateTime createdDate = LocalDateTime.now(); // Ngày đánh giá

    @ManyToOne
    @JoinColumn(name = "appointment_id", nullable = false)
    private Appointment appointment; // Liên kết tới lịch hẹn

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user; // Liên kết tới người dùng đã đánh giá
}

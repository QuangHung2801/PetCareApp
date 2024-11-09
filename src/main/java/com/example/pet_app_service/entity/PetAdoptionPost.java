package com.example.pet_app_service.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import lombok.Data;

import java.time.LocalDate;

@Data
@Entity
@Table(name = "pet_adoption_posts")
public class PetAdoptionPost {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank(message = "Tên thú cưng không được để trống")
    private String petName;

    @NotBlank(message = "Loại thú cưng không được để trống")
    private String type; // Loại thú cưng, ví dụ: "Chó", "Mèo"

    @NotNull(message = "Trọng lượng thú cưng không được để trống")
    private Double weight; // Trọng lượng của thú cưng (kg)

    @NotNull(message = "Ngày sinh không được để trống")
    private LocalDate birthDate; // Ngày sinh của thú cưng

    @NotBlank(message = "Mô tả không được để trống")
    private String description;

    private String imageUrl;


    @Column(nullable = false)
    private boolean adopted = false;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @NotBlank(message = "Số điện thoại không được để trống")
    @Pattern(regexp = "^[0-9]{10,15}$", message = "Số điện thoại không hợp lệ") // Chỉ chấp nhận số điện thoại có từ 10 đến 15 chữ số
    private String contactPhone;
}

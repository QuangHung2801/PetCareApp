package com.example.pet_app_service.entity;

import com.example.pet_app_service.service.ServiceType;
import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalTime;
import java.util.HashSet;
import java.util.Set;

@Getter
@Setter
@Entity
public class PartnerInfo {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String businessLicense;

    @Column
    private String businessCode;

    @Column(nullable = false)
    private String businessName;

    @Column(nullable = false)
    private String address;

    @Column(nullable = false)
    private LocalTime openingTime;

    @Column(nullable = false)
    private LocalTime closingTime;

    @Column
    private Double rating;

    @Column(nullable = false)
    @Enumerated(EnumType.STRING)
    private ServiceCategory serviceCategory; // Loại dịch vụ

    @ElementCollection(targetClass = ServiceType.class)
    @Enumerated(EnumType.STRING)
    private Set<ServiceType> services = new HashSet<>(); // Các dịch vụ do đối tác cung cấp

    @Lob
    private String imageUrl;

    @Enumerated(EnumType.STRING)
    private PartnerStatus status = PartnerStatus.PENDING;

    @OneToOne
    @JoinColumn(name = "user_id")
    @JsonBackReference
    private User user;

    // Hàm set dịch vụ theo loại dịch vụ đã chọn
    public void setAvailableServicesByCategory() {
        // Nếu loại dịch vụ là chăm sóc thú cưng
        if (this.serviceCategory == ServiceCategory.PET_CARE) {
            this.services.add(ServiceType.PET_BOARDING); // Có thể chọn thêm dịch vụ này
            this.services.add(ServiceType.PET_SPA); // Có thể chọn thêm dịch vụ này
            this.services.add(ServiceType.PET_GROOMING); // Có thể chọn thêm dịch vụ này
            this.services.add(ServiceType.PET_WALKING); // Có thể chọn thêm dịch vụ này
        }
        // Nếu loại dịch vụ là phòng khám thú y
        else if (this.serviceCategory == ServiceCategory.VETERINARY_CARE) {
            this.services.add(ServiceType.VETERINARY_EXAMINATION); // Có thể chọn thêm dịch vụ này
            this.services.add(ServiceType.VACCINATION); // Có thể chọn thêm dịch vụ này
            this.services.add(ServiceType.SURGERY); // Có thể chọn thêm dịch vụ này
            this.services.add(ServiceType.REGULAR_CHECKUP); // Có thể chọn thêm dịch vụ này
        }
    }

    public enum PartnerStatus {
        PENDING,
        APPROVED,
        REJECTED
    }

    public enum ServiceCategory {
        PET_CARE,     // Dịch vụ chăm sóc thú cưng
        VETERINARY_CARE // Dịch vụ phòng khám thú y
    }
}

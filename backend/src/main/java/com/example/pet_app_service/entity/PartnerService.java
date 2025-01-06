package com.example.pet_app_service.entity;

import com.example.pet_app_service.service.ServiceType;
import com.fasterxml.jackson.annotation.JsonBackReference;
import jakarta.persistence.*;

@Entity
public class PartnerService {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "partner_id", nullable = false)
    @JsonBackReference
    private PartnerInfo partner;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private ServiceType serviceType;

    @Column(nullable = false)
    private Double price; // Giá của từng dịch vụ

    // Getters và Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public PartnerInfo getPartner() {
        return partner;
    }

    public void setPartner(PartnerInfo partner) {
        this.partner = partner;
    }

    public ServiceType getServiceType() {
        return serviceType;
    }

    public void setServiceType(ServiceType serviceType) {
        this.serviceType = serviceType;
    }

    public Double getPrice() {
        return price;
    }

    public void setPrice(Double price) {
        this.price = price;
    }
}

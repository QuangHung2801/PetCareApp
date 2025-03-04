package com.example.pet_app_service.entity;

import com.example.pet_app_service.service.ServiceType;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

@Entity
public class Appointment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String pet;

    @JsonFormat(pattern = "yyyy-MM-dd")
    private LocalDate date;

    private LocalTime time;

    @Column(length = 500)
    private String reason;

    @NotNull(message = "Dịch vụ không được để trống")
    @ElementCollection(fetch = FetchType.LAZY)
    @Enumerated(EnumType.STRING)
    @CollectionTable(name = "appointment_services", joinColumns = @JoinColumn(name = "appointment_id"))
    @Column(name = "service_type")
    private List<ServiceType> serviceTypes;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne
    @JoinColumn(name = "pet_id", nullable = false)
    private PetProfile petProfile;

    @Enumerated(EnumType.STRING)
    private Status status = Status.PENDING;

    @ManyToOne
    @JoinColumn(name = "partner_id", nullable = false)
    private PartnerInfo partner;

    public enum Status {
        PENDING, CONFIRMED,COMPLETED, REJECTED
    }

    @OneToMany(mappedBy = "appointment", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Review> reviews = new ArrayList<>();

    // Getters and Setters

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getPet() {
        return pet;
    }

    public void setPet(String pet) {
        this.pet = pet;
    }

    public LocalDate getDate() {
        return date;
    }

    public void setDate(LocalDate date) {
        this.date = date;
    }

    public LocalTime getTime() {
        return time;
    }

    public void setTime(LocalTime time) {
        this.time = time;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public List<ServiceType> getServiceType() {
        return serviceTypes;
    }

    public void setServiceType(List<ServiceType> serviceTypes) {
        this.serviceTypes = serviceTypes;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public PetProfile getPetProfile() {
        return petProfile;
    }

    public void setPetProfile(PetProfile petProfile) {
        this.petProfile = petProfile;
    }

    public Status getStatus() {
        return status;
    }

    public void setStatus(Status status) {
        this.status = status;
    }

    public PartnerInfo getPartner() {
        return partner;
    }

    public void setPartner(PartnerInfo partner) {
        this.partner = partner;
    }

    public boolean canBeReviewed() {
        return this.status == Status.COMPLETED;
    }

    // JSON Response Enhancements
    @JsonProperty("userName")
    public String getUserName() {
        return user != null ? user.getName() : "Chưa có tên người dùng";
    }

    @JsonProperty("petName")
    public String getPetName() {
        return petProfile != null ? petProfile.getName() : "Chưa có tên thú cưng";
    }

    @JsonProperty("petType")
    public String getPetType() {
        return petProfile != null ? petProfile.getType() : "Chưa có loại thú cưng";
    }
}

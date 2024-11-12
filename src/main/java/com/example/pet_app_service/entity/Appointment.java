package com.example.pet_app_service.entity;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.persistence.*;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.Optional;


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

    @ManyToOne
    @JoinColumn(name = "service_id", nullable = false) // Liên kết với bảng dịch vụ
    private PetService service;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne
    @JoinColumn(name = "pet_id", nullable = false)

    private PetProfile petProfile;

    @Enumerated(EnumType.STRING)
    private Status status = Status.PENDING; // Trạng thái mặc định là PENDING

    // Getters và Setters


    @ManyToOne
    @JoinColumn(name = "partner_id", nullable = false)
    private PartnerInfo partner; // Removed Optional wrapper

    public enum Status {
        PENDING, CONFIRMED, REJECTED
    }

    public PartnerInfo getPartner() {
        return partner;
    }

    // Setter
    public void setPartner(PartnerInfo partner) {
        this.partner = partner;
    }

    public PetService getService() {
        return service;
    }

    public void setService(PetService service) {
        this.service = service;
    }

    public Status getStatus() {
        return status;
    }

    public PetProfile getPetProfile() {
        return petProfile;
    }

    public void setPetProfile(PetProfile petProfile) {
        this.petProfile = petProfile;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    // Setter cho status
    public void setStatus(Status status) {
        this.status = status;
    }
    // Getters và Setters
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

    public String getUserName() {
        return user != null ? user.getName() : "Chưa có tên người dùng";
    }

    public String getPetName() {
        return petProfile != null ? petProfile.getName() : "Chưa có loại thú cưng";
    }

    public String getPetType() {
        return petProfile != null ? petProfile.getType() : "Chưa có loại thú cưng";
    }

    public Long getServiceId() {
        return service != null ? service.getId() : null;
    }

    public String getPetServiceName() {
        return service != null ? service.getName() : null;
    }

    // Ensure that the JSON response includes the user name and pet name
    @JsonProperty("userName")
    public String getUserNameJson() {
        return getUserName();
    }

    @JsonProperty("petName")
    public String getPetNameJson() {
        return getPetName();
    }

    @JsonProperty("petType")
    public String getPetTypeJson() {
        return getPetType();
    }

    @JsonProperty("service")
    public String getPetServiceNameJson() {
        return getPetServiceName();
    }
}

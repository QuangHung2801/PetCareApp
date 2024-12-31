package com.example.pet_app_service.entity;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import java.time.LocalDate;

@Entity
@Table(name = "pet_profile")
public class PetProfile {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @JsonBackReference
    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @NotNull(message = "Tên thú cưng không được để trống")
    @Size(min = 2, max = 50, message = "Tên thú cưng phải có từ 2 đến 50 ký tự")
    private String name;

    @NotNull(message = "Mô tả về thú cưng không được để trống")
    @Size(max = 255, message = "Mô tả không được vượt quá 255 ký tự")
    private String description;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "M/d/yyyy")
    @NotNull(message = "Sinh nhật không được để trống")
    private LocalDate birthday;

    @NotNull(message = "Giới tính không được để trống")
    @Pattern(regexp = "Con cái|Con đực", message = "Giới tính phải là 'Con cái' hoặc 'Con đực'")
    private String gender;

    @NotNull(message = "Thông tin triệt sản không được để trống")
    private Boolean neutered;

    @NotNull(message = "Cân nặng không được để trống")
    @DecimalMin(value = "0.1", message = "Cân nặng phải lớn hơn 0")
    private Double weight;

    @NotNull(message = "Ảnh đại diện không được để trống")
    @Size(max = 255, message = "Đường dẫn ảnh không được vượt quá 255 ký tự")
    private String  imageUrl;

    @NotNull(message = "Loại thú cưng không được để trống")
    @Size(max = 50, message = "Loại thú cưng không được vượt quá 50 ký tự")
    private String type;
    // Constructor không tham số
    public PetProfile() {}

    // Constructor đầy đủ tham số
    public PetProfile(Long id, String name, String description, LocalDate birthday, String gender, Boolean neutered, Double weight, String imageUrl, String type) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.birthday = birthday;
        this.gender = gender;
        this.neutered = neutered;
        this.weight = weight;
        this.imageUrl = imageUrl;
        this.type = type;
    }

    // Getter và Setter
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public User getUser() { // Chỉnh sửa: getter trả về User
        return user;
    }

    public void setUser(User user) { // Chỉnh sửa: setter nhận User đối tượng
        this.user = user;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public LocalDate getBirthday() {
        return birthday;
    }

    public void setBirthday(LocalDate birthday) {
        this.birthday = birthday;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public Boolean getNeutered() {
        return neutered;
    }

    public void setNeutered(Boolean neutered) {
        this.neutered = neutered;
    }

    public Double getWeight() {
        return weight;
    }

    public void setWeight(Double weight) {
        this.weight = weight;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }
}

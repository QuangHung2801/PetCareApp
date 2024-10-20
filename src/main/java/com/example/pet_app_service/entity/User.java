package com.example.pet_app_service.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
@Entity
@Table(name = "users")
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "phone", length = 15, nullable = false, unique = true)
    @NotBlank(message = "Số điện thoại không được để trống")
//    @Pattern(regexp = "^\\+?\\d{10,15}$", message = "Số điện thoại không hợp lệ")
    private String phone; // Số điện thoại người dùng

    @Column(name = "email", length = 50)
    @Size(max = 50, message = "Email phải ít hơn 50 ký tự")
    private String email; // Địa chỉ email

    @Column(name = "password", length = 250, nullable = false)
    @NotBlank(message = "Mật khẩu không được để trống")
    private String password; // Mật khẩu

    @Column(name = "name", length = 50, nullable = false)
    @Size(max = 50, message = "Tên của bạn phải ít hơn 50 ký tự")
    @NotBlank(message = "Tên của bạn không được để trống")
    private String name;

    // Constructor
    public User() {}

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
}

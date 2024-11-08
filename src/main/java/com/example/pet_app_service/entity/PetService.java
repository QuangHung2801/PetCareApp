package com.example.pet_app_service.entity;

import jakarta.persistence.*;
import lombok.Data;

@Data
@Entity
@Table(name = "PetService")
public class PetService {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;  // Tên dịch vụ (ví dụ: Cắt tỉa, Khám bệnh, Tắm rửa)

    // Getter và Setter
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }


}

package com.example.pet_app_service.controller;

import com.example.pet_app_service.entity.PetService; // Sửa lại tên class đúng
import com.example.pet_app_service.repository.ServiceRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/services")
public class ServiceController {

    @Autowired
    private ServiceRepository serviceRepository;

    // Lấy danh sách dịch vụ
    @GetMapping("/all")
    public ResponseEntity<List<PetService>> getAllServices() { // Sửa từ Service thành PetService
        List<PetService> services = serviceRepository.findAll(); // Đây là PetService từ entity
        return ResponseEntity.ok(services);
    }

    // Thêm dịch vụ mới
    @PostMapping("/add")
    public ResponseEntity<PetService> addService(@RequestBody PetService petService) { // Sửa từ Service thành PetService
        PetService savedService = serviceRepository.save(petService);
        return ResponseEntity.status(HttpStatus.CREATED).body(savedService);
    }

    // Cập nhật dịch vụ
    @PutMapping("/update/{id}")
    public ResponseEntity<PetService> updateService(@PathVariable Long id, @RequestBody PetService petService) { // Sửa từ Service thành PetService
        if (!serviceRepository.existsById(id)) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
        }
        petService.setId(id); // Đảm bảo ID đúng khi cập nhật
        PetService updatedService = serviceRepository.save(petService);
        return ResponseEntity.ok(updatedService);
    }

    // Xóa dịch vụ
    @DeleteMapping("/delete/{id}")
    public ResponseEntity<Void> deleteService(@PathVariable Long id) {
        if (!serviceRepository.existsById(id)) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
        }
        serviceRepository.deleteById(id);
        return ResponseEntity.status(HttpStatus.NO_CONTENT).body(null);
    }
}

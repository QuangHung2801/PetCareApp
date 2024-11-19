package com.example.pet_app_service.controller;

import com.example.pet_app_service.entity.PartnerInfo;
import com.example.pet_app_service.entity.PartnerInfo.ServiceCategory;
import com.example.pet_app_service.entity.User;
import com.example.pet_app_service.repository.PartnerInfoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/clinics")
public class AnimalCareController {

    @Autowired
    private PartnerInfoRepository partnerInfoRepository;

    // API lấy danh sách phòng khám theo thể loại dịch vụ và tìm kiếm theo tên
    @GetMapping
    public ResponseEntity<List<PartnerInfo>> getClinicsByServiceCategory(
            @RequestParam ServiceCategory category,
            @RequestParam(required = false) String search) {

        List<PartnerInfo> clinics;

        // Nếu có search query thì lọc theo tên hoặc địa chỉ
        if (search != null && !search.isEmpty()) {
            clinics = partnerInfoRepository.findByServiceCategoryAndStatusAndBusinessNameContainingIgnoreCase(
                    category, PartnerInfo.PartnerStatus.APPROVED, search);
        } else {
            clinics = partnerInfoRepository.findByServiceCategoryAndStatus(category, PartnerInfo.PartnerStatus.APPROVED);
        }
        for (PartnerInfo clinic : clinics) {
            clinic.setImageUrl(clinic.getImageUrl());
        }
        return ResponseEntity.ok(clinics);
    }

    @GetMapping("/{clinicName}")
    public ResponseEntity<Map<String, Object>> getClinicDetails(@PathVariable String clinicName) {
        PartnerInfo clinic = partnerInfoRepository.findByBusinessNameAndStatus(clinicName, PartnerInfo.PartnerStatus.APPROVED);

        if (clinic == null) {
            return ResponseEntity.notFound().build();
        }

        User user = clinic.getUser();

        Map<String, Object> response = new HashMap<>();
        response.put("id",clinic.getId());
        response.put("businessName", clinic.getBusinessName());
        response.put("address", clinic.getAddress());
        response.put("imageUrl", clinic.getImageUrl());
        response.put("workingHours", clinic.getOpeningTime() + " - " + clinic.getClosingTime());
        response.put("services", clinic.getServices());
        response.put("user_id", clinic.getUser().getId());
        response.put("phone", user != null ? user.getPhone() : "");
        response.put("email", user != null ? user.getEmail() : "");

        return ResponseEntity.ok(response);
    }

}

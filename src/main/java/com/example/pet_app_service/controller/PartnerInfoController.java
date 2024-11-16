package com.example.pet_app_service.controller;

import com.example.pet_app_service.entity.PartnerInfo;
import com.example.pet_app_service.entity.Role;
import com.example.pet_app_service.entity.User;
import com.example.pet_app_service.repository.RoleRepository;
import com.example.pet_app_service.service.PartnerInfoService;
import com.example.pet_app_service.repository.UserRepository;
import com.example.pet_app_service.service.ServiceType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalTime;
import java.util.*;

@RestController
@RequestMapping("/api/partner")
public class PartnerInfoController {

    private final String UPLOAD_DIR = "src/main/resources/static/update/img/partners/";

    @Autowired
    private PartnerInfoService partnerInfoService;

    @Autowired
    private RoleRepository roleRepository;

    @Autowired
    private UserRepository userRepository;

    @PostMapping("/register")
    public ResponseEntity<?> registerPartner(
            @RequestParam Long userId,
            @RequestParam(required = false) MultipartFile image,
            @RequestParam String businessLicense,
            @RequestParam String businessName,
            @RequestParam String address,
            @RequestParam("openingTime") @DateTimeFormat(pattern = "HH:mm") LocalTime openingTime,
            @RequestParam("closingTime") @DateTimeFormat(pattern = "HH:mm") LocalTime closingTime,
            @RequestParam String serviceCategory,
            @RequestParam String services) { // Chuyển 'services' thành tham số hợp lệ

        Set<String> selectedServices = new HashSet<>(Arrays.asList(services.split(",")));

        // Chuyển đổi serviceCategory sang enum
        PartnerInfo.ServiceCategory category;
        try {
            category = PartnerInfo.ServiceCategory.valueOf(serviceCategory);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body("Invalid service category");
        }

        PartnerInfo partnerInfo = new PartnerInfo();
        partnerInfo.setBusinessLicense(businessLicense);
        partnerInfo.setBusinessName(businessName);
        partnerInfo.setAddress(address);
        partnerInfo.setOpeningTime(openingTime);
        partnerInfo.setClosingTime(closingTime);
        partnerInfo.setServiceCategory(category);

        // Lấy người dùng từ cơ sở dữ liệu
        Optional<User> userOpt = userRepository.findById(userId);
        if (userOpt.isEmpty()) {
            return ResponseEntity.badRequest().body("User not found");
        }

        User user = userOpt.get();
        partnerInfo.setUser(user);

        // Chuyển đổi các dịch vụ đã chọn từ String sang ServiceType
        Set<ServiceType> serviceSet = new HashSet<>();
        for (String service : selectedServices) {
            try {
                serviceSet.add(ServiceType.valueOf(service));
            } catch (IllegalArgumentException e) {
                return ResponseEntity.badRequest().body("Invalid service selected: " + service);
            }
        }
        partnerInfo.setServices(serviceSet);

        // Lưu ảnh nếu có
        if (image != null && !image.isEmpty()) {
            String imageUrl = saveImage(image);
            partnerInfo.setImageUrl(imageUrl);
        }

        // Lưu đối tác vào cơ sở dữ liệu
        PartnerInfo registeredPartner = partnerInfoService.registerPartner(partnerInfo);

        return ResponseEntity.ok("Registration submitted. Waiting for approval.");
    }

    @PutMapping("/approve/{id}")
    public ResponseEntity<?> approvePartner(@PathVariable Long id) {
        Optional<PartnerInfo> partnerOpt = partnerInfoService.findById(id);

        if (partnerOpt.isPresent()) {
            PartnerInfo partnerInfo = partnerOpt.get();

            // Thay đổi trạng thái đối tác thành đã được duyệt
            partnerInfoService.approvePartner(partnerInfo);

            // Thay đổi vai trò người dùng từ user thành partner
            User user = partnerInfo.getUser();
            if (user != null) {
                // Lấy vai trò cũ (nếu có) và xóa nó
                Set<Role> currentRoles = user.getRoles();

                // Tìm và xóa vai trò "USER" (hoặc vai trò khác nếu cần)
                currentRoles.removeIf(role -> role.getName().equals("USER"));

                // Tạo vai trò "partner" nếu chưa có trong cơ sở dữ liệu
                Role partnerRole = roleRepository.findByName("PARTNER");
                if (partnerRole == null) {
                    partnerRole = new Role("PARTNER");
                    roleRepository.save(partnerRole);
                }

                // Thêm vai trò "PARTNER"
                currentRoles.add(partnerRole);
                user.setRoles(currentRoles);
                userRepository.save(user);  // Lưu lại thay đổi vào cơ sở dữ liệu.
            }

            return ResponseEntity.ok("Partner approved and role updated successfully.");
        }
        return ResponseEntity.badRequest().body("Partner not found");
    }

    @DeleteMapping("/delete/{id}")
    public ResponseEntity<?> deletePartner(@PathVariable Long id) {
        Optional<PartnerInfo> partnerOpt = partnerInfoService.findById(id);
        if (partnerOpt.isEmpty()) {
            return ResponseEntity.badRequest().body("Partner not found");
        }

        PartnerInfo partnerInfo = partnerOpt.get();
        partnerInfoService.deletePartner(partnerInfo);

        return ResponseEntity.ok("Partner account deleted, user remains.");
    }

    @GetMapping("/pending")
    public ResponseEntity<List<PartnerInfo>> getPendingPartners() {
        List<PartnerInfo> pendingPartners = partnerInfoService.getPendingPartners();
        return ResponseEntity.ok(pendingPartners);
    }

    private String saveImage(MultipartFile image) {
        try {
            String fileName = System.currentTimeMillis() + "_" + image.getOriginalFilename();
            Path filePath = Paths.get(UPLOAD_DIR, fileName);

            // Tạo thư mục nếu chưa có
            Files.createDirectories(filePath.getParent());
            Files.write(filePath, image.getBytes());

            return fileName;
        } catch (IOException e) {
            throw new RuntimeException("Failed to save image: " + e.getMessage());
        }
    }
}

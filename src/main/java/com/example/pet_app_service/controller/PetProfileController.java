package com.example.pet_app_service.controller;

import com.example.pet_app_service.entity.PetProfile;
import com.example.pet_app_service.service.PetProfileService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import java.io.File;
import java.io.IOException;

@RestController
@RequestMapping("/api/pet")
public class PetProfileController {

    private final PetProfileService petProfileService;

    public PetProfileController(PetProfileService petProfileService) {
        this.petProfileService = petProfileService;
    }

    @PostMapping("/add")
    public ResponseEntity<String> addPetProfile(
            @RequestPart("petProfile") PetProfile petProfile,
            @RequestPart("image") MultipartFile image) {

        // Kiểm tra nếu file ảnh không rỗng
        if (!image.isEmpty()) {
            try {
                // Lưu file vào một thư mục cụ thể
                String fileName = image.getOriginalFilename();
                String uploadDir = "uploads/";
                File file = new File(uploadDir + fileName);

                // Tạo thư mục nếu chưa tồn tại
                file.getParentFile().mkdirs();

                image.transferTo(file);

                // Cập nhật đường dẫn ảnh trong đối tượng petProfile
                petProfile.setImageUrl(uploadDir + fileName);
            } catch (IOException e) {
                return ResponseEntity.status(500).body("Không thể lưu hình ảnh");
            }
        }

        // Lưu thông tin petProfile vào cơ sở dữ liệu
        petProfileService.savePetProfile(petProfile);
        return ResponseEntity.ok("Thú cưng đã được thêm thành công");
    }
}

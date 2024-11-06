package com.example.pet_app_service.controller;

import com.example.pet_app_service.Validtion.ValidUserId;
import com.example.pet_app_service.entity.PetProfile;
import com.example.pet_app_service.entity.User;
import com.example.pet_app_service.service.PetProfileService;
import com.example.pet_app_service.service.UserService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDate;
import java.util.Collections;
import java.util.List;

@RestController
@RequestMapping("/api/pet")
public class PetProfileController {

    private final PetProfileService petProfileService;
    private final UserService userService;


    // Đường dẫn nơi lưu trữ hình ảnh
    private final String UPLOAD_DIR = "src/main/resources/static/update/img/pets/";

    public PetProfileController(PetProfileService petProfileService, UserService userService) {
        this.petProfileService = petProfileService;
        this.userService = userService;
    }

    // Endpoint để lấy tất cả hồ sơ thú cưng
    @PostMapping("/all")
    public ResponseEntity<List<PetProfile>> getPetProfilesByUserId(@RequestParam("userId") Long userId) {
        List<PetProfile> petProfiles = petProfileService.getPetProfilesByUserId(userId);
        for (PetProfile pet : petProfiles) {
            pet.setImageUrl(pet.getImageUrl());
        }
        return ResponseEntity.ok(petProfiles);
    }

    @PostMapping("/check-auth")
    public ResponseEntity<String> checkAuth() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        System.out.println("Current Authentication: " + auth);
        if (auth != null && !(auth instanceof AnonymousAuthenticationToken)) {
            return ResponseEntity.ok("User is authenticated: " + auth.getName());
        }
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("User is not authenticated.");
    }

    // Endpoint để thêm hồ sơ thú cưng
    @PostMapping("/add")
    public ResponseEntity<?> addPetProfile(
            @RequestParam("name") String name,
            @RequestParam("description") String description,
            @RequestParam("birthday") String birthday,
            @RequestParam("gender") String gender,
            @RequestParam("neutered") boolean neutered,
            @RequestParam("weight") double weight,
            @RequestParam("type") String type,
            @RequestParam("image") MultipartFile image,  HttpServletRequest request) {

        try {
            String cookieHeader = request.getHeader("Cookie");
            System.out.println("Received Cookie Header: " + cookieHeader);

            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            System.out.println("Current Authentication: " + auth);
            // Kiểm tra xác thực người dùng
            if (auth == null || auth instanceof AnonymousAuthenticationToken) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("User is not authenticated.");
            }


            String currentUserPhone = auth.getName(); // Sử dụng tên đăng nhập (số điện thoại)
            System.out.println("phone: " + currentUserPhone);
            // Tìm người dùng bằng số điện thoại
            User currentUser = userService.findByPhone(currentUserPhone);

            // Kiểm tra nếu người dùng không tồn tại
            if (currentUser == null) {
                return ResponseEntity.status(403).body("Người dùng không được tìm thấy hoặc không xác thực");
            }

            // Lấy userId
            Long userId = currentUser.getId(); // Lấy userId từ đối tượng User
            System.out.println("id: " + userId);
            // Xử lý upload hình ảnh
            String imageUrl = saveImage(image);
            if (imageUrl == null) {
                return ResponseEntity.badRequest().body("Tải ảnh lên thất bại");
            }

            // Chuyển đổi chuỗi ngày sinh thành LocalDate
            LocalDate birthDate = LocalDate.parse(birthday);

            // Tạo và lưu hồ sơ thú cưng
            PetProfile petProfile = new PetProfile();
            petProfile.setName(name);
            petProfile.setDescription(description);
            petProfile.setBirthday(birthDate);
            petProfile.setGender(gender);
            petProfile.setNeutered(neutered);
            petProfile.setWeight(weight);
            petProfile.setImageUrl(imageUrl);
            petProfile.setUser(currentUser); // Gán đối tượng User cho hồ sơ thú cưng

            // Lưu hồ sơ thú cưng
            petProfileService.savePetProfile(petProfile);

            return ResponseEntity.ok("Thú cưng đã được thêm thành công");

        } catch (Exception e) {
            return ResponseEntity.status(500).body("Lỗi: " + e.getMessage());
        }
    }

    // Phương thức để lưu hình ảnh
    private String saveImage(MultipartFile image) throws IOException {
        if (image.isEmpty()) {
            return null;
        }
        // Tạo tên tệp tin duy nhất
        String filename = System.currentTimeMillis() + "_" + image.getOriginalFilename();
        Path filePath = Paths.get(UPLOAD_DIR, filename);

        // Đảm bảo thư mục upload tồn tại
        Files.createDirectories(filePath.getParent());
        // Lưu tệp tin
        Files.write(filePath, image.getBytes());

        return filename; // Trả về tên tệp tin để lưu vào database
    }

    @DeleteMapping("/delete/{petId}")
    public ResponseEntity<String> deletePetProfile(@PathVariable Long petId) {
        try {
            petProfileService.deletePetProfileById(petId);
            return ResponseEntity.ok("Hồ sơ thú cưng đã được xóa thành công");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Lỗi: " + e.getMessage());
        }
    }
}

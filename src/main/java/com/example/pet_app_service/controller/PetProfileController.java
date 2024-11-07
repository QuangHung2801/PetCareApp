package com.example.pet_app_service.controller;

import com.example.pet_app_service.Validtion.ValidUserId;
import com.example.pet_app_service.entity.PetProfile;
import com.example.pet_app_service.entity.User;
import com.example.pet_app_service.service.PetProfileService;
import com.example.pet_app_service.service.UserService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.transaction.Transactional;
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
import java.util.Map;

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



        @PostMapping("/all")
        public ResponseEntity<?> getPetProfilesByUserId(@RequestBody Map<String, String> body) {
            String userIdStr = body.get("userId");
            if (userIdStr == null) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("User ID is required.");
            }

            // Convert userId from string to Long
            Long userId;
            try {
                userId = Long.valueOf(userIdStr);
            } catch (NumberFormatException e) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Invalid User ID.");
            }
        // Lấy hồ sơ thú cưng của người dùng
        List<PetProfile> petProfiles = petProfileService.getPetProfilesByUserId(userId);
        for (PetProfile pet : petProfiles) {
            pet.setImageUrl(pet.getImageUrl());
        }
        return ResponseEntity.ok(petProfiles);
    }

    @GetMapping("/detail/{petId}")
    public ResponseEntity<PetProfile> getPetDetail(@PathVariable Long petId) {
        System.out.println("Received petId: " + petId);
        PetProfile petProfile = petProfileService.findPetProfileById(petId);
        System.out.println("fđf"+petProfile);
        if (petProfile == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
        }
        return ResponseEntity.ok(petProfile);
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
            petProfile.setType(type);
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
    @Transactional
    @PutMapping("/edit/{petId}")
    public ResponseEntity<?> editPetProfile(
            @PathVariable Long petId,
            @RequestParam("name") String name,
            @RequestParam("description") String description,
            @RequestParam("birthday") String birthday,
            @RequestParam("gender") String gender,
            @RequestParam("neutered") boolean neutered,
            @RequestParam("weight") double weight,
            @RequestParam("type") String type,
            @RequestParam(value = "image", required = false) MultipartFile image,  // Ảnh có thể không thay đổi
            HttpServletRequest request) {

        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            if (auth == null || auth instanceof AnonymousAuthenticationToken) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("User is not authenticated.");
            }

            String currentUserPhone = auth.getName(); // Sử dụng tên đăng nhập (số điện thoại)
            User currentUser = userService.findByPhone(currentUserPhone);

            if (currentUser == null) {
                return ResponseEntity.status(403).body("Người dùng không được tìm thấy hoặc không xác thực");
            }

            // Tìm hồ sơ thú cưng cần sửa
            PetProfile petProfile = petProfileService.findPetProfileById(petId);
            if (petProfile == null) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Hồ sơ thú cưng không tồn tại");
            }

            // Kiểm tra xem người dùng có quyền sửa hồ sơ này không
            if (!petProfile.getUser().getId().equals(currentUser.getId())) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body("Bạn không có quyền sửa hồ sơ này");
            }

            // Chỉnh sửa thông tin hồ sơ thú cưng
            petProfile.setName(name);
            petProfile.setDescription(description);
            petProfile.setBirthday(LocalDate.parse(birthday));
            petProfile.setGender(gender);
            petProfile.setNeutered(neutered);
            petProfile.setType(type);
            petProfile.setWeight(weight);

            // Nếu có hình ảnh mới, thay thế hình ảnh cũ
            if (image != null && !image.isEmpty()) {
                String imageUrl = saveImage(image);
                if (imageUrl != null) {
                    petProfile.setImageUrl(imageUrl);
                } else {
                    return ResponseEntity.badRequest().body("Tải ảnh lên thất bại");
                }
            }

            // Lưu lại hồ sơ thú cưng đã chỉnh sửa
            petProfileService.savePetProfile(petProfile);

            return ResponseEntity.ok("Hồ sơ thú cưng đã được chỉnh sửa thành công");

        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Lỗi: " + e.getMessage());
        }
    }
}

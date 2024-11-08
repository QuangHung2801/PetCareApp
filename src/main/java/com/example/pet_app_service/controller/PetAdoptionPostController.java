package com.example.pet_app_service.controller;

import com.example.pet_app_service.entity.PetAdoptionPost;
import com.example.pet_app_service.entity.User;
import com.example.pet_app_service.service.PetAdoptionPostService;
import com.example.pet_app_service.service.UserService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;


@RestController
@RequestMapping("/api/adoption")
public class PetAdoptionPostController {

    private final PetAdoptionPostService petAdoptionPostService;
    private final UserService userService;

    private final String UPLOAD_DIR = "src/main/resources/static/update/img/pets/";

    @Autowired
    public PetAdoptionPostController(PetAdoptionPostService petAdoptionPostService, UserService userService) {
        this.petAdoptionPostService = petAdoptionPostService;
        this.userService = userService;
    }

    @GetMapping("/all")
    public ResponseEntity<List<PetAdoptionPost>> getAllAdoptionPosts() {
        List<PetAdoptionPost> posts = petAdoptionPostService.getAllAdoptionPosts();
        return ResponseEntity.ok(posts);
    }

    @GetMapping("/detail/{postId}")
    public ResponseEntity<PetAdoptionPost> getAdoptionPostDetail(@PathVariable Long postId) {
        PetAdoptionPost post = petAdoptionPostService.findAdoptionPostById(postId);
        if (post == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
        }
        return ResponseEntity.ok(post);
    }

    @PostMapping("/create")
    public ResponseEntity<?> createAdoptionPost(
            @RequestParam("petName") String petName,
            @RequestParam("type") String type,
            @RequestParam("weight") Double weight,
            @RequestParam("birthDate") String birthDate,
            @RequestParam("description") String description,
            @RequestParam("image") MultipartFile image,
            @RequestParam(value = "adopted", defaultValue = "false") boolean adopted,
            HttpServletRequest request) {

        try {
            // Kiểm tra xem người dùng đã đăng nhập chưa
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            if (auth == null || auth instanceof AnonymousAuthenticationToken) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("User is not authenticated.");
            }

            // Lấy thông tin người dùng từ phone (đã đăng nhập)
            String currentUserPhone = auth.getName();
            User currentUser = userService.findByPhone(currentUserPhone);

            if (currentUser == null) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body("User not found or not authenticated.");
            }

            // Kiểm tra và lưu ảnh nếu có
            String imageUrl = saveImage(image);
            if (imageUrl == null) {
                return ResponseEntity.badRequest().body("Failed to upload image");
            }

            // Xử lý ngày sinh pet (Kiểm tra định dạng ngày tháng hợp lệ)
            LocalDate birthDateParsed = null;
            try {
                birthDateParsed = LocalDate.parse(birthDate);
            } catch (Exception e) {
                return ResponseEntity.badRequest().body("Invalid birth date format. Please use YYYY-MM-DD.");
            }

            // Tạo post và lưu vào database
            PetAdoptionPost post = new PetAdoptionPost();
            post.setPetName(petName);
            post.setType(type);
            post.setWeight(weight);
            post.setBirthDate(birthDateParsed);
            post.setDescription(description);
            post.setImageUrl(imageUrl);
            post.setUser(currentUser);
            post.setAdopted(adopted);  // Thêm trạng thái adopted

            petAdoptionPostService.saveAdoptionPost(post);

            return ResponseEntity.ok("Adoption post created successfully");

        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error: " + e.getMessage());
        }
    }

    // Hàm lưu ảnh lên thư mục
    private String saveImage(MultipartFile image) throws IOException {
        if (image.isEmpty()) {
            return null;  // Không có ảnh
        }
        String filename = System.currentTimeMillis() + "_" + image.getOriginalFilename();
        Path filePath = Paths.get(UPLOAD_DIR, filename);

        // Tạo thư mục nếu chưa tồn tại
        Files.createDirectories(filePath.getParent());

        // Lưu ảnh vào file
        Files.write(filePath, image.getBytes());

        return filename;  // Trả về tên ảnh đã lưu
    }

    // Cập nhật trạng thái adopted của bài đăng
    @PutMapping("/update/{postId}")
    public ResponseEntity<?> updateAdoptedStatus(@PathVariable Long postId, @RequestParam("adopted") boolean adopted) {
        PetAdoptionPost post = petAdoptionPostService.findAdoptionPostById(postId);
        if (post == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Post not found.");
        }
        post.setAdopted(adopted);
        petAdoptionPostService.saveAdoptionPost(post);
        return ResponseEntity.ok("Adoption status updated successfully.");
    }
}

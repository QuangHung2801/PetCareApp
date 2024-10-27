package com.example.pet_app_service.controller;

import com.example.pet_app_service.entity.PetProfile;
import com.example.pet_app_service.service.PetProfileService;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDate;
@RestController
@RequestMapping("/api/pet")
public class PetProfileController {

    private final PetProfileService petProfileService;

    @Value("${upload.path}")
    private String uploadDir;

    public PetProfileController(PetProfileService petProfileService) {
        this.petProfileService = petProfileService;
    }

    @PostMapping("/add")
    public ResponseEntity<String> addPetProfile(
            @RequestParam("name") String name,
            @RequestParam("description") String description,
            @RequestParam("birthday") String birthday,
            @RequestParam("gender") String gender,
            @RequestParam("neutered") boolean neutered,
            @RequestParam("weight") double weight,
            @RequestParam("type") String type,
            @RequestParam("image") MultipartFile image) {

        try {
            // Handle image upload
            String imageUrl = saveImage(image);
            if (imageUrl == null) {
                return ResponseEntity.badRequest().body("Image upload failed");
            }

            // Convert string birthday to LocalDate
            LocalDate birthDate = LocalDate.parse(birthday);

            // Create and save the PetProfile
            PetProfile petProfile = new PetProfile();
            petProfile.setName(name);
            petProfile.setDescription(description);
            petProfile.setBirthday(birthDate);
            petProfile.setGender(gender);
            petProfile.setNeutered(neutered);
            petProfile.setWeight(weight);
            petProfile.setImageUrl(imageUrl);

            petProfileService.savePetProfile(petProfile);

            return ResponseEntity.ok("Thú cưng đã được thêm thành công");

        } catch (Exception e) {
            return ResponseEntity.status(500).body("Error: " + e.getMessage());
        }
    }

    private String saveImage(MultipartFile image) throws IOException {
        if (image.isEmpty()) {
            return null;
        }
        // Create unique filename
        String filename = System.currentTimeMillis() + "_" + image.getOriginalFilename();
        Path filePath = Paths.get(uploadDir, filename);

        // Ensure upload directory exists
        Files.createDirectories(filePath.getParent());

        // Save file
        Files.write(filePath, image.getBytes());

        return filePath.toString();
    }
}
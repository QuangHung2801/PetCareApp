package com.example.pet_app_service.controller;

import com.example.pet_app_service.entity.PetProfile;
import com.example.pet_app_service.service.PetProfileService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/pet")
public class PetProfileController {

    // Inject PetProfileService để lưu dữ liệu vào cơ sở dữ liệu
    private final PetProfileService petProfileService;

    public PetProfileController(PetProfileService petProfileService) {
        this.petProfileService = petProfileService;
    }

    @PostMapping("/add")
    public ResponseEntity<String> addPetProfile(@RequestBody PetProfile petProfile) {
        petProfileService.savePetProfile(petProfile);
        return ResponseEntity.ok("Thú cưng đã được thêm thành công");
    }
}

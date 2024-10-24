package com.example.pet_app_service.service;

import com.example.pet_app_service.entity.PetProfile;
import com.example.pet_app_service.repository.PetProfileRepository;
import org.springframework.stereotype.Service;

@Service
public class PetProfileService {
    private final PetProfileRepository petProfileRepository;

    public PetProfileService(PetProfileRepository petProfileRepository) {
        this.petProfileRepository = petProfileRepository;
    }

    public void savePetProfile(PetProfile petProfile) {
        petProfileRepository.save(petProfile);
    }
}

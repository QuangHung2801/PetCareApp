package com.example.pet_app_service.service;

import com.example.pet_app_service.entity.PetProfile;
import com.example.pet_app_service.repository.PetProfileRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class PetProfileService {
    private final PetProfileRepository petProfileRepository;

    public List<PetProfile> getAllPetProfiles() {
        return petProfileRepository.findAll();
    }

    public PetProfileService(PetProfileRepository petProfileRepository) {
        this.petProfileRepository = petProfileRepository;
    }
    public List<PetProfile> getPetProfilesByUserId(Long userId) {
        return petProfileRepository.findByUserId(userId);
    }

    public PetProfile findPetProfileById(Long petId) {
        return petProfileRepository.findById(petId).orElse(null);
    }
    public void savePetProfile(PetProfile petProfile) {
        petProfileRepository.save(petProfile);
    }

    public void deletePetProfileById(Long petId) {
        petProfileRepository.deleteById(petId);
    }
}

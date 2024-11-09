package com.example.pet_app_service.service;

import com.example.pet_app_service.entity.PetAdoptionPost;
import com.example.pet_app_service.repository.PetAdoptionPostRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class PetAdoptionPostService {

    private final PetAdoptionPostRepository petAdoptionPostRepository;

    @Autowired
    public PetAdoptionPostService(PetAdoptionPostRepository petAdoptionPostRepository) {
        this.petAdoptionPostRepository = petAdoptionPostRepository;
    }

    public void saveAdoptionPost(PetAdoptionPost post) {
        petAdoptionPostRepository.save(post);
    }

    public List<PetAdoptionPost> getAllAdoptionPosts() {
        return petAdoptionPostRepository.findAll();
    }
    public List<PetAdoptionPost> getPostsByUser(Long userId) {
        return petAdoptionPostRepository.findByUserId(userId);
    }

    public PetAdoptionPost findAdoptionPostById(Long id) {
        return petAdoptionPostRepository.findById(id).orElse(null);
    }
}

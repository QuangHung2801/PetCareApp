package com.example.pet_app_service.repository;

import com.example.pet_app_service.entity.PetAdoptionPost;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface PetAdoptionPostRepository extends JpaRepository<PetAdoptionPost, Long> {
    List<PetAdoptionPost> findByUserId(Long userId);
}

package com.example.pet_app_service.repository;

import com.example.pet_app_service.entity.PetProfile;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PetProfileRepository extends JpaRepository<PetProfile, Long> {
    List<PetProfile> findByUserId(Long userId);
}

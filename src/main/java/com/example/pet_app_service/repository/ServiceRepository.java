package com.example.pet_app_service.repository;

import com.example.pet_app_service.entity.PetProfile;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import com.example.pet_app_service.entity.PetService;

import java.util.Optional;

@Repository
public interface ServiceRepository extends JpaRepository<PetService, Long> {
    Optional<PetService> findById(Long serviceId);
}
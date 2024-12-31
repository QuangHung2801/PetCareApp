package com.example.pet_app_service.repository;

import com.example.pet_app_service.entity.Role;
import com.example.pet_app_service.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByPhone(String phone);
    boolean existsByPhone(String phone);
    boolean existsByEmail(String email);
    Optional<User> findByEmail(String email);
    Role findByName(String name);
}

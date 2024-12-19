package com.example.pet_app_service.repository;

import com.example.pet_app_service.entity.Like;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface LikeRepository extends JpaRepository<Like, Long> {
    int countByPostId(Long postId);
    boolean existsByUserIdAndPostId(Long userId, Long postId);
    Optional<Like> findByUserIdAndPostId(Long userId, Long postId);
}

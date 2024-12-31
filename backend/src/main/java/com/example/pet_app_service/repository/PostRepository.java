package com.example.pet_app_service.repository;

import com.example.pet_app_service.entity.Post;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface PostRepository extends JpaRepository<Post, Long> {
    @Query("SELECT p FROM Post p JOIN FETCH p.user WHERE p.user.id = :userId")
    List<Post> findByUserId(Long userId);

    // Truy vấn lấy tất cả bài viết và username của user liên quan (có thể hiển thị tất cả dữ liệu của Post)
    @Query("SELECT p FROM Post p JOIN FETCH p.user")
    List<Post> findAllPostsWithUsernames();
}

package com.example.pet_app_service.controller;

import com.example.pet_app_service.service.LikeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/likes")
public class LikeController {
    @Autowired
    private LikeService likeService;

    // Toggle like cho một bài viết
    @PostMapping
    public ResponseEntity<String> likePost(@RequestParam Long userId, @RequestParam Long postId) {
        likeService.likePost(userId, postId);
        return ResponseEntity.ok("Đã thích bài đăng");
    }

    @DeleteMapping
    public ResponseEntity<String> unlikePost(@RequestParam Long userId, @RequestParam Long postId) {
        likeService.unlikePost(userId, postId);
        return ResponseEntity.ok("Đã bỏ thích bài đăng");
    }

    @GetMapping("/status")
    public ResponseEntity<Boolean> isLiked(@RequestParam Long userId, @RequestParam Long postId) {
        System.out.println("Checking like status for userId=" + userId + " and postId=" + postId);
        boolean isLiked = likeService.isLiked(userId, postId);
        return ResponseEntity.ok(isLiked);
    }
}

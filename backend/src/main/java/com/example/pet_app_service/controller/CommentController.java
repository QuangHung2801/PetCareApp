package com.example.pet_app_service.controller;

import com.example.pet_app_service.entity.Comment;
import com.example.pet_app_service.service.CommentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/comments")
public class CommentController {
    @Autowired
    private CommentService commentService;

    @GetMapping
    public ResponseEntity<List<Comment>> getComments(@RequestParam Long postId) {
        List<Comment> comments = commentService.getCommentsByPost(postId);
        return ResponseEntity.ok(comments);
    }

    @PostMapping
    public ResponseEntity<Comment> addComment(@RequestParam Long userId, @RequestParam Long postId, @RequestBody Map<String, String> requestBody) {
        // Kiểm tra nếu userId hoặc postId không hợp lệ
        if (userId == null || postId == null || requestBody.get("content") == null || requestBody.get("content").isEmpty()) {
            return ResponseEntity.badRequest().body(null); // Trả về lỗi 400 nếu thiếu dữ liệu
        }

        String content = requestBody.get("content"); // Lấy nội dung bình luận từ Map
        Comment comment = commentService.addComment(userId, postId, content);
        return ResponseEntity.ok(comment);
    }
}

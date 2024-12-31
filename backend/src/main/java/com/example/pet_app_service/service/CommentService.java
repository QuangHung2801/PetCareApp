package com.example.pet_app_service.service;

import com.example.pet_app_service.entity.Comment;
import com.example.pet_app_service.entity.Post;
import com.example.pet_app_service.entity.User;
import com.example.pet_app_service.repository.CommentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CommentService {
    @Autowired
    private CommentRepository commentRepository;
    private final PostService postService;
    private final UserService userService;

    public CommentService(PostService postService, UserService userService) {
        this.postService = postService;
        this.userService = userService;
    }

    public List<Comment> getCommentsByPost(Long postId) {
        return commentRepository.findByPostId(postId);
    }

    public Comment addComment(Long userId, Long postId, String content) {
        // Kiểm tra xem userId và postId có hợp lệ không
        User user = userService.findById(userId); // Lấy User từ database
        Post post = postService.findById(postId); // Lấy Post từ database

        if (user == null || post == null) {
            throw new IllegalArgumentException("User or Post not found");
        }

        Comment comment = new Comment();
        comment.setUser(user);
        comment.setPost(post);
        comment.setContent(content);
        return commentRepository.save(comment);
    }
}


package com.example.pet_app_service.service;

import com.example.pet_app_service.entity.Post;
import com.example.pet_app_service.repository.PostRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class PostService {

    @Autowired
    private PostRepository postRepository;  // Giả sử bạn có một repository để làm việc với bảng Post

    // Lưu bài đăng
    public Post savePost(Post post) {
        postRepository.save(post);
        return post;
    }
}


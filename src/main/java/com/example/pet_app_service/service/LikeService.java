package com.example.pet_app_service.service;

import com.example.pet_app_service.entity.Like;
import com.example.pet_app_service.entity.Post;
import com.example.pet_app_service.entity.User;
import com.example.pet_app_service.repository.LikeRepository;
import com.example.pet_app_service.repository.PostRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class LikeService {
    @Autowired
    private LikeRepository likeRepository;

    @Autowired
    private PostRepository postRepository;

    public boolean isLiked(Long userId, Long postId) {
        boolean exists = likeRepository.existsByUserIdAndPostId(userId, postId);
        System.out.println("isLiked check: userId=" + userId + ", postId=" + postId + ", exists=" + exists);

        if (exists) {
            Optional<Like> like = likeRepository.findByUserIdAndPostId(userId, postId);
            like.ifPresent(l -> System.out.println("Like found: " + l));
        } else {
            System.out.println("No like found for userId=" + userId + " and postId=" + postId);
        }

        return exists;
    }

    public void likePost(Long userId, Long postId) {
        // Kiểm tra xem user đã like post này chưa
        if (likeRepository.findByUserIdAndPostId(userId, postId).isPresent()) {
            throw new RuntimeException("Bạn đã thích bài đăng này rồi");
        }

        // Tìm bài đăng
        Post post = postRepository.findById(postId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy bài đăng"));

        // Thêm like
        Like like = new Like();
        like.setUser(new User(userId)); // User giả định đã tồn tại
        like.setPost(post);
        likeRepository.save(like);
        likeRepository.flush();
        // Cập nhật số lượng like
        post.setLikeCount(post.getLikeCount() + 1);
        postRepository.save(post);
    }

    // Toggle like: mỗi tài khoản chỉ được like một lần cho mỗi bài đăng
    public void unlikePost(Long userId, Long postId) {
        // Tìm like
        Like like = likeRepository.findByUserIdAndPostId(userId, postId)
                .orElseThrow(() -> new RuntimeException("Bạn chưa thích bài đăng này"));

        // Xóa like
        likeRepository.delete(like);
        likeRepository.flush();
        // Tìm bài đăng
        Post post = postRepository.findById(postId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy bài đăng"));

        // Cập nhật số lượng like
        if (post.getLikeCount() > 0) {
            post.setLikeCount(post.getLikeCount() - 1);
            postRepository.save(post);
        }
    }
}

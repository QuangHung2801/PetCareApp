package com.example.pet_app_service.controller;

import com.example.pet_app_service.entity.PetProfile;
import com.example.pet_app_service.entity.Post;
import com.example.pet_app_service.entity.User;
import com.example.pet_app_service.repository.PostRepository;
import com.example.pet_app_service.service.PetProfileService;
import com.example.pet_app_service.service.PostService;
import com.example.pet_app_service.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/posts")
public class PostController {
    private final String UPLOAD_DIR = "src/main/resources/static/update/img/pets/";
    private final PostService postService;
    private final UserService userService;
    private final PetProfileService petProfileService;

    @Autowired
    private PostRepository postRepository;

    public PostController(PostService postService, UserService userService, PetProfileService petProfileService) {
        this.postService = postService;
        this.userService = userService;
        this.petProfileService = petProfileService;
    }

    @PostMapping("/{userId}")
    public ResponseEntity<List<Post>> createPost(@RequestParam("content") String content,
                                                 @RequestParam("petId") Long petId,
                                                 @RequestParam("images") List<MultipartFile> images,
                                                 @PathVariable Long userId) throws IOException {
        // Lấy thú cưng và người dùng
        List<PetProfile> pets = petProfileService.getPetProfilesByUserId(userId);
        User user = userService.findById(userId);

        List<Post> posts = new ArrayList<>();
        // Tạo một bài đăng cho mỗi thú cưng
        for (PetProfile pet : pets) {
            Post post = new Post();
            post.setTitle("Bài đăng của thú cưng: " + pet.getName());
            post.setContent(content);
            post.setUser(user);
            post.setPetProfile(pet);

            // Lưu nhiều ảnh
            List<String> imageUrls = new ArrayList<>();
            for (MultipartFile image : images) {
                String imageUrl = saveImage(image); // Lưu ảnh và nhận tên tệp
                imageUrls.add(imageUrl);
            }
            post.setImageUrls(imageUrls); // Sửa lại đây để lưu danh sách tên ảnh vào bài đăng

            // Lưu bài đăng vào cơ sở dữ liệu
            postService.savePost(post);
            posts.add(post); // Thêm bài đăng vào danh sách
        }

        return ResponseEntity.ok(posts); // Trả về danh sách bài đăng đã được tạo
    }

    // Hiển thị tất cả bài đăng
    @GetMapping
    public ResponseEntity<List<Post>> getAllPosts() {
        List<Post> posts = postRepository.findAllPostsWithUsernames();
        for (Post post : posts) {
            post.getUser().setName(post.getUser().getName());
        }

        posts.forEach(post -> {
            System.out.println("Post ID: " + post.getId());
            System.out.println("Post Title: " + post.getTitle());
            System.out.println("Post Content: " + post.getContent());
            System.out.println("User Name: " + post.getUser().getName());
            System.out.println("User Email: " + post.getUser().getEmail());
            System.out.println("-----------------------------");
        });

        return ResponseEntity.ok(posts);

    }

    @GetMapping("/{userid}")
    public ResponseEntity<List<Post>> getPostsByUserId(@PathVariable Long userid) {
        List<Post> posts = postRepository.findByUserId(userid); // Giả sử bạn có phương thức này trong repository
        if (!posts.isEmpty()) {
            return ResponseEntity.ok(posts);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    // Phương thức để lưu hình ảnh
    private String saveImage(MultipartFile image) throws IOException {
        if (image.isEmpty()) {
            return null;
        }
        // Tạo tên tệp tin duy nhất
        String filename = System.currentTimeMillis() + "_" + image.getOriginalFilename();
        Path filePath = Paths.get(UPLOAD_DIR, filename);

        // Đảm bảo thư mục upload tồn tại
        Files.createDirectories(filePath.getParent());
        // Lưu tệp tin
        Files.write(filePath, image.getBytes());

        return filename; // Trả về tên tệp tin để lưu vào database
    }
}

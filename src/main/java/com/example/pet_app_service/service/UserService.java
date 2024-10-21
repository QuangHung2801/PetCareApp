package com.example.pet_app_service.service;

import com.example.pet_app_service.entity.User;
import com.example.pet_app_service.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    public User register(User user) {
        if (userRepository.existsByPhone(user.getPhone()) || userRepository.existsByEmail(user.getEmail())) {
            throw new RuntimeException("Số điện thoại hoặc Email đã tồn tại");
        }
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        return userRepository.save(user);
    }
//fix
public User login(String phone, String password) {
    User user = userRepository.findByPhone(phone)
            .orElseThrow(() -> new RuntimeException("Không tìm thấy người dùng"));
    if (!passwordEncoder.matches(password, user.getPassword())) {
        throw new RuntimeException("Mật khẩu không đúng");
    }
    return user;
}
}

package com.example.pet_app_service.Validtion;

import com.example.pet_app_service.Validtion.ValidUserId;
import com.example.pet_app_service.entity.User;
import com.example.pet_app_service.repository.UserRepository; // Đảm bảo bạn import đúng repository
import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import org.springframework.beans.factory.annotation.Autowired;

public class ValidUserIdValidator implements ConstraintValidator<ValidUserId, Long> {
    @Autowired
    private UserRepository userRepository;

    @Override
    public boolean isValid(Long userId, ConstraintValidatorContext context) {
        if (userId == null) {
            return true; // Trả về true nếu id null
        }
        // Kiểm tra xem id đã tồn tại trong cơ sở dữ liệu chưa
        return userRepository.findById(userId).isPresent();
    }
}

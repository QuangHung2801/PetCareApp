package com.example.pet_app_service.service;

import com.example.pet_app_service.entity.Role;
import com.example.pet_app_service.repository.RoleRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class RoleService {

    @Autowired
    private RoleRepository roleRepository;

    public Role findByName(String name) {
        Role role = roleRepository.findByName(name);
        if (role == null) {
            throw new RuntimeException("Role not found: " + name);  // Ném lỗi nếu không tìm thấy
        }
        return role;
    }
}
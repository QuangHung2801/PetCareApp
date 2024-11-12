package com.example.pet_app_service.service;

import com.example.pet_app_service.entity.PartnerInfo;
import com.example.pet_app_service.entity.Role;
import com.example.pet_app_service.entity.User;
import com.example.pet_app_service.repository.PartnerInfoRepository;
import com.example.pet_app_service.repository.RoleRepository;
import com.example.pet_app_service.repository.UserRepository;
import jakarta.annotation.PostConstruct;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

@Service
public class UserService{

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PartnerInfoRepository partnerInfoRepository;

    @Autowired
    private RoleRepository roleRepository;

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
    public User findById(Long userId) {
        return userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
    }

    @Transactional
    public User findByPhone(String phone) {
        return userRepository.findByPhone(phone)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy người dùng"));
    }

    @Transactional
    private void createDefaultRoles() {
        if (roleRepository.findByName("USER") == null) {
            Role userRole = new Role();
            userRole.setName("USER");
            roleRepository.save(userRole);
        }

        if (roleRepository.findByName("ADMIN") == null) {
            Role adminRole = new Role();
            adminRole.setName("ADMIN");
            roleRepository.save(adminRole);
        }

        if (roleRepository.findByName("PARTNER") == null) {
            Role partnerRole = new Role();
            partnerRole.setName("PARTNER");
            roleRepository.save(partnerRole);
        }
    }

    @Transactional
    public void createAdminUser() {
        if (userRepository.findByPhone("admin").isEmpty()) {
            User adminUser = new User();
            adminUser.setPhone("admin");
            adminUser.setPassword(passwordEncoder.encode("123"));
            adminUser.setName("Admin User");

            Role adminRole = roleRepository.findByName("ADMIN");
            if (adminRole == null) {
                throw new RuntimeException("Role not found: ADMIN");
            }
            Set<Role> adminRoles = new HashSet<>();
            adminRoles.add(adminRole);
            adminUser.setRoles(adminRoles);
            userRepository.save(adminUser);
        }
    }



    @PostConstruct
    public void init() {

        createDefaultRoles();
        createAdminUser();
    }
}

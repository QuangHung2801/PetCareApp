package com.example.pet_app_service.controller;

import com.example.pet_app_service.entity.PartnerInfo;
import com.example.pet_app_service.entity.PartnerService;
import com.example.pet_app_service.entity.Role;
import com.example.pet_app_service.entity.User;
import com.example.pet_app_service.repository.PartnerInfoRepository;
import com.example.pet_app_service.repository.PartnerServiceRepository;
import com.example.pet_app_service.repository.RoleRepository;
import com.example.pet_app_service.service.PartnerInfoService;
import com.example.pet_app_service.repository.UserRepository;
import com.example.pet_app_service.service.PartnerSearchService;
import com.example.pet_app_service.service.ServiceType;
import com.example.pet_app_service.service.UserService;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalTime;
import java.util.*;

@RestController
@RequestMapping("/api/partner")
public class PartnerInfoController {

    private final String UPLOAD_DIR = "src/main/resources/static/update/img/partners/";

    @Autowired
    private PartnerInfoService partnerInfoService;

    @Autowired
    private RoleRepository roleRepository;

    @Autowired
    private UserService userService;

    @Autowired
    private PartnerSearchService partnerSearchService;

    @Autowired
    private PartnerInfoService partnerService;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PartnerServiceRepository partnerServiceRepository;

    @Autowired
    private PartnerInfoRepository partnerInfoRepository;

    @PostMapping("/register")
    public ResponseEntity<?> registerPartner(
            @RequestParam Long userId,
            @RequestParam(required = false) MultipartFile image,
            @RequestParam String businessLicense,
            @RequestParam String businessName,
            @RequestParam String businessCode,
            @RequestParam String address,
            @RequestParam("openingTime") @DateTimeFormat(pattern = "HH:mm") LocalTime openingTime,
            @RequestParam("closingTime") @DateTimeFormat(pattern = "HH:mm") LocalTime closingTime,
            @RequestParam String serviceCategory,
            @RequestParam String services,
            @RequestParam String servicePrices) { // Chuyển 'services' thành tham số hợp lệ

        Set<String> selectedServices = new HashSet<>(Arrays.asList(services.split(",")));
        Map<String, Double> servicePriceMap = parseServicePrices(servicePrices);
        // Chuyển đổi serviceCategory sang enum
        PartnerInfo.ServiceCategory category;
        try {
            category = PartnerInfo.ServiceCategory.valueOf(serviceCategory);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body("Invalid service category");
        }

        PartnerInfo partnerInfo = new PartnerInfo();
        partnerInfo.setBusinessLicense(businessLicense);
        partnerInfo.setBusinessName(businessName);
        partnerInfo.setBusinessCode(businessCode);
        partnerInfo.setAddress(address);
        partnerInfo.setOpeningTime(openingTime);
        partnerInfo.setClosingTime(closingTime);
        partnerInfo.setServiceCategory(category);

        // Lấy người dùng từ cơ sở dữ liệu
        Optional<User> userOpt = userRepository.findById(userId);
        if (userOpt.isEmpty()) {
            return ResponseEntity.badRequest().body("User not found");
        }

        User user = userOpt.get();
        partnerInfo.setUser(user);

        // Chuyển đổi các dịch vụ đã chọn từ String sang ServiceType
        Set<ServiceType> serviceSet = new HashSet<>();
        for (String service : selectedServices) {
            try {
                ServiceType serviceType = ServiceType.valueOf(service);
                serviceSet.add(serviceType);
            } catch (IllegalArgumentException e) {
                return ResponseEntity.badRequest().body("Invalid service selected: " + service);
            }
        }

        Set<PartnerService> partnerServices = new HashSet<>();
        for (String service : selectedServices) {
            try {
                ServiceType serviceType = ServiceType.valueOf(service);
                Double price = servicePriceMap.get(service);

                if (price == null) {
                    return ResponseEntity.badRequest().body("Price for service " + service + " is missing.");
                }

                PartnerService partnerService = new PartnerService();
                partnerService.setServiceType(serviceType);
                partnerService.setPrice(price);
                partnerService.setPartner(partnerInfo);
                partnerServices.add(partnerService);
            } catch (IllegalArgumentException e) {
                return ResponseEntity.badRequest().body("Invalid service selected: " + service);
            }
        }

        partnerInfo.setPartnerServices(partnerServices);
        System.out.println("Danh sách dịch vụ sẽ được lưu:");
        for (ServiceType service : serviceSet) {
            System.out.println(service);
        }
        System.out.println(serviceSet);
        partnerInfo.setServices(serviceSet);

        // Lưu ảnh nếu có
        if (image != null && !image.isEmpty()) {
            String imageUrl = saveImage(image);
            partnerInfo.setImageUrl(imageUrl);
        }

        PartnerInfo registeredPartner = partnerInfoService.registerPartner(partnerInfo);
        return ResponseEntity.ok("Registration submitted. Waiting for approval.");
    }

    // Phương thức để phân tích giá dịch vụ từ chuỗi servicePrices
    private Map<String, Double> parseServicePrices(String servicePrices) {
        Map<String, Double> servicePriceMap = new HashMap<>();
        try {
            ObjectMapper objectMapper = new ObjectMapper();
            // Phân tích chuỗi JSON thành Map<String, String>
            Map<String, String> priceMap = objectMapper.readValue(servicePrices, Map.class);

            // Chuyển đổi các giá trị từ String sang Double
            for (Map.Entry<String, String> entry : priceMap.entrySet()) {
                String service = entry.getKey();
                String priceStr = entry.getValue();
                try {
                    Double priceValue = Double.valueOf(priceStr); // Ép kiểu String thành Double
                    servicePriceMap.put(service, priceValue);
                } catch (NumberFormatException e) {
                    // Nếu không thể chuyển đổi giá trị thành Double, bỏ qua hoặc xử lý lỗi
                    e.printStackTrace();
                }
            }
        } catch (Exception e) {
            // Xử lý lỗi phân tích JSON
            e.printStackTrace();
        }
        return servicePriceMap;
    }

    @PutMapping("/approve/{id}")
    public ResponseEntity<?> approvePartner(@PathVariable Long id) {
        Optional<PartnerInfo> partnerOpt = partnerInfoService.findById(id);

        if (partnerOpt.isPresent()) {
            PartnerInfo partnerInfo = partnerOpt.get();

            // Thay đổi trạng thái đối tác thành đã được duyệt
            partnerInfoService.approvePartner(partnerInfo);

            // Thay đổi vai trò người dùng từ user thành partner
            User user = partnerInfo.getUser();
            if (user != null) {
                // Lấy vai trò cũ (nếu có) và xóa nó
                Set<Role> currentRoles = user.getRoles();

                // Tìm và xóa vai trò "USER" (hoặc vai trò khác nếu cần)
                currentRoles.removeIf(role -> role.getName().equals("USER"));

                // Tạo vai trò "partner" nếu chưa có trong cơ sở dữ liệu
                Role partnerRole = roleRepository.findByName("PARTNER");
                if (partnerRole == null) {
                    partnerRole = new Role("PARTNER");
                    roleRepository.save(partnerRole);
                }

                // Thêm vai trò "PARTNER"
                currentRoles.add(partnerRole);
                user.setRoles(currentRoles);
                userRepository.save(user);  // Lưu lại thay đổi vào cơ sở dữ liệu.
            }

            return ResponseEntity.ok("Partner approved and role updated successfully.");
        }
        return ResponseEntity.badRequest().body("Partner not found");
    }

    @DeleteMapping("/delete/{id}")
    public ResponseEntity<?> deletePartner(@PathVariable Long id) {
        Optional<PartnerInfo> partnerOpt = partnerInfoService.findById(id);
        if (partnerOpt.isEmpty()) {
            return ResponseEntity.badRequest().body("Partner not found");
        }

        PartnerInfo partnerInfo = partnerOpt.get();
        partnerInfoService.deletePartner(partnerInfo);

        return ResponseEntity.ok("Partner account deleted, user remains.");
    }

    @GetMapping("/pending")
    public ResponseEntity<List<PartnerInfo>> getPendingPartners() {
        List<PartnerInfo> pendingPartners = partnerInfoService.getPendingPartners();
        return ResponseEntity.ok(pendingPartners);
    }

    @GetMapping("/status/pending")
    public ResponseEntity<?> getPending() {
        List<PartnerInfo> pendingPartners = partnerInfoService.getPendingPartners();
        List<Map<String, Object>> responseList = new ArrayList<>();
        for (PartnerInfo partner : pendingPartners) {
            Map<String, Object> response = new HashMap<>();
            response.put("userId", partner.getUser().getId());  // Bao gồm userId trong response
            response.put("businessName", partner.getBusinessName());
            response.put("status", partner.getStatus());
            // Các trường khác...
            responseList.add(response);
        }
        return ResponseEntity.ok(responseList);
    }

    private String saveImage(MultipartFile image) {
        try {
            String fileName = System.currentTimeMillis() + "_" + image.getOriginalFilename();
            Path filePath = Paths.get(UPLOAD_DIR, fileName);

            // Tạo thư mục nếu chưa có
            Files.createDirectories(filePath.getParent());
            Files.write(filePath, image.getBytes());

            return fileName;
        } catch (IOException e) {
            throw new RuntimeException("Failed to save image: " + e.getMessage());
        }
    }

    @GetMapping("show/{userId}")
    public ResponseEntity<Map<String, Object>> getPartnerInfo(@PathVariable Long userId) {
        try {
            // Lấy thông tin PartnerInfo từ service
            PartnerInfo partnerInfo = partnerInfoService.getPartnerInfoByUserId(userId);

            if (partnerInfo != null) {
                // Lấy thông tin user từ bảng user
                User user = userService.findById(userId);

                if (user != null) {
                    // Tạo Map để chứa kết hợp thông tin từ PartnerInfo và User
                    Map<String, Object> response = new HashMap<>();
                    response.put("businessName", partnerInfo.getBusinessName());
                    response.put("businessCode", partnerInfo.getBusinessCode());
                    response.put("businessLicense", partnerInfo.getBusinessLicense());
                    response.put("address", partnerInfo.getAddress());
                    response.put("phone", user.getPhone());
                    response.put("email", user.getEmail());
                    response.put("imageUrl", partnerInfo.getImageUrl());
                    response.put("serviceCategory", partnerInfo.getServiceCategory());
                    response.put("services", getServiceDetails(partnerInfo));

                    return ResponseEntity.ok(response);  // Trả về thông tin trong Map
                } else {
                    return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);  // Nếu không tìm thấy user
                }
            } else {
                // Trả về 404 nếu không tìm thấy PartnerInfo
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
            }
        } catch (Exception e) {
            // Trả về 500 Internal Server Error nếu có ngoại lệ
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }
    private List<Map<String, Object>> getServiceDetails(PartnerInfo partnerInfo) {
        List<Map<String, Object>> services = new ArrayList<>();

        for (PartnerService partnerService : partnerInfo.getPartnerServices()) {
            Map<String, Object> service = new HashMap<>();
            service.put("serviceCode", partnerService.getServiceType());
            service.put("price", partnerService.getPrice());
            services.add(service);
        }

        return services;
    }
    // API cập nhật thông tin đối tác
    @PutMapping("/{id}")
    public ResponseEntity<PartnerInfo> updatePartnerInfo(@PathVariable Long id, @RequestBody PartnerInfo partnerInfo) {
        PartnerInfo updatedInfo = partnerInfoService.updatePartnerInfo(id, partnerInfo);
        if (updatedInfo != null) {
            return ResponseEntity.ok(updatedInfo);
        } else {
            return ResponseEntity.badRequest().build();
        }
    }

    @PutMapping("/update-partner-info/{userId}")
    public ResponseEntity<?> updatePartnerInfo(@PathVariable Long userId, @RequestBody Map<String, Object> updates) {
        PartnerInfo partnerInfo = partnerInfoService.getPartnerInfoByUserId(userId);

        if (partnerInfo == null) {
            return ResponseEntity.notFound().build();  // Trả về khi không tìm thấy đối tác
        }

        // Cập nhật thông tin đối tác
        partnerInfo.setAddress((String) updates.get("address"));
        partnerInfo.setBusinessName((String) updates.get("businessName"));
        partnerInfo.setBusinessCode((String) updates.get("businessCode"));
        partnerInfo.setBusinessLicense((String) updates.get("businessLicense"));

        // Cập nhật thông tin người dùng
        User user = partnerInfo.getUser();
        user.setPhone((String) updates.get("phone"));
        user.setEmail((String) updates.get("email"));

        // Cập nhật các dịch vụ và giá tiền
        List<Map<String, Object>> serviceUpdates = (List<Map<String, Object>>) updates.get("services");

        if (serviceUpdates != null) {
            // Danh sách mã dịch vụ gửi từ frontend
            List<String> updatedServiceCodes = serviceUpdates.stream()
                    .map(service -> (String) service.get("serviceCode"))
                    .toList();

            // Xóa các dịch vụ không có trong danh sách mới
            List<PartnerService> existingServices = partnerServiceRepository.findByPartner(partnerInfo);
            for (PartnerService existingService : existingServices) {
                if (!updatedServiceCodes.contains(existingService.getServiceType().name())) {
                    partnerServiceRepository.delete(existingService); // Xóa dịch vụ
                }
            }
            // Cập nhật hoặc tạo mới các dịch vụ với giá trị mới
            for (Map<String, Object> serviceUpdate : serviceUpdates) {
                String serviceCode = (String) serviceUpdate.get("serviceCode");
                Double price = serviceUpdate.get("price") != null ? Double.valueOf(serviceUpdate.get("price").toString()) : 0.0;



                // Tìm dịch vụ tương ứng trong bảng PartnerService
                Optional<PartnerService> existingService = partnerServiceRepository.findByPartnerAndServiceType(partnerInfo, ServiceType.valueOf(serviceCode));
                if (existingService.isPresent()) {
                    PartnerService partnerService = existingService.get();
                    partnerService.setPrice(price);
                    partnerServiceRepository.save(partnerService);
                } else {
                    // Nếu dịch vụ chưa tồn tại, tạo mới và lưu vào bảng PartnerService
                    PartnerService partnerService = new PartnerService();
                    partnerService.setPartner(partnerInfo);
                    partnerService.setServiceType(ServiceType.valueOf(serviceCode));
                    partnerService.setPrice(price);
                    partnerServiceRepository.save(partnerService);
                }
            }
        }

        userRepository.save(user);
        partnerInfoService.updatePartnerInfo(partnerInfo.getId(), partnerInfo);

        return ResponseEntity.ok().build();
    }


    @GetMapping("/nearby")
    public ResponseEntity<List<PartnerInfo>> findNearbyPartners(
            @RequestParam double latitude,
            @RequestParam double longitude,
            @RequestParam(required = false) List<PartnerInfo.ServiceCategory> category) {

        List<PartnerInfo> partners = category != null && !category.isEmpty()
                ? partnerSearchService.getNearbyPartnersWithCategory(latitude, longitude, category)
                : partnerSearchService.getNearbyPartners(latitude, longitude);

        return ResponseEntity.ok(partners);
    }

    // Đóng cửa sớm
    @PostMapping("/closeServiceEarly/{userId}")
    public ResponseEntity<String> closeServiceEarly(@PathVariable Long userId) {
        partnerInfoService.closeServiceEarly(userId);
        return ResponseEntity.ok("Service closed early");
    }

    // Mở lại dịch vụ
    @PostMapping("/reopenService/{userId}")
    public ResponseEntity<String> reopenService(@PathVariable Long userId) {
        partnerInfoService.reopenService(userId);
        return ResponseEntity.ok("Service reopened");
    }

    @GetMapping("/serviceStatus/{userId}")
    public ResponseEntity<Map<String, Object>> getServiceStatus(@PathVariable Long userId) {
        // Lấy thông tin đối tác từ cơ sở dữ liệu dựa trên userId
        Optional<PartnerInfo> partnerInfoOptional = partnerInfoRepository.findByUserId(userId);



        PartnerInfo partnerInfo = partnerInfoOptional.get();
        partnerInfo.updateIsOpenStatus(); // Cập nhật trạng thái cửa hàng trước khi trả về

        Map<String, Object> response = new HashMap<>();
        response.put("isOpen", partnerInfo.getIsOpen()); // Lấy giá trị isOpen
        return ResponseEntity.ok(response);
    }
}

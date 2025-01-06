package com.example.pet_app_service.service;

import com.example.pet_app_service.entity.PartnerInfo;
import com.example.pet_app_service.entity.PartnerService;
import com.example.pet_app_service.repository.PartnerInfoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.stream.Collectors;

@Service
public class PartnerInfoService {

    @Autowired
    private GeoLocationService geoLocationService;

    @Autowired
    private PartnerInfoRepository partnerInfoRepository;

    // Đăng ký đối tác
    public PartnerInfo registerPartner(PartnerInfo partnerInfo) {
        Map<String, Double> coordinates = geoLocationService.getCoordinates(partnerInfo.getAddress());
        partnerInfo.setLatitude(coordinates.get("latitude"));
        partnerInfo.setLongitude(coordinates.get("longitude"));
        return partnerInfoRepository.save(partnerInfo);
    }

    // Duyệt đối tác
    public void approvePartner(PartnerInfo partnerInfo) {
        partnerInfo.setStatus(PartnerInfo.PartnerStatus.APPROVED);
        partnerInfoRepository.save(partnerInfo);
    }

    // Xóa đối tác (chỉ giữ lại User)
    public void deletePartner(PartnerInfo partnerInfo) {
        partnerInfo.setUser(null); // Giữ lại User nhưng không liên kết với PartnerInfo nữa
        partnerInfo.setStatus(PartnerInfo.PartnerStatus.REJECTED);// Thay đổi trạng thái thành "REJECTED"
        partnerInfoRepository.delete(partnerInfo);
        partnerInfoRepository.save(partnerInfo);
    }

    // Lấy danh sách đối tác đang chờ duyệt
    public List<PartnerInfo> getPendingPartners() {
        return partnerInfoRepository.findByStatus(PartnerInfo.PartnerStatus.PENDING);
    }

    // Tìm đối tác theo ID
    public Optional<PartnerInfo> findById(Long id) {
        return partnerInfoRepository.findById(id);
    }
    public PartnerInfo getPartnerInfoByUserId(Long userId) {
        return partnerInfoRepository.findByUser_Id(userId);
    }

    public PartnerInfo updatePartnerInfo(Long id, PartnerInfo updatedInfo) {
        Optional<PartnerInfo> existingInfo = partnerInfoRepository.findById(id);
        if (existingInfo.isPresent()) {
            PartnerInfo partnerInfo = existingInfo.get();
            partnerInfo.setBusinessName(updatedInfo.getBusinessName());
            partnerInfo.setBusinessCode(updatedInfo.getBusinessCode());
            partnerInfo.setAddress(updatedInfo.getAddress());
            partnerInfo.setServices(updatedInfo.getServices());
            return partnerInfoRepository.save(partnerInfo);
        }
        return null;
    }

    public void closeServiceEarly(Long userId) {
        PartnerInfo partnerInfo = partnerInfoRepository.findByUser_Id(userId);
        if (partnerInfo != null) {
            partnerInfo.closeServiceEarly();
            partnerInfoRepository.save(partnerInfo);
        } else {
            // Xử lý khi không tìm thấy đối tác
            System.out.println("Partner not found with userId: " + userId);
        }
    }

    public void reopenService(Long userId) {
        PartnerInfo partnerInfo = partnerInfoRepository.findByUser_Id(userId);
        if (partnerInfo != null) {
            partnerInfo.reopenService();
            partnerInfoRepository.save(partnerInfo);
        } else {
            // Xử lý khi không tìm thấy đối tác
            System.out.println("Partner not found with id: " + userId);
        }
    }

    public Boolean getServiceStatus(Long userId) {
        Optional<PartnerInfo> partnerInfo = partnerInfoRepository.findByUserId(userId);
        if (partnerInfo.isPresent()) {
            return partnerInfo.get().getIsOpen(); // Return the service status (true or false)
        }
        return false; // Default if partner info not found
    }
}

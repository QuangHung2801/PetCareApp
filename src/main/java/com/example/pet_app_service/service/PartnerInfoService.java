package com.example.pet_app_service.service;

import com.example.pet_app_service.entity.PartnerInfo;
import com.example.pet_app_service.repository.PartnerInfoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class PartnerInfoService {

    @Autowired
    private PartnerInfoRepository partnerInfoRepository;

    // Đăng ký đối tác
    public PartnerInfo registerPartner(PartnerInfo partnerInfo) {
        partnerInfo.setAvailableServicesByCategory();
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
}
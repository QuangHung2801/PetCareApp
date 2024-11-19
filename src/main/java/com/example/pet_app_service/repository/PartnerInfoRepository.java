package com.example.pet_app_service.repository;

import com.example.pet_app_service.entity.PartnerInfo;
import com.example.pet_app_service.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface PartnerInfoRepository extends JpaRepository<PartnerInfo, Long> {
    Optional<PartnerInfo> findByUser(User user);
    List<PartnerInfo> findByStatus(PartnerInfo.PartnerStatus status);
    PartnerInfo findByUser_Id(Long userId);
    List<PartnerInfo> findByServiceCategoryAndStatus(
            PartnerInfo.ServiceCategory serviceCategory,
            PartnerInfo.PartnerStatus status);

    List<PartnerInfo> findByServiceCategoryAndStatusAndBusinessNameContainingIgnoreCase(
            PartnerInfo.ServiceCategory serviceCategory,
            PartnerInfo.PartnerStatus status,
            String businessName);

    PartnerInfo findByBusinessNameAndStatus(String businessName, PartnerInfo.PartnerStatus status);
    Optional<PartnerInfo> findByUserId(Long userId);
}

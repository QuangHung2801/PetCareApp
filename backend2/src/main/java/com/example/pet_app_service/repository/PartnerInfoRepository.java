package com.example.pet_app_service.repository;

import com.example.pet_app_service.entity.PartnerInfo;
import com.example.pet_app_service.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
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

    @Query("SELECT p FROM PartnerInfo p WHERE " +
            "(6371 * acos(cos(radians(:latitude)) * cos(radians(p.latitude)) * " +
            "cos(radians(p.longitude) - radians(:longitude)) + " +
            "sin(radians(:latitude)) * sin(radians(p.latitude)))) < :radius " +
            "ORDER BY (6371 * acos(cos(radians(:latitude)) * cos(radians(p.latitude)) * " +
            "cos(radians(p.longitude) - radians(:longitude)) + " +
            "sin(radians(:latitude)) * sin(radians(p.latitude)))) ASC")
    List<PartnerInfo> findNearbyPartners(@Param("latitude") double latitude,
                                         @Param("longitude") double longitude,
                                         @Param("radius") double radius);

    @Query("SELECT p FROM PartnerInfo p WHERE " +
            "p.serviceCategory IN :categories AND " +
            "(6371 * acos(cos(radians(:latitude)) * cos(radians(p.latitude)) * " +
            "cos(radians(p.longitude) - radians(:longitude)) + " +
            "sin(radians(:latitude)) * sin(radians(p.latitude)))) < :radius " +
            "ORDER BY (6371 * acos(cos(radians(:latitude)) * cos(radians(p.latitude)) * " +
            "cos(radians(p.longitude) - radians(:longitude)) + " +
            "sin(radians(:latitude)) * sin(radians(p.latitude)))) ASC")
    List<PartnerInfo> findNearbyPartnersWithCategory(@Param("latitude") double latitude,
                                                     @Param("longitude") double longitude,
                                                     @Param("radius") double radius,
                                                     @Param("categories") List<PartnerInfo.ServiceCategory> categories);

}

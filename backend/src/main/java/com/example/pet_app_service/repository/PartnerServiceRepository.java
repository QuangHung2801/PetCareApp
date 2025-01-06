package com.example.pet_app_service.repository;

import com.example.pet_app_service.entity.PartnerInfo;
import com.example.pet_app_service.entity.PartnerService;
import com.example.pet_app_service.service.ServiceType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface PartnerServiceRepository extends JpaRepository<PartnerService, Long> {
    List<PartnerService> findByPartner(PartnerInfo partner);
    Optional<PartnerService> findByPartnerAndServiceType(PartnerInfo partner, ServiceType serviceType);
}

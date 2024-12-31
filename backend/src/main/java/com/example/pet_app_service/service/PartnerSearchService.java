package com.example.pet_app_service.service;

import com.example.pet_app_service.entity.PartnerInfo;
import com.example.pet_app_service.repository.PartnerInfoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class PartnerSearchService {

    @Autowired
    private PartnerInfoRepository partnerInfoRepository;

    public List<PartnerInfo> getNearbyPartners(double latitude, double longitude) {
        double radius = 8;
        return partnerInfoRepository.findNearbyPartners(latitude, longitude, radius);
    }

    public List<PartnerInfo> getNearbyPartnersWithCategory(double latitude, double longitude, List<PartnerInfo.ServiceCategory> categories) {
        double radius = 8;
        return partnerInfoRepository.findNearbyPartnersWithCategory(latitude, longitude, radius, categories);
    }
}

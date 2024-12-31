package com.example.pet_app_service.service;


public enum ServiceType {
    // Dịch vụ chăm sóc thú cưng
    PET_BOARDING("Trông giữ thú cưng"),
    PET_SPA("Spa cho thú cưng"),
    PET_GROOMING("Tắm và cắt tỉa lông"),
    PET_WALKING("Dắt thú cưng đi dạo"),

    // Dịch vụ phòng khám thú y
    VETERINARY_EXAMINATION("Khám chữa bệnh"),
    VACCINATION("Tiêm phòng"),
    SURGERY("Phẫu thuật"),
    REGULAR_CHECKUP("Khám định kỳ");

    private final String displayName;

    ServiceType(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }
}


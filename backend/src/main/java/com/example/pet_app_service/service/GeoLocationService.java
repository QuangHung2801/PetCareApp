package com.example.pet_app_service.service;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class GeoLocationService {
    private static final String NOMINATIM_API_URL =
            "https://nominatim.openstreetmap.org/search?q={address}&format=json";

    public Map<String, Double> getCoordinates(String address) {
        RestTemplate restTemplate = new RestTemplate();
        Map<String, String> params = new HashMap<>();
        params.put("address", address);

        ResponseEntity<List> response = restTemplate.getForEntity(NOMINATIM_API_URL, List.class, params);

        if (response.getBody() != null && !response.getBody().isEmpty()) {
            Map location = (Map) response.getBody().get(0);
            Double lat = Double.valueOf(location.get("lat").toString());
            Double lon = Double.valueOf(location.get("lon").toString());

            Map<String, Double> coordinates = new HashMap<>();
            coordinates.put("latitude", lat);
            coordinates.put("longitude", lon);
            return coordinates;
        } else {
            throw new RuntimeException("Unable to get coordinates for the address: " + address);
        }
    }
}

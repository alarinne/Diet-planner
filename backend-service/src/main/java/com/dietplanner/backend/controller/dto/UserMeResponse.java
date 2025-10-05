package com.dietplanner.backend.controller.dto;

public class UserMeResponse {
    public Long id;
    public String email;
    public String role;

    public UserMeResponse(Long id, String email, String role) {
        this.id = id; this.email = email; this.role = role;
    }
}

package com.dietplanner.backend.controller;

import com.dietplanner.backend.controller.dto.RegisterRequest;
import com.dietplanner.backend.controller.dto.UserMeResponse;
import com.dietplanner.backend.domain.User;
import com.dietplanner.backend.repository.UserRepository;
import com.dietplanner.backend.service.UserService;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final UserService userService;
    private final UserRepository users;

    public AuthController(UserService userService, UserRepository users) {
        this.userService = userService;
        this.users = users;
    }

    @PostMapping("/register")
    public UserMeResponse register(@RequestBody RegisterRequest req) {
        User u = userService.register(req);
        return new UserMeResponse(u.getId(), u.getEmail(), u.getRole().name());
    }

    @GetMapping("/me")
    public UserMeResponse me(@AuthenticationPrincipal UserDetails principal) {
        if (principal == null) return null;
        User u = users.findByEmailIgnoreCase(principal.getUsername()).orElseThrow();
        return new UserMeResponse(u.getId(), u.getEmail(), u.getRole().name());
    }
}

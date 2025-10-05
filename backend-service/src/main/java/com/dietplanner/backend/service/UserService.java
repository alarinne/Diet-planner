package com.dietplanner.backend.service;

import com.dietplanner.backend.controller.dto.RegisterRequest;
import com.dietplanner.backend.domain.User;
import com.dietplanner.backend.domain.UserProfile;
import com.dietplanner.backend.domain.enums.UserRole;
import com.dietplanner.backend.repository.UserProfileRepository;
import com.dietplanner.backend.repository.UserRepository;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class UserService {
    private final UserRepository users;
    private final UserProfileRepository profiles;
    private final PasswordEncoder encoder;

    public UserService(UserRepository users, UserProfileRepository profiles, PasswordEncoder encoder) {
        this.users = users;
        this.profiles = profiles;
        this.encoder = encoder;
    }

    @Transactional
    public User register(RegisterRequest req) {
        if (users.existsByEmailIgnoreCase(req.email)) {
            throw new IllegalArgumentException("Email already used");
        }
        User u = new User();
        u.setEmail(req.email.trim());
        u.setPasswordHash(encoder.encode(req.password));
        u.setRole(UserRole.USER);
        u = users.save(u);

        UserProfile p = new UserProfile();
        p.setUser(u);
        p.setFullName(req.fullName);
        profiles.save(p);

        return u;
    }
}

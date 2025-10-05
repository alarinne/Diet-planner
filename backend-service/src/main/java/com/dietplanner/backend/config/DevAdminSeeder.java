package com.dietplanner.backend.config;

import com.dietplanner.backend.domain.User;
import com.dietplanner.backend.domain.enums.UserRole;
import com.dietplanner.backend.repository.UserRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.password.PasswordEncoder;

@Configuration
public class DevAdminSeeder {

    @Bean
    CommandLineRunner seedAdmin(UserRepository users, PasswordEncoder encoder) {
        return args -> {
            String email = "admin@local";
            if (users.findByEmailIgnoreCase(email).isEmpty()) {
                User u = new User();
                u.setEmail(email);
                u.setPasswordHash(encoder.encode("admin")); // пароль: admin
                u.setRole(UserRole.ADMIN);
                users.save(u);
                System.out.println(">>> Seeded admin user: " + email + " / admin");
            }
        };
    }
}

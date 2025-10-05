package com.dietplanner.backend.repository;

import com.dietplanner.backend.domain.UserProfile;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserProfileRepository extends JpaRepository<UserProfile, Long> {
}

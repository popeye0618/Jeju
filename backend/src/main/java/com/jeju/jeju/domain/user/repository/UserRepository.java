package com.jeju.jeju.domain.user.repository;

import com.jeju.jeju.domain.user.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {

    Optional<User> findByEmail(String email);

    Optional<User> findByNickname(String nickname);

    Optional<User> findByEmailAndProvider(String email, User.Provider provider);

    Optional<User> findByProviderAndProviderId(User.Provider provider, String providerId);

    boolean existsByEmail(String email);

    boolean existsByNickname(String nickname);
}

package com.jeju.jeju.domain.user.service;

import com.jeju.jeju.common.exception.BusinessException;
import com.jeju.jeju.common.exception.ErrorCode;
import com.jeju.jeju.domain.user.dto.OnboardingRequest;
import com.jeju.jeju.domain.user.dto.ProfileUpdateRequest;
import com.jeju.jeju.domain.user.dto.UserProfileResponse;
import com.jeju.jeju.domain.user.dto.WithdrawRequest;
import com.jeju.jeju.domain.user.entity.User;
import com.jeju.jeju.domain.user.repository.UserRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class UserService {

    private final UserRepository userRepository;

    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @Transactional(readOnly = true)
    public void checkNickname(String nickname) {
        if (userRepository.existsByNickname(nickname)) {
            throw new BusinessException(ErrorCode.USER_001);
        }
    }

    public void completeOnboarding(Long userId, OnboardingRequest req) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new BusinessException(ErrorCode.USER_002));

        if (userRepository.existsByNickname(req.nickname())) {
            throw new BusinessException(ErrorCode.USER_001);
        }

        user.completeOnboarding(
                req.companion(),
                req.preference(),
                req.mobility(),
                req.days(),
                req.nickname(),
                req.termsAgreed(),
                req.privacyAgreed()
        );
    }

    @Transactional(readOnly = true)
    public UserProfileResponse getMyProfile(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new BusinessException(ErrorCode.USER_002));

        return new UserProfileResponse(
                user.getId(),
                user.getEmail(),
                user.getNickname(),
                user.getProvider().name(),
                user.getCompanion() != null ? user.getCompanion().name() : null,
                user.getPreference() != null ? user.getPreference().name() : null,
                user.getMobility() != null ? user.getMobility().name() : null,
                0L,
                0L
        );
    }

    public UserProfileResponse updateMyProfile(Long userId, ProfileUpdateRequest req) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new BusinessException(ErrorCode.USER_002));

        if (req.getNickname() != null && !req.getNickname().equals(user.getNickname())
                && userRepository.existsByNickname(req.getNickname())) {
            throw new BusinessException(ErrorCode.USER_001);
        }

        user.updateProfile(req.getNickname(), req.getCompanion(), req.getPreference(), req.getMobility());

        return new UserProfileResponse(
                user.getId(),
                user.getEmail(),
                user.getNickname(),
                user.getProvider().name(),
                user.getCompanion() != null ? user.getCompanion().name() : null,
                user.getPreference() != null ? user.getPreference().name() : null,
                user.getMobility() != null ? user.getMobility().name() : null,
                0L,
                0L
        );
    }

    public void withdraw(Long userId, WithdrawRequest req) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new BusinessException(ErrorCode.USER_002));

        if (req.getReason() != null) {
            try {
                User.WithdrawReason reason = User.WithdrawReason.valueOf(req.getReason());
                user.withdraw(reason);
            } catch (IllegalArgumentException e) {
                user.withdraw(User.WithdrawReason.OTHER);
            }
        } else {
            user.withdraw(null);
        }

        userRepository.delete(user);
    }
}

package com.jeju.jeju.domain.user.service;

import com.jeju.jeju.common.exception.BusinessException;
import com.jeju.jeju.common.exception.ErrorCode;
import com.jeju.jeju.domain.user.dto.OnboardingRequest;
import com.jeju.jeju.domain.user.dto.ProfileUpdateRequest;
import com.jeju.jeju.domain.user.dto.UserProfileResponse;
import com.jeju.jeju.domain.user.dto.WithdrawRequest;
import com.jeju.jeju.domain.user.entity.User;
import com.jeju.jeju.domain.user.repository.UserRepository;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.test.util.ReflectionTestUtils;

import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.BDDMockito.given;
import static org.mockito.Mockito.verify;

@ExtendWith(MockitoExtension.class)
class UserServiceTest {

    @Mock private UserRepository userRepository;

    @InjectMocks
    private UserService userService;

    @Test
    @DisplayName("이미 존재하는 닉네임 체크 시 USER_001 예외")
    void checkNickname_duplicate_throwsUser001() {
        given(userRepository.existsByNickname("dupNick")).willReturn(true);

        assertThatThrownBy(() -> userService.checkNickname("dupNick"))
                .isInstanceOf(BusinessException.class)
                .extracting(e -> ((BusinessException) e).getErrorCode())
                .isEqualTo(ErrorCode.USER_001);
    }

    @Test
    @DisplayName("사용 가능한 닉네임 체크 시 예외 없음")
    void checkNickname_available_noException() {
        given(userRepository.existsByNickname("newNick")).willReturn(false);
        userService.checkNickname("newNick");
    }

    @Test
    @DisplayName("존재하지 않는 사용자 프로필 조회 시 USER_002 예외")
    void getMyProfile_userNotFound_throwsUser002() {
        given(userRepository.findById(999L)).willReturn(Optional.empty());

        assertThatThrownBy(() -> userService.getMyProfile(999L))
                .isInstanceOf(BusinessException.class)
                .extracting(e -> ((BusinessException) e).getErrorCode())
                .isEqualTo(ErrorCode.USER_002);
    }

    @Test
    @DisplayName("프로필 조회 성공")
    void getMyProfile_success() {
        User user = User.ofEmail("test@example.com", "encoded", "testNick");
        ReflectionTestUtils.setField(user, "id", 1L);
        given(userRepository.findById(1L)).willReturn(Optional.of(user));

        UserProfileResponse response = userService.getMyProfile(1L);

        assertThat(response.userId()).isEqualTo(1L);
        assertThat(response.email()).isEqualTo("test@example.com");
        assertThat(response.nickname()).isEqualTo("testNick");
        assertThat(response.savedItineraryCount()).isEqualTo(0L);
        assertThat(response.likedPlaceCount()).isEqualTo(0L);
    }

    @Test
    @DisplayName("온보딩 시 닉네임 중복이면 USER_001 예외")
    void completeOnboarding_duplicateNickname_throwsUser001() {
        User user = User.ofEmail("test@example.com", "encoded", "tempNick");
        ReflectionTestUtils.setField(user, "id", 1L);
        given(userRepository.findById(1L)).willReturn(Optional.of(user));
        given(userRepository.existsByNickname("dupNick")).willReturn(true);

        OnboardingRequest req = new OnboardingRequest(
                User.Companion.SOLO, User.Preference.OUTDOOR, User.Mobility.NORMAL,
                3, "dupNick", true, true);

        assertThatThrownBy(() -> userService.completeOnboarding(1L, req))
                .isInstanceOf(BusinessException.class)
                .extracting(e -> ((BusinessException) e).getErrorCode())
                .isEqualTo(ErrorCode.USER_001);
    }

    @Test
    @DisplayName("프로필 수정 성공")
    void updateMyProfile_success() {
        User user = User.ofEmail("test@example.com", "encoded", "oldNick");
        ReflectionTestUtils.setField(user, "id", 1L);
        given(userRepository.findById(1L)).willReturn(Optional.of(user));
        given(userRepository.existsByNickname("newNick")).willReturn(false);

        ProfileUpdateRequest req = new ProfileUpdateRequest("newNick", null, null, null);
        UserProfileResponse response = userService.updateMyProfile(1L, req);

        assertThat(response.nickname()).isEqualTo("newNick");
    }

    @Test
    @DisplayName("회원 탈퇴 성공")
    void withdraw_success() {
        User user = User.ofEmail("test@example.com", "encoded", "nick");
        ReflectionTestUtils.setField(user, "id", 1L);
        given(userRepository.findById(1L)).willReturn(Optional.of(user));

        userService.withdraw(1L, new WithdrawRequest("OTHER"));

        verify(userRepository).delete(user);
    }
}

package com.jeju.jeju.infrastructure.init;

import com.jeju.jeju.domain.itinerary.entity.Itinerary;
import com.jeju.jeju.domain.itinerary.repository.ItineraryRepository;
import com.jeju.jeju.domain.user.entity.User;
import com.jeju.jeju.domain.user.repository.UserRepository;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 개발 환경 전용 시드 데이터 초기화.
 * RECOMMENDED 타입 일정이 없을 때 샘플 3개를 생성한다.
 */
@Component
@Profile("dev")
public class DevDataInitializer implements ApplicationRunner {

    private final UserRepository userRepository;
    private final ItineraryRepository itineraryRepository;

    public DevDataInitializer(UserRepository userRepository,
                              ItineraryRepository itineraryRepository) {
        this.userRepository = userRepository;
        this.itineraryRepository = itineraryRepository;
    }

    @Override
    @Transactional
    public void run(ApplicationArguments args) {
        if (itineraryRepository.countByType(Itinerary.ItineraryType.RECOMMENDED) > 0) {
            return; // 이미 시드 완료
        }

        // 시스템 계정 생성 (없을 경우)
        User system = userRepository.findByEmail("system@jeju.app")
                .orElseGet(() -> {
                    User u = User.ofEmail("system@jeju.app", "SYSTEM_NO_PASSWORD", "제주시스템");
                    u.verifyEmail();
                    return userRepository.save(u);
                });

        // 샘플 추천 일정 3개
        List<Itinerary> seeds = List.of(
                Itinerary.ofRecommended(
                        system,
                        "성산일출봉 & 섭지코지 코스",
                        2,
                        null,
                        87
                ),
                Itinerary.ofRecommended(
                        system,
                        "비 와도 괜찮은 박물관 투어",
                        1,
                        null,
                        92
                ),
                Itinerary.ofRecommended(
                        system,
                        "한라산 둘레길 무장애 코스",
                        1,
                        null,
                        78
                )
        );

        itineraryRepository.saveAll(seeds);
    }
}

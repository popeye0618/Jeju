package com.jeju.jeju.infrastructure.init;

import com.jeju.jeju.domain.itinerary.entity.Itinerary;
import com.jeju.jeju.domain.itinerary.repository.ItineraryRepository;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 개발 환경 전용 시드 데이터 초기화.
 * RECOMMENDED 타입 공용 추천 일정이 없을 때 샘플 3개를 생성한다.
 * user_id = NULL → 특정 유저에 귀속되지 않는 시스템 추천 코스
 */
@Component
@Profile("dev")
public class DevDataInitializer implements ApplicationRunner {

    private final ItineraryRepository itineraryRepository;

    public DevDataInitializer(ItineraryRepository itineraryRepository) {
        this.itineraryRepository = itineraryRepository;
    }

    @Override
    @Transactional
    public void run(ApplicationArguments args) {
        if (itineraryRepository.countByType(Itinerary.ItineraryType.RECOMMENDED) > 0) {
            return; // 이미 시드 완료
        }

        List<Itinerary> seeds = List.of(
                Itinerary.ofSystemRecommended(
                        "성산일출봉 & 섭지코지 코스",
                        2,
                        null,
                        87
                ),
                Itinerary.ofSystemRecommended(
                        "비 와도 괜찮은 박물관 투어",
                        1,
                        null,
                        92
                ),
                Itinerary.ofSystemRecommended(
                        "한라산 둘레길 무장애 코스",
                        1,
                        null,
                        78
                )
        );

        itineraryRepository.saveAll(seeds);
    }
}

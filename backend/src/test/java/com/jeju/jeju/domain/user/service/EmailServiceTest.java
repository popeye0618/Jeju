package com.jeju.jeju.domain.user.service;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.mail.MailSendException;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.test.util.ReflectionTestUtils;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatCode;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.BDDMockito.willThrow;
import static org.mockito.Mockito.verify;

@ExtendWith(MockitoExtension.class)
class EmailServiceTest {

    @Mock
    private JavaMailSender mailSender;

    private EmailService emailService;

    @BeforeEach
    void setUp() {
        emailService = new EmailService(mailSender);
        ReflectionTestUtils.setField(emailService, "mailFrom", "noreply@jeju.app");
    }

    @Test
    @DisplayName("sendVerificationEmail - 올바른 제목과 수신자로 메일 발송")
    void sendVerificationEmail_sendsCorrectMessage() {
        emailService.sendVerificationEmail("user@example.com", "123456");

        ArgumentCaptor<SimpleMailMessage> captor = ArgumentCaptor.forClass(SimpleMailMessage.class);
        verify(mailSender).send(captor.capture());

        SimpleMailMessage sent = captor.getValue();
        assertThat(sent.getTo()).containsExactly("user@example.com");
        assertThat(sent.getSubject()).isEqualTo("[같이가는 제주] 이메일 인증 코드");
        assertThat(sent.getText()).contains("123456");
        assertThat(sent.getFrom()).isEqualTo("noreply@jeju.app");
    }

    @Test
    @DisplayName("sendPasswordResetEmail - 올바른 제목과 수신자로 메일 발송")
    void sendPasswordResetEmail_sendsCorrectMessage() {
        emailService.sendPasswordResetEmail("user@example.com", "654321");

        ArgumentCaptor<SimpleMailMessage> captor = ArgumentCaptor.forClass(SimpleMailMessage.class);
        verify(mailSender).send(captor.capture());

        SimpleMailMessage sent = captor.getValue();
        assertThat(sent.getTo()).containsExactly("user@example.com");
        assertThat(sent.getSubject()).isEqualTo("[같이가는 제주] 비밀번호 재설정 코드");
        assertThat(sent.getText()).contains("654321");
        assertThat(sent.getFrom()).isEqualTo("noreply@jeju.app");
    }

    @Test
    @DisplayName("sendVerificationEmail - MailException 발생 시 예외 전파 없이 로그만 출력")
    void sendVerificationEmail_mailException_doesNotPropagate() {
        willThrow(new MailSendException("SMTP 연결 실패"))
                .given(mailSender).send(any(SimpleMailMessage.class));

        assertThatCode(() -> emailService.sendVerificationEmail("user@example.com", "123456"))
                .doesNotThrowAnyException();
    }

    @Test
    @DisplayName("sendPasswordResetEmail - MailException 발생 시 예외 전파 없이 로그만 출력")
    void sendPasswordResetEmail_mailException_doesNotPropagate() {
        willThrow(new MailSendException("SMTP 연결 실패"))
                .given(mailSender).send(any(SimpleMailMessage.class));

        assertThatCode(() -> emailService.sendPasswordResetEmail("user@example.com", "654321"))
                .doesNotThrowAnyException();
    }

    @Test
    @DisplayName("sendVerificationEmail - 본문에 10분 유효 안내 문구 포함")
    void sendVerificationEmail_textContainsExpiryNotice() {
        emailService.sendVerificationEmail("user@example.com", "999999");

        ArgumentCaptor<SimpleMailMessage> captor = ArgumentCaptor.forClass(SimpleMailMessage.class);
        verify(mailSender).send(captor.capture());

        assertThat(captor.getValue().getText()).contains("10분간 유효");
    }

    @Test
    @DisplayName("sendPasswordResetEmail - 본문에 10분 유효 안내 문구 포함")
    void sendPasswordResetEmail_textContainsExpiryNotice() {
        emailService.sendPasswordResetEmail("user@example.com", "111111");

        ArgumentCaptor<SimpleMailMessage> captor = ArgumentCaptor.forClass(SimpleMailMessage.class);
        verify(mailSender).send(captor.capture());

        assertThat(captor.getValue().getText()).contains("10분간 유효");
    }
}

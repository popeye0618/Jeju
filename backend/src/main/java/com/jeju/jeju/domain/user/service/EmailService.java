package com.jeju.jeju.domain.user.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.MailException;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
public class EmailService {

    private static final Logger log = LoggerFactory.getLogger(EmailService.class);

    private final JavaMailSender mailSender;

    @Value("${spring.mail.username:noreply@jeju.app}")
    private String mailFrom;

    public EmailService(JavaMailSender mailSender) {
        this.mailSender = mailSender;
    }

    public void sendVerificationEmail(String toEmail, String code) {
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom(mailFrom);
            message.setTo(toEmail);
            message.setSubject("[같이가는 제주] 이메일 인증 코드");
            message.setText(
                    "안녕하세요, 같이가는 제주입니다.\n\n" +
                    "이메일 인증 코드: " + code + "\n\n" +
                    "이 코드는 10분간 유효합니다.\n" +
                    "본인이 요청하지 않은 경우 이 메일을 무시하세요."
            );
            mailSender.send(message);
        } catch (MailException e) {
            log.error("이메일 인증 코드 발송 실패 - to: {}, error: {}", toEmail, e.getMessage());
        }
    }

    public void sendPasswordResetEmail(String toEmail, String code) {
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom(mailFrom);
            message.setTo(toEmail);
            message.setSubject("[같이가는 제주] 비밀번호 재설정 코드");
            message.setText(
                    "안녕하세요, 같이가는 제주입니다.\n\n" +
                    "비밀번호 재설정 코드: " + code + "\n\n" +
                    "이 코드는 10분간 유효합니다.\n" +
                    "본인이 요청하지 않은 경우 이 메일을 무시하세요."
            );
            mailSender.send(message);
        } catch (MailException e) {
            log.error("비밀번호 재설정 이메일 발송 실패 - to: {}, error: {}", toEmail, e.getMessage());
        }
    }
}

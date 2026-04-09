package com.jeju.jeju.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class MailConfig {

    @Bean
    public String mailFrom(@Value("${spring.mail.username:}") String mailUsername) {
        return mailUsername;
    }
}

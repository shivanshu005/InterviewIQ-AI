package ai.interviewiq.api;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import ai.interviewiq.api.config.AiProperties;
import org.springframework.boot.autoconfigure.security.servlet.UserDetailsServiceAutoConfiguration;

@SpringBootApplication(exclude = UserDetailsServiceAutoConfiguration.class)
@EnableConfigurationProperties(AiProperties.class)
public class InterviewIqApiApplication {
    public static void main(String[] args) {
        SpringApplication.run(InterviewIqApiApplication.class, args);
    }
}

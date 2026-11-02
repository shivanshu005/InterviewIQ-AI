package ai.interviewiq.api.config;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "interviewiq.ai")
public record AiProperties(String provider, String apiKey, String model, int timeoutSeconds, int maxAttempts) { }

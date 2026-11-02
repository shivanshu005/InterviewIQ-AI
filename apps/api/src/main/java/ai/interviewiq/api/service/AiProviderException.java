package ai.interviewiq.api.service;

public class AiProviderException extends RuntimeException {
    public AiProviderException(String message) { super(message); }
    public AiProviderException(String message, Throwable cause) { super(message, cause); }
}

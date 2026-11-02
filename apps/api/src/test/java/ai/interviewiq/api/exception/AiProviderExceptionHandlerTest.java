package ai.interviewiq.api.exception;

import ai.interviewiq.api.service.AiProviderException;
import org.junit.jupiter.api.Test;
import org.springframework.http.HttpStatus;
import static org.junit.jupiter.api.Assertions.*;

class AiProviderExceptionHandlerTest {
    @Test void mapsGeminiProviderFailureToSafeServiceUnavailableResponse() {
        var response = new ApiExceptionHandler().ai(new AiProviderException("provider key must never reach clients"));
        assertEquals(HttpStatus.SERVICE_UNAVAILABLE, response.getStatusCode());
        assertFalse(response.getBody().toString().contains("provider key"));
    }
}

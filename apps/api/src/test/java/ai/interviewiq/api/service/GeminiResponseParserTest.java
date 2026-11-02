package ai.interviewiq.api.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;
import java.util.Set;
import static org.junit.jupiter.api.Assertions.*;

class GeminiResponseParserTest {
    private final ObjectMapper json = new ObjectMapper();
    private final GeminiResponseParser parser = new GeminiResponseParser(json);
    @Test void parsesStructuredGeminiQuestionResponse() throws Exception {
        var response=json.readTree("{\"candidates\":[{\"content\":{\"parts\":[{\"text\":\"{\\\"questions\\\":[\\\"Explain a system you built?\\\",\\\"How do you test it?\\\"]}\"}]}}]}");
        assertEquals(2, parser.questions(response, 2).size());
    }
    @Test void parsesStructuredGeminiInterviewEvaluation() throws Exception {
        String payload="{\"overallScore\":84,\"overallAssessment\":\"Clear and pragmatic responses.\",\"strengths\":[\"Clarity\"],\"improvementAreas\":[\"Metrics\"],\"recommendedActions\":[\"Practice STAR\"],\"questionFeedback\":[{\"questionId\":1,\"score\":82,\"strengths\":[\"Specific example\"],\"improvements\":[\"Add metrics\"],\"recommendation\":\"Quantify impact.\"}]}";
        var response=json.readTree("{\"candidates\":[{\"content\":{\"parts\":[{\"text\":"+json.writeValueAsString(payload)+"}]}}]}");
        assertEquals(84, parser.evaluation(response, Set.of(1L)).overallScore());
    }
    @Test void rejectsMalformedOrInvalidGeminiResponses() throws Exception {
        var malformed=json.readTree("{\"candidates\":[]}");
        assertThrows(AiProviderException.class, () -> parser.questions(malformed, 1));
        var invalid=json.readTree("{\"candidates\":[{\"content\":{\"parts\":[{\"text\":\"{\\\"questions\\\":[\\\"duplicate question?\\\",\\\"duplicate question?\\\"]}\"}]}}]}");
        assertThrows(AiProviderException.class, () -> parser.questions(invalid, 2));
    }
}

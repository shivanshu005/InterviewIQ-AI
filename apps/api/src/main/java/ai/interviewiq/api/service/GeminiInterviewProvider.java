package ai.interviewiq.api.service;

import ai.interviewiq.api.config.AiProperties;
import ai.interviewiq.api.entity.*;
import com.fasterxml.jackson.databind.JsonNode;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClient;
import org.springframework.web.client.RestClientResponseException;
import org.springframework.web.client.ResourceAccessException;
import org.springframework.http.client.SimpleClientHttpRequestFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.time.Duration;
import java.util.*;

@Service
@ConditionalOnProperty(prefix = "interviewiq.ai", name = "provider", havingValue = "gemini")
class GeminiInterviewProvider implements QuestionProvider, EvaluationProvider {
    private static final Logger log = LoggerFactory.getLogger(GeminiInterviewProvider.class);
    private final RestClient client; private final AiProperties properties; private final InterviewPromptService prompts; private final GeminiResponseParser parser;
    GeminiInterviewProvider(RestClient.Builder builder, AiProperties properties, InterviewPromptService prompts, GeminiResponseParser parser) {
        SimpleClientHttpRequestFactory requestFactory = new SimpleClientHttpRequestFactory();
        requestFactory.setConnectTimeout(Duration.ofSeconds(properties.timeoutSeconds()));
        requestFactory.setReadTimeout(Duration.ofSeconds(properties.timeoutSeconds()));
        this.client = builder.baseUrl("https://generativelanguage.googleapis.com/v1beta").requestFactory(requestFactory).build(); this.properties=properties; this.prompts=prompts; this.parser=parser;
    }
    @Override public List<String> generate(Company company, JobRole role, DifficultyLevel difficulty, InterviewTemplate template) {
        return parser.questions(generate(prompts.questions(company, role, difficulty, template, template.getDefaultQuestionCount()), questionSchema()), template.getDefaultQuestionCount());
    }
    @Override public AiEvaluation evaluate(InterviewSession session) {
        return parser.evaluation(generate(prompts.evaluation(session), evaluationSchema()), session.getQuestions().stream().map(InterviewQuestion::getId).collect(java.util.stream.Collectors.toSet()));
    }
    private JsonNode generate(String prompt, Map<String,Object> schema) {
        if (properties.apiKey() == null || properties.apiKey().isBlank()) throw new AiProviderException("AI generation is unavailable because Gemini is not configured.");
        Map<String,Object> request=Map.of("contents", List.of(Map.of("parts", List.of(Map.of("text", prompt)))), "generationConfig", Map.of("temperature", 0.2, "responseMimeType", "application/json", "responseSchema", schema));
        RuntimeException failure=null;
        for(int attempt=1; attempt<=Math.max(1,properties.maxAttempts()); attempt++) {
            try { return client.post().uri("/models/{model}:generateContent", properties.model()).header("x-goog-api-key", properties.apiKey()).contentType(MediaType.APPLICATION_JSON).body(request).retrieve().body(JsonNode.class); }
            catch (RestClientResponseException exception) { log.warn("Gemini request failed with HTTP status {} on attempt {}.", exception.getStatusCode().value(), attempt); failure=new AiProviderException("Gemini generation failed.", exception); if(exception.getStatusCode().is4xxClientError() && exception.getStatusCode().value()!=429) break; }
            catch (ResourceAccessException exception) { log.warn("Gemini request could not be reached on attempt {}.", attempt); failure=new AiProviderException("Gemini could not be reached.", exception); }
            if (attempt < Math.max(1,properties.maxAttempts())) try { Thread.sleep(200L * attempt); } catch (InterruptedException exception) { Thread.currentThread().interrupt(); break; }
        }
        throw failure == null ? new AiProviderException("Gemini generation failed.") : failure;
    }
    private static Map<String,Object> questionSchema() { Map<String,Object> item=Map.of("type","OBJECT","properties",Map.of("question",Map.of("type","STRING"),"category",Map.of("type","STRING"),"difficulty",Map.of("type","STRING"),"expectedAnswerPoints",Map.of("type","ARRAY","items",Map.of("type","STRING"))),"required",List.of("question","category","difficulty","expectedAnswerPoints")); return Map.of("type","OBJECT","properties",Map.of("questions",Map.of("type","ARRAY","items",item)),"required",List.of("questions")); }
    private static Map<String,Object> evaluationSchema() { Map<String,Object> strings=Map.of("type","ARRAY","items",Map.of("type","STRING")); Map<String,Object> question=Map.of("type","OBJECT","properties",Map.of("questionId",Map.of("type","INTEGER"),"score",Map.of("type","NUMBER"),"strengths",strings,"improvements",strings,"recommendation",Map.of("type","STRING")),"required",List.of("questionId","score","strengths","improvements","recommendation")); return Map.of("type","OBJECT","properties",Map.of("overallScore",Map.of("type","NUMBER"),"overallAssessment",Map.of("type","STRING"),"strengths",strings,"improvementAreas",strings,"recommendedActions",strings,"questionFeedback",Map.of("type","ARRAY","items",question)),"required",List.of("overallScore","overallAssessment","strengths","improvementAreas","recommendedActions","questionFeedback")); }
}

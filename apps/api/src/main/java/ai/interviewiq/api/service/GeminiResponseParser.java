package ai.interviewiq.api.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.stereotype.Component;
import java.util.*;

@Component
public class GeminiResponseParser {
    private final ObjectMapper mapper;
    public GeminiResponseParser(ObjectMapper mapper) { this.mapper = mapper; }
    public List<String> questions(JsonNode response, int expected) {
        JsonNode root = payload(response); JsonNode questions = root.path("questions");
        if (!questions.isArray() || questions.size() != expected) throw new AiProviderException("Gemini returned an invalid question set.");
        List<String> values = new ArrayList<>(); Set<String> unique = new HashSet<>();
        for (JsonNode question : questions) { String text = question.isObject() ? question.path("question").asText().trim() : question.asText().trim();
            if (question.isObject() && (question.path("category").asText().isBlank() || question.path("difficulty").asText().isBlank() || !question.path("expectedAnswerPoints").isArray() || question.path("expectedAnswerPoints").isEmpty())) throw new AiProviderException("Gemini returned incomplete question metadata.");
            if (text.length() < 10 || text.length() > 2000 || !unique.add(text.toLowerCase(Locale.ROOT))) throw new AiProviderException("Gemini returned invalid questions."); values.add(text); }
        return values;
    }
    public AiEvaluation evaluation(JsonNode response, Set<Long> questionIds) {
        JsonNode root = payload(response);
        double score = score(root, "overallScore"); String assessment = text(root, "overallAssessment");
        List<String> strengths = strings(root, "strengths"), improvements = strings(root, "improvementAreas"), actions = strings(root, "recommendedActions");
        JsonNode feedback = root.path("questionFeedback"); if (!feedback.isArray() || feedback.size() != questionIds.size()) throw new AiProviderException("Gemini returned incomplete question feedback.");
        List<AiEvaluation.QuestionEvaluation> perQuestion = new ArrayList<>(); Set<Long> seen = new HashSet<>();
        for (JsonNode item : feedback) { long id = item.path("questionId").asLong(-1); if (!questionIds.contains(id) || !seen.add(id)) throw new AiProviderException("Gemini returned feedback for an invalid question."); perQuestion.add(new AiEvaluation.QuestionEvaluation(id, score(item, "score"), strings(item, "strengths"), strings(item, "improvements"), text(item, "recommendation"))); }
        return new AiEvaluation(score, assessment, strengths, improvements, actions, perQuestion);
    }
    private JsonNode payload(JsonNode response) {
        try { JsonNode text = response.path("candidates").path(0).path("content").path("parts").path(0).path("text"); if (!text.isTextual()) throw new AiProviderException("Gemini did not return a structured response."); return mapper.readTree(text.asText()); } catch (AiProviderException exception) { throw exception; } catch (Exception exception) { throw new AiProviderException("Gemini returned malformed JSON.", exception); }
    }
    private double score(JsonNode node, String field) { if (!node.path(field).isNumber()) throw new AiProviderException("Gemini returned an invalid score."); double value=node.path(field).asDouble(); if (value<0 || value>100) throw new AiProviderException("Gemini returned an out-of-range score."); return value; }
    private String text(JsonNode node, String field) { String value=node.path(field).asText("").trim(); if(value.isBlank() || value.length()>4000) throw new AiProviderException("Gemini returned incomplete feedback."); return value; }
    private List<String> strings(JsonNode node, String field) { JsonNode values=node.path(field); if(!values.isArray() || values.isEmpty()) throw new AiProviderException("Gemini returned incomplete feedback."); List<String> result=new ArrayList<>(); for(JsonNode value:values){String text=value.asText("").trim();if(text.isBlank()||text.length()>500)throw new AiProviderException("Gemini returned invalid feedback.");result.add(text);}return result; }
}

package ai.interviewiq.api.service;

import java.util.List;

public record AiEvaluation(double overallScore, String overallAssessment, List<String> strengths,
                           List<String> improvementAreas, List<String> recommendedActions,
                           List<QuestionEvaluation> questionFeedback) {
    public record QuestionEvaluation(Long questionId, double score, List<String> strengths,
                                     List<String> improvements, String recommendation) { }
}

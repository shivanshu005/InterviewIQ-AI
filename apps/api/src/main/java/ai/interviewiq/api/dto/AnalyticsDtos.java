package ai.interviewiq.api.dto;
import java.util.*;
public final class AnalyticsDtos { private AnalyticsDtos(){} public record OverviewResponse(long totalInterviews,long completedInterviews,Double averageScore,Double bestScore,Double averageTechnicalScore,Double averageCommunicationScore,Double averageConfidenceScore,List<TrendPoint> recentPerformance){} public record TrendPoint(Long interviewId,String label,Double score){} }

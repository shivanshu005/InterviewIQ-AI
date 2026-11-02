package ai.interviewiq.api.entity;

import jakarta.persistence.*; import java.math.BigDecimal;

@Entity
@Table(name = "question_feedback", uniqueConstraints = @UniqueConstraint(columnNames = {"interview_feedback_id", "interview_question_id"}))
public class QuestionFeedback extends BaseEntity {
    @ManyToOne(fetch = FetchType.LAZY) @JoinColumn(name = "interview_feedback_id", nullable = false) private InterviewFeedback interviewFeedback;
    @OneToOne(fetch = FetchType.LAZY) @JoinColumn(name = "interview_question_id", nullable = false) private InterviewQuestion interviewQuestion;
    @Column(precision = 5, scale = 2) private BigDecimal score;
    @Column(columnDefinition = "TEXT") private String strengths;
    @Column(columnDefinition = "TEXT") private String improvements;
    @Column(columnDefinition = "TEXT") private String recommendation;
    protected QuestionFeedback() { }
    public QuestionFeedback(InterviewFeedback feedback, InterviewQuestion question, double score, String strengths, String improvements, String recommendation) { this.interviewFeedback=feedback;this.interviewQuestion=question;this.score=BigDecimal.valueOf(score);this.strengths=strengths;this.improvements=improvements;this.recommendation=recommendation; }
    public InterviewQuestion getInterviewQuestion(){return interviewQuestion;} public Double getScore(){return score==null?null:score.doubleValue();} public String getStrengths(){return strengths;} public String getImprovements(){return improvements;} public String getRecommendation(){return recommendation;}
}

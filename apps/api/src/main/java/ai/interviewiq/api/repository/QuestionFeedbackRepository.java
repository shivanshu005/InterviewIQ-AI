package ai.interviewiq.api.repository;
import ai.interviewiq.api.entity.QuestionFeedback;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
public interface QuestionFeedbackRepository extends JpaRepository<QuestionFeedback, Long> { List<QuestionFeedback> findByInterviewFeedbackIdOrderByInterviewQuestionSequenceNumber(Long feedbackId); }

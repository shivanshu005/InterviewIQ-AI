package ai.interviewiq.api.service;

import ai.interviewiq.api.entity.*;
import org.junit.jupiter.api.Test;
import java.util.List;
import static org.assertj.core.api.Assertions.assertThat;

class QuestionGenerationContextTest {
  private final InterviewTemplate technical = new InterviewTemplate("TECHNICAL", "Technical Interview", 5);
  @Test void promptContainsSpecificContextAndGuidance() {
    String prompt = new InterviewPromptService().questions(new Company("AMAZON","Amazon"), new JobRole("JAVA_DEVELOPER","Java Developer","Engineering"), new DifficultyLevel("MEDIUM","Medium",2), technical, 5);
    assertThat(prompt).contains("Company: Amazon", "Role: Java Developer", "Difficulty: Medium", "Interview Type: Technical Interview", "leadership-style", "multithreading");
  }
  @Test void fallbackProducesDistinctRoleAndDifficultyAwareSets() {
    DeterministicQuestionProvider provider = new DeterministicQuestionProvider();
    List<String> java = provider.generate(new Company("AMAZON","Amazon"), new JobRole("JAVA_DEVELOPER","Java Developer","Engineering"), new DifficultyLevel("MEDIUM","Medium",2), technical);
    List<String> data = provider.generate(new Company("TCS","TCS"), new JobRole("DATA_ANALYST","Data Analyst","Data"), new DifficultyLevel("HARD","Hard",3), technical);
    assertThat(java).hasSize(5).doesNotHaveDuplicates().anyMatch(q -> q.contains("Java collections"));
    assertThat(data).hasSize(5).doesNotHaveDuplicates().anyMatch(q -> q.contains("SQL analysis")).anyMatch(q -> q.contains("hard"));
    assertThat(data).isNotEqualTo(java);
  }
  @Test void fallbackSupportsGoogleSoftwareEngineerEasyContext() {
    List<String> questions = new DeterministicQuestionProvider().generate(new Company("GOOGLE","Google"), new JobRole("SOFTWARE_ENGINEER","Software Engineer","Engineering"), new DifficultyLevel("EASY","Easy",1), technical);
    assertThat(questions).hasSize(5).doesNotHaveDuplicates().anyMatch(q -> q.contains("easy"));
  }
  @Test void fallbackSupportsCybersecurityHardContext() {
    List<String> questions = new DeterministicQuestionProvider().generate(new Company("GOOGLE","Google"), new JobRole("CYBERSECURITY_ANALYST","Cybersecurity Analyst","Security"), new DifficultyLevel("HARD","Hard",3), technical);
    assertThat(questions).anyMatch(q -> q.contains("authentication")).anyMatch(q -> q.contains("hard"));
  }
}

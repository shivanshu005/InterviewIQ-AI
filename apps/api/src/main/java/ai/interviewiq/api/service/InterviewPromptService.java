package ai.interviewiq.api.service;

import ai.interviewiq.api.entity.*;
import org.springframework.stereotype.Service;
import java.util.stream.Collectors;

@Service
public class InterviewPromptService {
    public String questions(Company company, JobRole role, DifficultyLevel difficulty, InterviewTemplate template, int count) {
        return "You are an interview-practice question designer. This is not an official or confidential company assessment. Generate exactly " + count + " distinct professional questions with deliberately different topics.\n"+
                "Company: "+company.getName()+"\nRole: "+role.getName()+"\nDifficulty: "+difficulty.getDisplayName()+"\nInterview Type: "+template.getName()+"\nNumber of Questions: "+count+"\n"+
                "Company emphasis: "+companyFocus(company.getCode())+".\nRole focus: "+roleFocus(role.getCode())+".\nDifficulty guidance: "+difficultyGuidance(difficulty.getCode())+".\n"+
                "Cover different role-relevant categories; do not rephrase the same concept. Return only JSON matching the supplied schema, no markdown.";
    }
    private String companyFocus(String c){return switch(c){case "AMAZON"->"algorithms, backend/system concepts, problem solving, and behavioral leadership-style scenarios";case "GOOGLE"->"algorithms, data structures, problem solving, and software-engineering fundamentals";case "MICROSOFT"->"object-oriented design, algorithms, and practical software engineering";case "META"->"algorithms, data structures, and system design for higher levels";case "TCS","INFOSYS","WIPRO"->"programming fundamentals, OOP, SQL, and basic problem solving";default->"publicly known general technical interview themes appropriate to the role";};}
    private String roleFocus(String c){return switch(c){case "JAVA_DEVELOPER"->"Java, OOP, collections, exceptions, multithreading, Spring Boot, SQL, and REST APIs";case "DATA_ANALYST"->"SQL, data cleaning, statistics, Python/Pandas, visualization, and business interpretation";case "MACHINE_LEARNING_ENGINEER"->"Python, ML algorithms, evaluation, feature engineering, statistics, and ML systems";case "CYBERSECURITY_ANALYST"->"networking, authentication, vulnerabilities, SIEM, incident response, and security fundamentals";case "FRONTEND_DEVELOPER"->"HTML, CSS, JavaScript, React, browsers, performance, and accessibility";case "BACKEND_DEVELOPER"->"APIs, databases, authentication, caching, scalability, and backend frameworks";case "DEVOPS_ENGINEER"->"Linux, Docker, CI/CD, cloud, Kubernetes, and monitoring";default->"role-specific practical technical skills, problem solving, and quality practices";};}
    private String difficultyGuidance(String c){return switch(c){case "BEGINNER","EASY"->"fundamental concepts and straightforward practical tasks";case "INTERMEDIATE","MEDIUM"->"scenario-based questions, deeper concepts, and moderate practical problem solving";case "ADVANCED","HARD"->"complex scenarios, optimization, edge cases, and architecture or system thinking where relevant";default->"advanced architecture, trade-offs, production-scale scenarios, and deep technical reasoning";};}

    public String evaluation(InterviewSession session) {
        String answers = session.getQuestions().stream().map(question ->
                "questionId=" + question.getId() + "\nQuestion: " + question.getQuestionText() + "\nAnswer: " + question.getAnswer().getAnswerText())
                .collect(Collectors.joining("\n\n"));
        return "You are an impartial interview coach. Evaluate only the supplied interview content. " +
                "Context: company=" + session.getCompany().getName() + ", role=" + session.getJobRole().getName() + ", difficulty=" + session.getDifficultyLevel().getDisplayName() + ".\n\n" +
                answers + "\n\nReturn only JSON matching the supplied schema; no markdown. Scores must be 0 through 100. Provide concise, actionable feedback.";
    }
}

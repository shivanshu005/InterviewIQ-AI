package ai.interviewiq.api.entity;
import jakarta.persistence.*; import java.time.Instant; import java.util.*;
@Entity @Table(name="interview_sessions") public class InterviewSession extends BaseEntity {
 @ManyToOne(fetch=FetchType.LAZY) @JoinColumn(nullable=false) private User user;
 @ManyToOne(fetch=FetchType.LAZY) @JoinColumn(nullable=false) private Company company;
 @ManyToOne(fetch=FetchType.LAZY) @JoinColumn(nullable=false) private JobRole jobRole;
 @ManyToOne(fetch=FetchType.LAZY) @JoinColumn(nullable=false) private DifficultyLevel difficultyLevel;
 @ManyToOne(fetch=FetchType.LAZY) private InterviewTemplate interviewTemplate;
 @Enumerated(EnumType.STRING) @Column(nullable=false) private InterviewStatus status=InterviewStatus.CREATING;
 private Instant startedAt; private Instant completedAt;
 @OneToMany(mappedBy="interviewSession", cascade=CascadeType.ALL, orphanRemoval=true) @OrderBy("sequenceNumber") private List<InterviewQuestion> questions=new ArrayList<>();
 protected InterviewSession(){} public InterviewSession(User u,Company c,JobRole r,DifficultyLevel d,InterviewTemplate t){user=u;company=c;jobRole=r;difficultyLevel=d;interviewTemplate=t;}
 public User getUser(){return user;} public Company getCompany(){return company;} public JobRole getJobRole(){return jobRole;} public DifficultyLevel getDifficultyLevel(){return difficultyLevel;} public InterviewTemplate getInterviewTemplate(){return interviewTemplate;} public InterviewStatus getStatus(){return status;} public List<InterviewQuestion> getQuestions(){return questions;} public Instant getCreatedAt(){return createdAt;} public Instant getStartedAt(){return startedAt;} public Instant getCompletedAt(){return completedAt;}
 public void addQuestion(InterviewQuestion q){q.setInterviewSession(this);questions.add(q);} public void ready(){status=InterviewStatus.READY;} public void start(){if(status==InterviewStatus.READY){status=InterviewStatus.IN_PROGRESS;startedAt=Instant.now();}} public void complete(){status=InterviewStatus.COMPLETED;completedAt=Instant.now();}
}

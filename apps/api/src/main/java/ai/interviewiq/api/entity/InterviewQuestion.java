package ai.interviewiq.api.entity;
import jakarta.persistence.*;
@Entity @Table(name="interview_questions") public class InterviewQuestion extends BaseEntity {
 @ManyToOne(fetch=FetchType.LAZY) @JoinColumn(nullable=false) private InterviewSession interviewSession; @Column(nullable=false) private short sequenceNumber; @Column(nullable=false,columnDefinition="TEXT") private String questionText; @Column(nullable=false) private String questionType="GENERAL";
 @OneToOne(mappedBy="interviewQuestion",cascade=CascadeType.ALL,orphanRemoval=true) private CandidateAnswer answer;
 protected InterviewQuestion(){} public InterviewQuestion(int n,String text,String type){sequenceNumber=(short)n;questionText=text;questionType=type;} void setInterviewSession(InterviewSession s){interviewSession=s;} public InterviewSession getInterviewSession(){return interviewSession;} public int getSequenceNumber(){return sequenceNumber;} public String getQuestionText(){return questionText;} public String getQuestionType(){return questionType;} public CandidateAnswer getAnswer(){return answer;} public void setAnswer(CandidateAnswer a){a.setInterviewQuestion(this);answer=a;}
}

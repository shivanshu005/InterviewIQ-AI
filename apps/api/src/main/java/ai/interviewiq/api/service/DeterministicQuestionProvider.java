package ai.interviewiq.api.service;

import ai.interviewiq.api.entity.*;
import java.util.*;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Service;

/** Explicit local/test fallback; it mirrors contextual coverage but is not an AI provider. */
@Service @ConditionalOnProperty(prefix="interviewiq.ai",name="provider",havingValue="deterministic",matchIfMissing=true)
class DeterministicQuestionProvider implements QuestionProvider {
 public List<String> generate(Company c,JobRole r,DifficultyLevel d,InterviewTemplate t){ List<String> topics=topics(r.getCode()); List<String> result=new ArrayList<>(); String level=d.getDisplayName().toLowerCase(Locale.ROOT); for(int i=0;i<t.getDefaultQuestionCount();i++){String topic=topics.get(i%topics.size());result.add(switch(i){case 0->"Explain a "+level+" "+topic+" concept relevant to a "+r.getName()+".";case 1->"Walk through a "+level+" scenario involving "+topic+" for "+c.getName()+"-style practice.";case 2->"What trade-offs would you consider when applying "+topic+" in a "+r.getName()+" project?";case 3->"How would you validate quality and edge cases for "+topic+"?";default->"Describe how you would communicate a practical decision involving "+topic+" to your team.";});}return result;}
 private static List<String> topics(String code){return switch(code){case "JAVA_DEVELOPER"->List.of("Java collections","multithreading","Spring Boot","SQL","REST API design");case "DATA_ANALYST"->List.of("SQL analysis","data cleaning","statistics","Pandas","business visualization");case "CYBERSECURITY_ANALYST"->List.of("authentication","network vulnerabilities","incident response","SIEM triage","security controls");case "FRONTEND_DEVELOPER"->List.of("React rendering","JavaScript","accessibility","browser performance","CSS layout");case "DEVOPS_ENGINEER"->List.of("CI/CD","Docker","Kubernetes","monitoring","Linux operations");case "BACKEND_DEVELOPER"->List.of("API design","database indexing","authentication","caching","scalability");default->List.of("problem solving","data structures","object-oriented design","testing","system fundamentals");};}
}

package ai.interviewiq.api.entity;
import jakarta.persistence.*;
@Entity @Table(name="job_roles") public class JobRole extends BaseEntity { @Column(nullable=false,unique=true) private String code; @Column(nullable=false) private String name; private String category; private boolean isActive=true; protected JobRole(){} public JobRole(String c,String n,String cat){code=c;name=n;category=cat;} public String getCode(){return code;} public String getName(){return name;} public String getCategory(){return category;} public boolean isActive(){return isActive;} }

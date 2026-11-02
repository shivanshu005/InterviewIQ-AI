package ai.interviewiq.api.entity;
import jakarta.persistence.*;
@Entity @Table(name="companies") public class Company extends BaseEntity { @Column(nullable=false,unique=true) private String code; @Column(nullable=false) private String name; private boolean isActive=true; protected Company(){} public Company(String c,String n){code=c;name=n;} public String getCode(){return code;} public String getName(){return name;} public boolean isActive(){return isActive;} }

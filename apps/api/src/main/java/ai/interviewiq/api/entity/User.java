package ai.interviewiq.api.entity;

import jakarta.persistence.*;
import java.time.Instant;

@Entity @Table(name = "users")
public class User extends BaseEntity {
    @Column(nullable = false, unique = true, length = 254) private String email;
    @Column(nullable = false) private String passwordHash;
    private String displayName;
    @Column(nullable = false) private String status = "ACTIVE";
    private Instant emailVerifiedAt;
    private Instant lastLoginAt;
    protected User() {}
    public User(String email, String passwordHash, String displayName) { this.email=email; this.passwordHash=passwordHash; this.displayName=displayName; }
    public String getEmail(){return email;} public String getPasswordHash(){return passwordHash;} public String getDisplayName(){return displayName;} public String getStatus(){return status;} public Instant getCreatedAt(){return createdAt;} public Instant getUpdatedAt(){return updatedAt;}
    public void setDisplayName(String name){this.displayName=name;} public void setLastLoginAt(Instant when){this.lastLoginAt=when;}
}

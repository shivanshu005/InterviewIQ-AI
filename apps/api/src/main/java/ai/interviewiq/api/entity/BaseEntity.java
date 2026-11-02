package ai.interviewiq.api.entity;

import jakarta.persistence.*;
import java.time.Instant;

@MappedSuperclass
public abstract class BaseEntity {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY) protected Long id;
    @Column(nullable = false, updatable = false) protected Instant createdAt;
    @Column(nullable = false) protected Instant updatedAt;
    protected Long createdBy;
    protected Long updatedBy;
    @PrePersist void onCreate() { createdAt = updatedAt = Instant.now(); }
    @PreUpdate void onUpdate() { updatedAt = Instant.now(); }
    public Long getId() { return id; }
}

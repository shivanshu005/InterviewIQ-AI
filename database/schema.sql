-- InterviewIQ AI baseline schema for MySQL 8.0+.
-- Run through versioned migrations in production; this file is the baseline reference.
CREATE DATABASE IF NOT EXISTS interviewiq_ai
  CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE interviewiq_ai;

CREATE TABLE users (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  email VARCHAR(254) NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  display_name VARCHAR(120) NULL,
  status VARCHAR(24) NOT NULL DEFAULT 'ACTIVE',
  email_verified_at DATETIME(6) NULL,
  last_login_at DATETIME(6) NULL,
  deleted_at DATETIME(6) NULL,
  deleted_by BIGINT UNSIGNED NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  created_by BIGINT UNSIGNED NULL,
  updated_by BIGINT UNSIGNED NULL,
  PRIMARY KEY (id),
  CONSTRAINT uq_users_email UNIQUE (email),
  CONSTRAINT chk_users_status CHECK (status IN ('PENDING_VERIFICATION','ACTIVE','SUSPENDED','DELETED')),
  CONSTRAINT fk_users_deleted_by FOREIGN KEY (deleted_by) REFERENCES users(id) ON DELETE SET NULL,
  CONSTRAINT fk_users_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
  CONSTRAINT fk_users_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE roles (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT, code VARCHAR(64) NOT NULL, name VARCHAR(120) NOT NULL, description VARCHAR(500) NULL,
  is_active BOOLEAN NOT NULL DEFAULT TRUE, deleted_at DATETIME(6) NULL, deleted_by BIGINT UNSIGNED NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6), created_by BIGINT UNSIGNED NULL, updated_by BIGINT UNSIGNED NULL,
  PRIMARY KEY (id), CONSTRAINT uq_roles_code UNIQUE (code),
  CONSTRAINT fk_roles_deleted_by FOREIGN KEY (deleted_by) REFERENCES users(id) ON DELETE SET NULL, CONSTRAINT fk_roles_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL, CONSTRAINT fk_roles_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;
CREATE TABLE permissions (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT, code VARCHAR(96) NOT NULL, resource VARCHAR(64) NOT NULL, action VARCHAR(64) NOT NULL, description VARCHAR(500) NULL,
  is_active BOOLEAN NOT NULL DEFAULT TRUE, deleted_at DATETIME(6) NULL, deleted_by BIGINT UNSIGNED NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6), created_by BIGINT UNSIGNED NULL, updated_by BIGINT UNSIGNED NULL,
  PRIMARY KEY (id), CONSTRAINT uq_permissions_code UNIQUE (code), CONSTRAINT uq_permissions_resource_action UNIQUE (resource, action),
  CONSTRAINT fk_permissions_deleted_by FOREIGN KEY (deleted_by) REFERENCES users(id) ON DELETE SET NULL, CONSTRAINT fk_permissions_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL, CONSTRAINT fk_permissions_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;
CREATE TABLE role_permissions (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT, role_id BIGINT UNSIGNED NOT NULL, permission_id BIGINT UNSIGNED NOT NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6), created_by BIGINT UNSIGNED NULL, updated_by BIGINT UNSIGNED NULL,
  PRIMARY KEY (id), CONSTRAINT uq_role_permissions UNIQUE (role_id, permission_id),
  CONSTRAINT fk_role_permissions_role FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE RESTRICT, CONSTRAINT fk_role_permissions_permission FOREIGN KEY (permission_id) REFERENCES permissions(id) ON DELETE RESTRICT,
  CONSTRAINT fk_role_permissions_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL, CONSTRAINT fk_role_permissions_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;
CREATE TABLE user_roles (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT, user_id BIGINT UNSIGNED NOT NULL, role_id BIGINT UNSIGNED NOT NULL, granted_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6), created_by BIGINT UNSIGNED NULL, updated_by BIGINT UNSIGNED NULL,
  PRIMARY KEY (id), CONSTRAINT uq_user_roles UNIQUE (user_id, role_id),
  CONSTRAINT fk_user_roles_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE RESTRICT, CONSTRAINT fk_user_roles_role FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE RESTRICT,
  CONSTRAINT fk_user_roles_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL, CONSTRAINT fk_user_roles_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE companies (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT, code VARCHAR(64) NOT NULL, name VARCHAR(160) NOT NULL, website_url VARCHAR(500) NULL, is_active BOOLEAN NOT NULL DEFAULT TRUE,
  deleted_at DATETIME(6) NULL, deleted_by BIGINT UNSIGNED NULL, created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6), created_by BIGINT UNSIGNED NULL, updated_by BIGINT UNSIGNED NULL,
  PRIMARY KEY (id), CONSTRAINT uq_companies_code UNIQUE (code), CONSTRAINT uq_companies_name UNIQUE (name),
  CONSTRAINT fk_companies_deleted_by FOREIGN KEY (deleted_by) REFERENCES users(id) ON DELETE SET NULL, CONSTRAINT fk_companies_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL, CONSTRAINT fk_companies_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;
CREATE TABLE job_roles (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT, code VARCHAR(64) NOT NULL, name VARCHAR(160) NOT NULL, category VARCHAR(100) NULL, is_active BOOLEAN NOT NULL DEFAULT TRUE,
  deleted_at DATETIME(6) NULL, deleted_by BIGINT UNSIGNED NULL, created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6), created_by BIGINT UNSIGNED NULL, updated_by BIGINT UNSIGNED NULL,
  PRIMARY KEY (id), CONSTRAINT uq_job_roles_code UNIQUE (code),
  CONSTRAINT fk_job_roles_deleted_by FOREIGN KEY (deleted_by) REFERENCES users(id) ON DELETE SET NULL, CONSTRAINT fk_job_roles_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL, CONSTRAINT fk_job_roles_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;
CREATE TABLE difficulty_levels (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT, code VARCHAR(32) NOT NULL, display_name VARCHAR(80) NOT NULL, rank_order TINYINT UNSIGNED NOT NULL, is_active BOOLEAN NOT NULL DEFAULT TRUE,
  deleted_at DATETIME(6) NULL, deleted_by BIGINT UNSIGNED NULL, created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6), created_by BIGINT UNSIGNED NULL, updated_by BIGINT UNSIGNED NULL,
  PRIMARY KEY (id), CONSTRAINT uq_difficulty_levels_code UNIQUE (code), CONSTRAINT uq_difficulty_levels_rank UNIQUE (rank_order), CONSTRAINT chk_difficulty_levels_rank CHECK (rank_order > 0),
  CONSTRAINT fk_difficulty_levels_deleted_by FOREIGN KEY (deleted_by) REFERENCES users(id) ON DELETE SET NULL, CONSTRAINT fk_difficulty_levels_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL, CONSTRAINT fk_difficulty_levels_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;
CREATE TABLE interview_templates (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT, code VARCHAR(64) NOT NULL, name VARCHAR(120) NOT NULL, description VARCHAR(500) NULL, default_question_count TINYINT UNSIGNED NOT NULL DEFAULT 5, is_active BOOLEAN NOT NULL DEFAULT TRUE,
  deleted_at DATETIME(6) NULL, deleted_by BIGINT UNSIGNED NULL, created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6), created_by BIGINT UNSIGNED NULL, updated_by BIGINT UNSIGNED NULL,
  PRIMARY KEY (id), CONSTRAINT uq_interview_templates_code UNIQUE (code), CONSTRAINT chk_interview_templates_question_count CHECK (default_question_count BETWEEN 1 AND 20),
  CONSTRAINT fk_interview_templates_deleted_by FOREIGN KEY (deleted_by) REFERENCES users(id) ON DELETE SET NULL, CONSTRAINT fk_interview_templates_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL, CONSTRAINT fk_interview_templates_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE interview_sessions (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT, user_id BIGINT UNSIGNED NOT NULL, company_id BIGINT UNSIGNED NOT NULL, job_role_id BIGINT UNSIGNED NOT NULL, difficulty_level_id BIGINT UNSIGNED NOT NULL, interview_template_id BIGINT UNSIGNED NULL,
  status VARCHAR(32) NOT NULL DEFAULT 'CREATING', prompt_version VARCHAR(64) NULL, started_at DATETIME(6) NULL, completed_at DATETIME(6) NULL, deleted_at DATETIME(6) NULL, deleted_by BIGINT UNSIGNED NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6), created_by BIGINT UNSIGNED NULL, updated_by BIGINT UNSIGNED NULL,
  PRIMARY KEY (id), KEY idx_interview_sessions_user_status_created (user_id, status, created_at), KEY idx_interview_sessions_company (company_id), KEY idx_interview_sessions_job_role (job_role_id), KEY idx_interview_sessions_difficulty (difficulty_level_id),
  CONSTRAINT chk_interview_sessions_status CHECK (status IN ('CREATING','READY','IN_PROGRESS','COMPLETED','FEEDBACK_PENDING','FEEDBACK_AVAILABLE','FAILED_RETRYABLE','CANCELLED','DELETED')),
  CONSTRAINT chk_interview_sessions_completion CHECK (completed_at IS NULL OR completed_at >= created_at),
  CONSTRAINT fk_interview_sessions_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE RESTRICT, CONSTRAINT fk_interview_sessions_company FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE RESTRICT, CONSTRAINT fk_interview_sessions_job_role FOREIGN KEY (job_role_id) REFERENCES job_roles(id) ON DELETE RESTRICT, CONSTRAINT fk_interview_sessions_difficulty FOREIGN KEY (difficulty_level_id) REFERENCES difficulty_levels(id) ON DELETE RESTRICT, CONSTRAINT fk_interview_sessions_template FOREIGN KEY (interview_template_id) REFERENCES interview_templates(id) ON DELETE RESTRICT,
  CONSTRAINT fk_interview_sessions_deleted_by FOREIGN KEY (deleted_by) REFERENCES users(id) ON DELETE SET NULL, CONSTRAINT fk_interview_sessions_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL, CONSTRAINT fk_interview_sessions_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;
CREATE TABLE interview_questions (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT, interview_session_id BIGINT UNSIGNED NOT NULL, sequence_number SMALLINT UNSIGNED NOT NULL, question_text TEXT NOT NULL, question_type VARCHAR(32) NOT NULL DEFAULT 'GENERAL', generation_metadata JSON NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6), created_by BIGINT UNSIGNED NULL, updated_by BIGINT UNSIGNED NULL,
  PRIMARY KEY (id), CONSTRAINT uq_interview_questions_sequence UNIQUE (interview_session_id, sequence_number), CONSTRAINT chk_interview_questions_sequence CHECK (sequence_number > 0),
  CONSTRAINT fk_interview_questions_session FOREIGN KEY (interview_session_id) REFERENCES interview_sessions(id) ON DELETE CASCADE, CONSTRAINT fk_interview_questions_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL, CONSTRAINT fk_interview_questions_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;
CREATE TABLE candidate_answers (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT, interview_question_id BIGINT UNSIGNED NOT NULL, answer_text MEDIUMTEXT NOT NULL, input_method VARCHAR(16) NOT NULL, submitted_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6), created_by BIGINT UNSIGNED NULL, updated_by BIGINT UNSIGNED NULL,
  PRIMARY KEY (id), CONSTRAINT uq_candidate_answers_question UNIQUE (interview_question_id), CONSTRAINT chk_candidate_answers_method CHECK (input_method IN ('TYPED','VOICE_TRANSCRIPT')), CONSTRAINT chk_candidate_answers_text CHECK (CHAR_LENGTH(TRIM(answer_text)) BETWEEN 1 AND 20000),
  CONSTRAINT fk_candidate_answers_question FOREIGN KEY (interview_question_id) REFERENCES interview_questions(id) ON DELETE CASCADE, CONSTRAINT fk_candidate_answers_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL, CONSTRAINT fk_candidate_answers_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;
CREATE TABLE interview_feedback (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT, interview_session_id BIGINT UNSIGNED NOT NULL, status VARCHAR(24) NOT NULL DEFAULT 'PENDING', overall_score DECIMAL(5,2) NULL, overall_assessment TEXT NULL, strengths JSON NULL, improvement_areas JSON NULL, recommended_actions JSON NULL, provider_model VARCHAR(128) NULL, prompt_version VARCHAR(64) NULL, generated_at DATETIME(6) NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6), created_by BIGINT UNSIGNED NULL, updated_by BIGINT UNSIGNED NULL,
  PRIMARY KEY (id), CONSTRAINT uq_interview_feedback_session UNIQUE (interview_session_id), CONSTRAINT chk_interview_feedback_status CHECK (status IN ('PENDING','AVAILABLE','FAILED_RETRYABLE','FAILED_FINAL')), CONSTRAINT chk_interview_feedback_score CHECK (overall_score IS NULL OR overall_score BETWEEN 0 AND 100),
  CONSTRAINT fk_interview_feedback_session FOREIGN KEY (interview_session_id) REFERENCES interview_sessions(id) ON DELETE CASCADE, CONSTRAINT fk_interview_feedback_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL, CONSTRAINT fk_interview_feedback_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;
CREATE TABLE question_feedback (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT, interview_feedback_id BIGINT UNSIGNED NOT NULL, interview_question_id BIGINT UNSIGNED NOT NULL, score DECIMAL(5,2) NULL, strengths TEXT NULL, improvements TEXT NULL, recommendation TEXT NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6), created_by BIGINT UNSIGNED NULL, updated_by BIGINT UNSIGNED NULL,
  PRIMARY KEY (id), CONSTRAINT uq_question_feedback_feedback_question UNIQUE (interview_feedback_id, interview_question_id), CONSTRAINT chk_question_feedback_score CHECK (score IS NULL OR score BETWEEN 0 AND 100),
  CONSTRAINT fk_question_feedback_feedback FOREIGN KEY (interview_feedback_id) REFERENCES interview_feedback(id) ON DELETE CASCADE, CONSTRAINT fk_question_feedback_question FOREIGN KEY (interview_question_id) REFERENCES interview_questions(id) ON DELETE CASCADE, CONSTRAINT fk_question_feedback_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL, CONSTRAINT fk_question_feedback_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;
CREATE TABLE interview_reports (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT, interview_session_id BIGINT UNSIGNED NOT NULL, format VARCHAR(16) NOT NULL, status VARCHAR(24) NOT NULL DEFAULT 'PENDING', storage_key VARCHAR(512) NULL, generated_at DATETIME(6) NULL, expires_at DATETIME(6) NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6), created_by BIGINT UNSIGNED NULL, updated_by BIGINT UNSIGNED NULL,
  PRIMARY KEY (id), KEY idx_interview_reports_session_status (interview_session_id, status), CONSTRAINT uq_interview_reports_session_format UNIQUE (interview_session_id, format), CONSTRAINT chk_interview_reports_format CHECK (format IN ('PDF','HTML')), CONSTRAINT chk_interview_reports_status CHECK (status IN ('PENDING','AVAILABLE','FAILED_RETRYABLE','EXPIRED')),
  CONSTRAINT fk_interview_reports_session FOREIGN KEY (interview_session_id) REFERENCES interview_sessions(id) ON DELETE CASCADE, CONSTRAINT fk_interview_reports_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL, CONSTRAINT fk_interview_reports_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE analytics_events (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT, user_id BIGINT UNSIGNED NULL, event_type VARCHAR(96) NOT NULL, event_properties JSON NULL, occurred_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6), created_by BIGINT UNSIGNED NULL, updated_by BIGINT UNSIGNED NULL,
  PRIMARY KEY (id), KEY idx_analytics_events_user_occurred (user_id, occurred_at), KEY idx_analytics_events_type_occurred (event_type, occurred_at),
  CONSTRAINT fk_analytics_events_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL, CONSTRAINT fk_analytics_events_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL, CONSTRAINT fk_analytics_events_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;
CREATE TABLE user_analytics_snapshots (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT, user_id BIGINT UNSIGNED NOT NULL, snapshot_date DATE NOT NULL, completed_interviews INT UNSIGNED NOT NULL DEFAULT 0, average_score DECIMAL(5,2) NULL, latest_score DECIMAL(5,2) NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6), created_by BIGINT UNSIGNED NULL, updated_by BIGINT UNSIGNED NULL,
  PRIMARY KEY (id), CONSTRAINT uq_user_analytics_snapshots_date UNIQUE (user_id, snapshot_date), CONSTRAINT chk_user_analytics_completed CHECK (completed_interviews >= 0), CONSTRAINT chk_user_analytics_average CHECK (average_score IS NULL OR average_score BETWEEN 0 AND 100), CONSTRAINT chk_user_analytics_latest CHECK (latest_score IS NULL OR latest_score BETWEEN 0 AND 100),
  CONSTRAINT fk_user_analytics_snapshots_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE, CONSTRAINT fk_user_analytics_snapshots_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL, CONSTRAINT fk_user_analytics_snapshots_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;
CREATE TABLE notifications (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT, user_id BIGINT UNSIGNED NOT NULL, notification_type VARCHAR(64) NOT NULL, channel VARCHAR(16) NOT NULL, status VARCHAR(24) NOT NULL DEFAULT 'PENDING', title VARCHAR(255) NOT NULL, body TEXT NULL, related_interview_session_id BIGINT UNSIGNED NULL, sent_at DATETIME(6) NULL, read_at DATETIME(6) NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6), created_by BIGINT UNSIGNED NULL, updated_by BIGINT UNSIGNED NULL,
  PRIMARY KEY (id), KEY idx_notifications_user_status_created (user_id, status, created_at), CONSTRAINT chk_notifications_channel CHECK (channel IN ('IN_APP','EMAIL')), CONSTRAINT chk_notifications_status CHECK (status IN ('PENDING','SENT','DELIVERED','READ','FAILED','CANCELLED')),
  CONSTRAINT fk_notifications_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE, CONSTRAINT fk_notifications_session FOREIGN KEY (related_interview_session_id) REFERENCES interview_sessions(id) ON DELETE SET NULL, CONSTRAINT fk_notifications_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL, CONSTRAINT fk_notifications_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;
CREATE TABLE user_settings (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT, user_id BIGINT UNSIGNED NOT NULL, notifications_enabled BOOLEAN NOT NULL DEFAULT TRUE, feedback_ready_email_enabled BOOLEAN NOT NULL DEFAULT TRUE, practice_reminders_enabled BOOLEAN NOT NULL DEFAULT FALSE, locale VARCHAR(16) NOT NULL DEFAULT 'en', timezone VARCHAR(64) NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6), created_by BIGINT UNSIGNED NULL, updated_by BIGINT UNSIGNED NULL,
  PRIMARY KEY (id), CONSTRAINT uq_user_settings_user UNIQUE (user_id),
  CONSTRAINT fk_user_settings_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE, CONSTRAINT fk_user_settings_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL, CONSTRAINT fk_user_settings_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE achievements (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT, code VARCHAR(64) NOT NULL, name VARCHAR(160) NOT NULL, description VARCHAR(500) NOT NULL, criteria_type VARCHAR(64) NOT NULL, criteria_value INT UNSIGNED NOT NULL, is_active BOOLEAN NOT NULL DEFAULT TRUE,
  deleted_at DATETIME(6) NULL, deleted_by BIGINT UNSIGNED NULL, created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6), created_by BIGINT UNSIGNED NULL, updated_by BIGINT UNSIGNED NULL,
  PRIMARY KEY (id), CONSTRAINT uq_achievements_code UNIQUE (code), CONSTRAINT chk_achievements_value CHECK (criteria_value > 0),
  CONSTRAINT fk_achievements_deleted_by FOREIGN KEY (deleted_by) REFERENCES users(id) ON DELETE SET NULL, CONSTRAINT fk_achievements_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL, CONSTRAINT fk_achievements_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;
CREATE TABLE badges (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT, achievement_id BIGINT UNSIGNED NOT NULL, code VARCHAR(64) NOT NULL, display_name VARCHAR(160) NOT NULL, image_key VARCHAR(512) NULL, is_active BOOLEAN NOT NULL DEFAULT TRUE,
  deleted_at DATETIME(6) NULL, deleted_by BIGINT UNSIGNED NULL, created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6), created_by BIGINT UNSIGNED NULL, updated_by BIGINT UNSIGNED NULL,
  PRIMARY KEY (id), CONSTRAINT uq_badges_achievement UNIQUE (achievement_id), CONSTRAINT uq_badges_code UNIQUE (code),
  CONSTRAINT fk_badges_achievement FOREIGN KEY (achievement_id) REFERENCES achievements(id) ON DELETE RESTRICT, CONSTRAINT fk_badges_deleted_by FOREIGN KEY (deleted_by) REFERENCES users(id) ON DELETE SET NULL, CONSTRAINT fk_badges_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL, CONSTRAINT fk_badges_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;
CREATE TABLE user_achievements (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT, user_id BIGINT UNSIGNED NOT NULL, achievement_id BIGINT UNSIGNED NOT NULL, awarded_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6), created_by BIGINT UNSIGNED NULL, updated_by BIGINT UNSIGNED NULL,
  PRIMARY KEY (id), CONSTRAINT uq_user_achievements UNIQUE (user_id, achievement_id),
  CONSTRAINT fk_user_achievements_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE, CONSTRAINT fk_user_achievements_achievement FOREIGN KEY (achievement_id) REFERENCES achievements(id) ON DELETE RESTRICT, CONSTRAINT fk_user_achievements_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL, CONSTRAINT fk_user_achievements_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;
CREATE TABLE user_progress (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT, user_id BIGINT UNSIGNED NOT NULL, completed_interviews INT UNSIGNED NOT NULL DEFAULT 0, current_streak_days INT UNSIGNED NOT NULL DEFAULT 0, longest_streak_days INT UNSIGNED NOT NULL DEFAULT 0, last_completed_at DATETIME(6) NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6), created_by BIGINT UNSIGNED NULL, updated_by BIGINT UNSIGNED NULL,
  PRIMARY KEY (id), CONSTRAINT uq_user_progress_user UNIQUE (user_id), CONSTRAINT chk_user_progress_nonnegative CHECK (completed_interviews >= 0 AND current_streak_days >= 0 AND longest_streak_days >= 0),
  CONSTRAINT fk_user_progress_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE, CONSTRAINT fk_user_progress_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL, CONSTRAINT fk_user_progress_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;
CREATE TABLE audit_logs (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT, actor_user_id BIGINT UNSIGNED NULL, target_user_id BIGINT UNSIGNED NULL, entity_type VARCHAR(64) NOT NULL, entity_id BIGINT UNSIGNED NULL, action VARCHAR(96) NOT NULL, outcome VARCHAR(16) NOT NULL, correlation_id CHAR(36) NULL, ip_hash CHAR(64) NULL, metadata JSON NULL, occurred_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6), created_by BIGINT UNSIGNED NULL, updated_by BIGINT UNSIGNED NULL,
  PRIMARY KEY (id), KEY idx_audit_logs_actor_occurred (actor_user_id, occurred_at), KEY idx_audit_logs_target_occurred (target_user_id, occurred_at), KEY idx_audit_logs_entity_occurred (entity_type, entity_id, occurred_at),
  CONSTRAINT chk_audit_logs_outcome CHECK (outcome IN ('SUCCESS','FAILURE','DENIED')),
  CONSTRAINT fk_audit_logs_actor FOREIGN KEY (actor_user_id) REFERENCES users(id) ON DELETE SET NULL, CONSTRAINT fk_audit_logs_target FOREIGN KEY (target_user_id) REFERENCES users(id) ON DELETE SET NULL, CONSTRAINT fk_audit_logs_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL, CONSTRAINT fk_audit_logs_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;

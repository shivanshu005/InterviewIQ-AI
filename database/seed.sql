-- Reference seed data only. Do not seed real users, credentials, interview answers, or production secrets.
USE interviewiq_ai;

INSERT INTO roles (id, code, name, description, created_by, updated_by) VALUES
  (1, 'USER', 'User', 'Standard candidate account.', NULL, NULL),
  (2, 'OPERATIONS', 'Operations', 'Restricted operational support role.', NULL, NULL)
ON DUPLICATE KEY UPDATE name = VALUES(name), description = VALUES(description), updated_at = CURRENT_TIMESTAMP(6);

INSERT INTO permissions (id, code, resource, action, description, created_by, updated_by) VALUES
  (1, 'PROFILE.READ_OWN', 'PROFILE', 'READ_OWN', 'Read own profile.', NULL, NULL),
  (2, 'PROFILE.WRITE_OWN', 'PROFILE', 'WRITE_OWN', 'Update own profile.', NULL, NULL),
  (3, 'INTERVIEW.CREATE_OWN', 'INTERVIEW', 'CREATE_OWN', 'Create own interview.', NULL, NULL),
  (4, 'INTERVIEW.READ_OWN', 'INTERVIEW', 'READ_OWN', 'Read own interview.', NULL, NULL),
  (5, 'INTERVIEW.WRITE_OWN', 'INTERVIEW', 'WRITE_OWN', 'Submit own answers.', NULL, NULL),
  (6, 'REPORT.READ_OWN', 'REPORT', 'READ_OWN', 'Read own report.', NULL, NULL),
  (7, 'OPERATIONS.READ_HEALTH', 'OPERATIONS', 'READ_HEALTH', 'Read service health.', NULL, NULL)
ON DUPLICATE KEY UPDATE description = VALUES(description), updated_at = CURRENT_TIMESTAMP(6);

INSERT INTO role_permissions (role_id, permission_id, created_by, updated_by)
SELECT r.id, p.id, NULL, NULL FROM roles r JOIN permissions p
WHERE r.code = 'USER' AND p.code IN ('PROFILE.READ_OWN','PROFILE.WRITE_OWN','INTERVIEW.CREATE_OWN','INTERVIEW.READ_OWN','INTERVIEW.WRITE_OWN','REPORT.READ_OWN')
ON DUPLICATE KEY UPDATE updated_at = CURRENT_TIMESTAMP(6);
INSERT INTO role_permissions (role_id, permission_id, created_by, updated_by)
SELECT r.id, p.id, NULL, NULL FROM roles r JOIN permissions p
WHERE r.code = 'OPERATIONS' AND p.code = 'OPERATIONS.READ_HEALTH'
ON DUPLICATE KEY UPDATE updated_at = CURRENT_TIMESTAMP(6);

INSERT INTO companies (code, name, website_url, created_by, updated_by) VALUES
  ('GENERIC_TECH', 'Generic Technology Company', NULL, NULL, NULL),
  ('GOOGLE', 'Google', 'https://about.google/', NULL, NULL),
  ('MICROSOFT', 'Microsoft', 'https://www.microsoft.com/', NULL, NULL)
ON DUPLICATE KEY UPDATE name = VALUES(name), website_url = VALUES(website_url), is_active = TRUE, updated_at = CURRENT_TIMESTAMP(6);

INSERT INTO job_roles (code, name, category, created_by, updated_by) VALUES
  ('SOFTWARE_ENGINEER', 'Software Engineer', 'Engineering', NULL, NULL),
  ('BACKEND_ENGINEER', 'Backend Engineer', 'Engineering', NULL, NULL),
  ('DATA_ANALYST', 'Data Analyst', 'Data', NULL, NULL),
  ('PRODUCT_MANAGER', 'Product Manager', 'Product', NULL, NULL),
  ('BUSINESS_ANALYST', 'Business Analyst', 'Business', NULL, NULL)
ON DUPLICATE KEY UPDATE name = VALUES(name), category = VALUES(category), is_active = TRUE, updated_at = CURRENT_TIMESTAMP(6);

INSERT INTO difficulty_levels (code, display_name, rank_order, created_by, updated_by) VALUES
  ('BEGINNER', 'Beginner', 1, NULL, NULL),
  ('INTERMEDIATE', 'Intermediate', 2, NULL, NULL),
  ('ADVANCED', 'Advanced', 3, NULL, NULL)
ON DUPLICATE KEY UPDATE display_name = VALUES(display_name), is_active = TRUE, updated_at = CURRENT_TIMESTAMP(6);

INSERT INTO interview_templates (code, name, description, default_question_count, created_by, updated_by) VALUES
  ('GENERAL', 'General Interview', 'Balanced behavioral and role-relevant practice.', 5, NULL, NULL),
  ('BEHAVIORAL', 'Behavioral Interview', 'Practice behavioral and experience-based responses.', 5, NULL, NULL),
  ('TECHNICAL', 'Technical Interview', 'Practice role-relevant technical discussion.', 5, NULL, NULL)
ON DUPLICATE KEY UPDATE name = VALUES(name), description = VALUES(description), default_question_count = VALUES(default_question_count), is_active = TRUE, updated_at = CURRENT_TIMESTAMP(6);

INSERT INTO achievements (code, name, description, criteria_type, criteria_value, created_by, updated_by) VALUES
  ('FIRST_INTERVIEW', 'First Step', 'Complete your first mock interview.', 'COMPLETED_INTERVIEWS', 1, NULL, NULL),
  ('FIVE_INTERVIEWS', 'Practice Builder', 'Complete five mock interviews.', 'COMPLETED_INTERVIEWS', 5, NULL, NULL)
ON DUPLICATE KEY UPDATE name = VALUES(name), description = VALUES(description), is_active = TRUE, updated_at = CURRENT_TIMESTAMP(6);

INSERT INTO badges (achievement_id, code, display_name, image_key, created_by, updated_by)
SELECT a.id, 'FIRST_STEP_BADGE', 'First Step', NULL, NULL, NULL FROM achievements a WHERE a.code = 'FIRST_INTERVIEW'
ON DUPLICATE KEY UPDATE display_name = VALUES(display_name), is_active = TRUE, updated_at = CURRENT_TIMESTAMP(6);
INSERT INTO badges (achievement_id, code, display_name, image_key, created_by, updated_by)
SELECT a.id, 'PRACTICE_BUILDER_BADGE', 'Practice Builder', NULL, NULL, NULL FROM achievements a WHERE a.code = 'FIVE_INTERVIEWS'
ON DUPLICATE KEY UPDATE display_name = VALUES(display_name), is_active = TRUE, updated_at = CURRENT_TIMESTAMP(6);

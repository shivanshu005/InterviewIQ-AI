# InterviewIQ AI — Software Requirements Specification (SRS)

**Document status:** Draft for Phase 0 architecture and product review  
**Specification style:** IEEE 830-inspired  
**Product:** InterviewIQ AI MVP

## 1 Introduction

### 1.1 Purpose

This Software Requirements Specification (SRS) defines the functional, non-functional, interface, data, error handling, logging, security, and acceptance requirements for the InterviewIQ AI minimum viable product (MVP). It is the authoritative baseline for product, design, engineering, quality assurance, and deployment planning. It defines *what* the system must do; detailed implementation design is intentionally out of scope.

### 1.2 Scope

InterviewIQ AI is a web-based SaaS platform for individual job seekers to practice mock interviews. A registered user configures an interview by company, role, difficulty, and available template/type; answers AI-generated questions by voice or typed input; receives AI-generated structured feedback; reviews interview history and basic analytics; and downloads a completed-interview report.

The MVP includes React/Vite/TypeScript web clients, a Java 21/Spring Boot 3 API, MySQL persistence, Gemini-backed AI generation, browser Web Speech API integration, and Docker/CI/deployment support. Resume processing, billing, teams, video, and non-English experiences are excluded from this release.

### 1.3 Definitions

| Term | Definition |
| --- | --- |
| AI feedback | Structured, advisory content generated from completed interview responses; it is not a hiring decision or professional guarantee. |
| Interview | A configured practice session containing ordered questions, answers, status, and—once complete—feedback/report data. |
| Interview report | A user-downloadable or print-ready summary of a completed interview and its feedback. |
| Typed fallback | The text-entry answer path available when voice recognition is unsupported, denied, or unsuitable. |
| User | An authenticated individual who owns their profile, interviews, answers, feedback, reports, and analytics. |
| Core journey | Registration/login, interview setup, interview completion, feedback viewing, history viewing, and report access. |

### 1.4 Acronyms

| Acronym | Meaning |
| --- | --- |
| ADR | Architecture Decision Record |
| AI | Artificial Intelligence |
| API | Application Programming Interface |
| CI | Continuous Integration |
| JWT | JSON Web Token |
| MVP | Minimum Viable Product |
| NFR | Non-Functional Requirement |
| PII | Personally Identifiable Information |
| SRS | Software Requirements Specification |
| TLS | Transport Layer Security |
| UI | User Interface |
| WCAG | Web Content Accessibility Guidelines |

### 1.5 References

- `docs/01-project-roadmap.md` — InterviewIQ AI Project Roadmap.
- `docs/02-product-requirements.md` — InterviewIQ AI Product Requirements Document.
- IEEE 830-1998, *IEEE Recommended Practice for Software Requirements Specifications* (organizational style reference).
- OWASP Application Security Verification Standard and OWASP Top 10 (security baseline references).
- WCAG 2.1 Level AA (accessibility target).
- Gemini API official documentation (provider integration reference; exact supported models/configuration to be confirmed during implementation planning).
- Web Speech API browser documentation (voice-input capability reference).

### 1.6 Overview

Section 2 describes the product context and constraints. Section 3 specifies functional behavior. Section 4 specifies quality attributes. Sections 5–9 define integrations, data, errors, logging, and security. Section 10 provides end-to-end acceptance criteria for the MVP.

## 2 Overall Description

### 2.1 Product Perspective

InterviewIQ AI is a new, independently deployable SaaS product. It consists of a browser-based single-page application, a secure backend API, a relational database, external AI services, and browser-native speech recognition where available. The frontend is deployed independently from the backend. The backend is the system of record for authenticated user data and mediates all Gemini requests; Gemini credentials and provider responses must not be exposed directly to the browser.

The MVP is designed as a modular monolith with clear domain boundaries, allowing future extraction of background processing or provider services without changing user-facing contracts.

### 2.2 Product Functions

- Account registration, authentication, authorization, logout, and basic profile management.
- Interview setup, creation, persistence, status tracking, and resumable sessions where supported.
- AI-generated interview questions using controlled configuration and versioned prompts.
- Voice transcription on compatible browsers and typed answers for all users.
- Persisted questions and responses, followed by structured AI feedback for completed interviews.
- Feedback display, interview history, basic progress analytics, and report export.
- Operational health, audit-friendly logging, documented APIs, and deployment readiness.

### 2.3 User Classes

| User Class | Characteristics | Primary Permissions |
| --- | --- | --- |
| Visitor | Unauthenticated prospective user | View public content; register; log in |
| Registered user | Individual job seeker using the MVP | Manage own profile, interviews, answers, feedback, history, analytics, and reports |
| Support/operations personnel | Internal personnel; not an MVP product persona | Access only deployment/observability tooling under least privilege; no unrestricted application-data access |

No administrator, recruiter, coach, team, or organization user class is included in the MVP application.

### 2.4 Operating Environment

- **Client:** Modern desktop and mobile web browsers running the React, Vite, TypeScript, Tailwind CSS, shadcn/ui, and TanStack Query frontend.
- **Server:** Java 21 application running Spring Boot 3, Spring Security, Spring Data JPA, and JWT-based authentication.
- **Database:** MySQL in a managed production configuration and Docker-compatible local configuration.
- **AI provider:** Gemini API, invoked by the backend over authenticated TLS connections.
- **Voice:** Browser Web Speech API, subject to browser/platform availability and end-user permission.
- **Deployment:** Containerized services, GitHub Actions CI, Vercel frontend hosting, and Railway backend/database deployment or approved equivalents.

### 2.5 Design Constraints

- The technology stack stated in the approved project roadmap is mandatory for the MVP unless changed through an approved ADR.
- No credentials, API keys, connection strings, or secrets may be committed to source control or exposed in browser bundles.
- The system must use secure-by-default architecture, strong validation, standardized error handling, and reusable components.
- AI output is untrusted external input and must be schema-validated before persistence or rendering.
- Voice input cannot be required because Web Speech API behavior is controlled by browsers and user permissions.
- The initial product language is English only.
- The initial implementation must remain within the approved MVP boundary and indicative 10–12 week delivery schedule.

### 2.6 User Documentation

The release must provide:

- Public product guidance describing the value proposition, supported browsers, voice limitations, and typed fallback.
- In-application onboarding for first interview setup and microphone permission guidance.
- User-facing privacy/terms content approved by the business before launch.
- Accessible help content for common failures such as login, transcription, AI feedback, and report download issues.
- Developer/operator documentation for local setup, environment configuration, API contracts, deployments, migrations, monitoring, backup/recovery, and incident response.

### 2.7 Assumptions and Dependencies

- Users have an email address, supported browser, and sufficient connectivity for a web session.
- Gemini API credentials, quota, availability, and terms are suitable for the MVP workload.
- Browser vendors control the availability and quality of Web Speech API implementations.
- Vercel, Railway, GitHub Actions, and any managed MySQL service remain available and fit the startup’s operational needs.
- Product owners will approve the role/company catalog, question templates, scoring approach, feedback rubric, retention policy, and legal text before their dependent functionality is released.
- Third-party service outages are outside direct product control but must be handled without data corruption or misleading completion states.

## 3 Functional Requirements

### 3.1 Identity and Access

#### SRS-FR-001 — User registration

- **Description:** The system shall allow a visitor to create an account using a unique valid email address and a password that satisfies the approved password policy.
- **Priority:** Must Have
- **Acceptance Criteria:** Valid submissions create exactly one user account; invalid fields display actionable validation errors; duplicate email attempts do not disclose unnecessary account details; passwords are never displayed, stored, or logged in plaintext.

#### SRS-FR-002 — User authentication and logout

- **Description:** The system shall allow registered users to log in and log out using secure JWT-based authenticated sessions.
- **Priority:** Must Have
- **Acceptance Criteria:** Valid credentials establish an authenticated session; invalid credentials return a safe error; logout invalidates client-held authentication state; protected resources are inaccessible after logout or token expiry.

#### SRS-FR-003 — Authorization and data ownership

- **Description:** The system shall enforce user-scoped authorization for profiles, interviews, questions, answers, feedback, analytics, and reports.
- **Priority:** Must Have
- **Acceptance Criteria:** A user can access only records they own; attempts to access another user’s identifiers receive a non-disclosing authorization/not-found response; authorization checks are applied server-side to every protected operation.

#### SRS-FR-004 — Profile access

- **Description:** The system shall allow an authenticated user to view and update MVP-defined basic profile details.
- **Priority:** Should Have
- **Acceptance Criteria:** The profile shows the authenticated user’s allowed fields; valid updates persist and are visible on refresh; invalid updates are rejected with field-level errors.

### 3.2 Interview Configuration and Lifecycle

#### SRS-FR-005 — Interview configuration

- **Description:** The system shall allow an authenticated user to choose a company, target role, difficulty, and supported interview type/template before starting an interview.
- **Priority:** Must Have
- **Acceptance Criteria:** All required fields are presented; only approved/valid values are accepted; submission shows clear errors for missing or invalid values; valid selections are stored with the created interview.

#### SRS-FR-006 — Interview creation and ownership

- **Description:** The system shall create an owned interview session from valid configuration and assign it a lifecycle status.
- **Priority:** Must Have
- **Acceptance Criteria:** A valid request creates one interview linked to the authenticated user; the initial status is defined and persisted; the interview appears in the user’s history; repeated client retries do not create duplicate sessions when idempotency is applicable.

#### SRS-FR-007 — Question generation

- **Description:** The system shall request interview questions from Gemini based on the stored interview configuration and a controlled prompt contract.
- **Priority:** Must Have
- **Acceptance Criteria:** Generated questions are associated with the correct interview and ordered; invalid provider output is rejected before display; provider secrets remain server-side; a temporary failure leaves the interview in a recoverable state and communicates next steps.

#### SRS-FR-008 — Interview progression

- **Description:** The system shall present questions sequentially and show the user the current interview progress.
- **Priority:** Must Have
- **Acceptance Criteria:** The UI identifies the current question and progress; users cannot accidentally submit an answer to a different question; navigation behavior follows the approved interview design; persisted progress is restored after a permitted refresh or resume.

#### SRS-FR-009 — Resume in-progress interview

- **Description:** The system shall allow a user to resume an eligible in-progress interview.
- **Priority:** Should Have
- **Acceptance Criteria:** Eligible interviews are identifiable in history/dashboard; resume restores the next unanswered or active question and prior saved answers; completed interviews cannot be resumed as in-progress sessions; ownership is enforced.

#### SRS-FR-010 — Interview completion

- **Description:** The system shall transition an interview to completed only when defined completion conditions are met.
- **Priority:** Must Have
- **Acceptance Criteria:** Completion is rejected if required state/answers are missing; a successful completion is durable and triggers feedback generation; duplicate completion requests do not generate conflicting states or duplicate reports.

### 3.3 Answer Capture

#### SRS-FR-011 — Typed answer capture

- **Description:** The system shall provide typed answer input for every interview question.
- **Priority:** Must Have
- **Acceptance Criteria:** Users can enter, edit before submission, and submit a non-empty valid answer; client and server validation are applied; saved answers remain available after refresh/resume; keyboard-only use is supported.

#### SRS-FR-012 — Voice answer capture

- **Description:** On compatible browsers, the system shall allow a user to capture a spoken answer using the Web Speech API.
- **Priority:** Must Have
- **Acceptance Criteria:** The UI clearly requests microphone permission when needed; compatible successful recognition produces an editable transcript or approved equivalent; permission denial, unsupported browsers, and recognition failures do not prevent typed completion; no audio recording is stored by the MVP unless separately approved.

#### SRS-FR-013 — Answer persistence

- **Description:** The system shall securely persist each submitted answer against its interview, question, and owner.
- **Priority:** Must Have
- **Acceptance Criteria:** The answer is linked to exactly one valid question and interview; unauthorized or mismatched associations are rejected; duplicate retries are safe; persistence failures leave the user informed and able to retry without losing intentionally retained draft text where feasible.

### 3.4 Feedback, History, and Reports

#### SRS-FR-014 — Feedback generation

- **Description:** For a completed interview, the system shall generate structured AI feedback using the interview configuration, questions, and answers.
- **Priority:** Must Have
- **Acceptance Criteria:** Feedback includes an overall assessment/score, strengths, improvement areas, per-question feedback, and recommended next actions; output conforms to the approved schema before persistence; failures expose an accurate pending/failed state with safe retry behavior.

#### SRS-FR-015 — Feedback presentation

- **Description:** The system shall allow the owning user to view feedback for a completed interview.
- **Priority:** Must Have
- **Acceptance Criteria:** Feedback is readable, accessible, and associated with the correct interview; incomplete/pending/failed feedback states are clearly distinguished; users cannot access feedback belonging to another user; informational AI-feedback limitations are communicated.

#### SRS-FR-016 — Interview history

- **Description:** The system shall display an authenticated user’s completed and eligible in-progress interview history.
- **Priority:** Must Have
- **Acceptance Criteria:** History displays only the current user’s records with status and relevant dates/configuration; records are consistently ordered and paginated or bounded as needed; selected record details match persisted data.

#### SRS-FR-017 — Basic progress analytics

- **Description:** The system shall provide basic user-scoped analytics derived from completed interviews.
- **Priority:** Must Have
- **Acceptance Criteria:** Metrics are calculated from the user’s authorized completed data; empty states are clear; values are internally consistent with underlying feedback/history; analytics do not imply validated hiring outcomes.

#### SRS-FR-018 — Interview report export

- **Description:** The system shall provide an exportable or print-ready report for a completed interview.
- **Priority:** Must Have
- **Acceptance Criteria:** The report contains approved interview summary and feedback data for the selected completed interview; only the owner may request it; export failures are recoverable and do not expose data; generated content is safely encoded.

### 3.5 Product Quality and Operations

#### SRS-FR-019 — Validation and user feedback

- **Description:** The system shall validate user input, state transitions, and external AI output and present comprehensible feedback for expected errors.
- **Priority:** Must Have
- **Acceptance Criteria:** Invalid requests are rejected consistently by the server; client validation improves usability without replacing server validation; messages avoid sensitive implementation details; accessible error/status announcements are available.

#### SRS-FR-020 — Operational observability

- **Description:** The system shall expose health status and record structured operational events necessary to diagnose core-journey failures.
- **Priority:** Must Have
- **Acceptance Criteria:** Deployment health can be checked without revealing secrets; errors include correlation identifiers where applicable; logs support diagnosis of authentication, interview, AI, and export failures; logs exclude credentials and unnecessary sensitive content.

#### SRS-FR-021 — API documentation

- **Description:** The system shall maintain versioned documentation for supported backend API contracts.
- **Priority:** Must Have
- **Acceptance Criteria:** Each supported endpoint documents authentication, request/response shape, validation, and error behavior; documentation changes with contract changes; internal implementation details and secrets are excluded.

#### SRS-FR-022 — Feedback usefulness signal

- **Description:** The system should allow a user to rate the usefulness of completed-interview feedback.
- **Priority:** Should Have
- **Acceptance Criteria:** A user may submit a simple rating for their own feedback; duplicate/vulnerable submissions are handled according to the approved design; aggregated data contains no unnecessary answer content.

## 4 Non Functional Requirements

### 4.1 Performance

- **SRS-NFR-PERF-001:** Under normal operating load, non-AI authenticated API operations shall target p95 server response time of 500 ms or less, excluding network transfer.
- **SRS-NFR-PERF-002:** Core frontend views shall target interactive readiness within 3 seconds on typical broadband conditions and supported devices.
- **SRS-NFR-PERF-003:** Feedback generation shall target a median completion time of 30 seconds or less; longer processing must present an accurate asynchronous or retryable state.

### 4.2 Scalability

- **SRS-NFR-SCALE-001:** Backend services shall be stateless where practical and support horizontal scaling without user session affinity.
- **SRS-NFR-SCALE-002:** Data access shall support indexed, user-scoped history/report queries and bounded or paginated collections.
- **SRS-NFR-SCALE-003:** Gemini integration shall be encapsulated so quotas, timeouts, retry policies, model changes, and alternative providers can be managed without broad client changes.

### 4.3 Security

- **SRS-NFR-SEC-001:** Production traffic shall use TLS; secrets shall be stored only in approved runtime configuration/secrets facilities.
- **SRS-NFR-SEC-002:** Passwords shall use an industry-standard adaptive one-way hash and never be logged or stored in plaintext.
- **SRS-NFR-SEC-003:** Every protected server operation shall validate authentication, authorization, ownership, input, and state transitions.
- **SRS-NFR-SEC-004:** AI outputs and report content shall be treated as untrusted input and safely validated/encoded before storage or rendering.

### 4.4 Accessibility

- **SRS-NFR-A11Y-001:** Core user flows shall meet WCAG 2.1 AA target criteria.
- **SRS-NFR-A11Y-002:** All core controls shall support keyboard navigation, visible focus, semantic labels, accessible validation, and screen-reader-compatible status feedback.
- **SRS-NFR-A11Y-003:** Typed answer entry shall be fully functional independent of microphone or voice recognition availability.

### 4.5 Availability

- **SRS-NFR-AVAIL-001:** The core journey shall target 99.5% monthly availability, excluding announced maintenance and verified upstream provider outages.
- **SRS-NFR-AVAIL-002:** Production deployments shall include health checks, error monitoring, and documented recovery procedures.

### 4.6 Maintainability

- **SRS-NFR-MAINT-001:** The codebase shall follow clean architecture, SOLID, DRY, KISS, documented module boundaries, and agreed linting/formatting standards.
- **SRS-NFR-MAINT-002:** Database schema changes shall be versioned through migrations and verified in CI.
- **SRS-NFR-MAINT-003:** API contracts, environment setup, architecture decisions, deployment, and operational procedures shall be documented and kept current.

### 4.7 Reliability

- **SRS-NFR-REL-001:** Critical interview state transitions, answers, feedback status, and reports shall be durable and safe under retried requests.
- **SRS-NFR-REL-002:** Temporary AI-provider or network failure shall not corrupt interview data or incorrectly mark a failed activity complete.
- **SRS-NFR-REL-003:** Automated tests shall cover authentication, authorization, validation, lifecycle transitions, AI-failure handling, and report access.

### 4.8 Localization

- **SRS-NFR-LOC-001:** The MVP user experience and AI prompts shall be English-only.
- **SRS-NFR-LOC-002:** User-facing strings shall be organized to allow future localization without pervasive code rewrites.

### 4.9 Compliance

- **SRS-NFR-COMP-001:** Before public launch, the product shall publish business-approved privacy and terms content describing the treatment of user and interview data.
- **SRS-NFR-COMP-002:** The product shall minimize collection of PII and retain user data according to an approved retention/deletion policy.
- **SRS-NFR-COMP-003:** The product shall not represent AI feedback as an employment decision, professional certification, or guarantee of interview outcome.

### 4.10 Browser Compatibility

- **SRS-NFR-BROWSER-001:** The typed-answer core experience shall support the latest two stable versions of Chrome, Edge, Firefox, and Safari on applicable desktop/mobile platforms.
- **SRS-NFR-BROWSER-002:** Voice support shall be tested against an explicit browser/platform matrix and documented as capability-dependent; unsupported environments shall retain typed completion.

## 5 External Interfaces

### 5.1 User Interface

The frontend shall provide a responsive web UI with public discovery/authentication pages, dashboard, interview setup, device readiness, interview session, feedback, history/analytics, report access, and error/empty states. UI forms must use clear labels, validation feedback, loading/progress indicators, and accessible interaction patterns. The UI communicates with backend APIs through authenticated HTTPS requests; it must not contain Gemini secrets or direct database access.

### 5.2 Backend API

The backend shall expose documented, versioned HTTPS JSON APIs for authentication, profile operations, interview configuration/lifecycle, answer submission, feedback retrieval/status, history/analytics, and report generation/access. APIs shall apply consistent request validation, authenticated authorization, owner checks, response formats, pagination/bounding where appropriate, correlation identifiers, and standard error payloads. Exact endpoint paths and schemas are deferred to the approved API specification.

### 5.3 Database

The backend shall access MySQL through Spring Data JPA and managed database migrations. The database is private to backend services; browser clients shall never connect directly. Schema design must enforce referential integrity where appropriate, preserve ownership relationships, provide timestamps/audit fields as approved, index core user-scoped queries, and support backup/recovery procedures.

### 5.4 Gemini API

The backend shall integrate with Gemini over authenticated TLS requests. It shall supply only the approved minimum data needed to generate questions and feedback, use server-side credentials, enforce timeouts/retries/rate controls, record provider outcomes safely, validate structured output, and prevent direct browser-to-provider access. Exact model selection, token limits, prompt templates, and quota policies require an ADR before implementation.

### 5.5 Browser Web Speech API

The frontend shall invoke supported browser Web Speech API capabilities only after user action and necessary permission handling. It shall communicate recognition state, handle interim/final transcripts according to the approved UX, allow an editable typed alternative, and safely handle unsupported capability, denial, interruption, timeout, and recognition errors. The MVP shall not rely on Web Speech API for authentication, authorization, or persistence.

## 6 Data Requirements

### 6.1 Core Data Entities

| Entity | Required MVP Data | Rules |
| --- | --- | --- |
| User | Identifier, email, password hash, profile fields, timestamps | Email unique; password hash only; user owns related data |
| Interview | Identifier, owner, company, role, difficulty, type/template, status, timestamps | Configuration validated; owner required; lifecycle controlled |
| Question | Identifier, interview, sequence, question text, generation metadata as approved | Ordered within interview; immutable after generation unless approved flow permits otherwise |
| Answer | Identifier, interview, question, text transcript/typed content, timestamps | Must belong to owner’s interview/question; no raw audio by default |
| Feedback | Identifier, interview, structured assessment, strengths, improvements, per-question feedback, recommendations, status, timestamps | One current valid feedback result per completed interview unless versioning is approved |
| Report | Identifier or generation reference, interview, format/status, generated timestamp | Available only for completed, owned interviews |
| Feedback rating | Identifier, user, interview/feedback, rating, optional approved metadata | User-scoped; avoids unnecessary answer duplication |

### 6.2 Data Quality and Integrity

- Server-side validation is authoritative for all persisted data.
- All owned records must maintain a verifiable relationship to exactly one user, either directly or through the interview.
- State transitions must be explicit and validated. Invalid associations, orphan records, duplicate sequence numbers, and incompatible status transitions must be prevented.
- Timestamps shall be consistently stored in UTC and formatted for the user in the frontend.
- AI output must pass a documented schema and content-safety validation before use.

### 6.3 Privacy, Retention, and Deletion

- The product shall collect only data necessary for MVP operation, support, security, and approved product measurement.
- Passwords, tokens, and provider secrets are never included in exports, analytics, support logs, or client-visible responses.
- The business must approve retention, deletion, export, and account-deletion policies before public launch. Until then, data-retention behavior shall not be represented to users as finalized.
- Interview answers and feedback are potentially sensitive career data and must be protected as user-owned content.

## 7 Error Handling Requirements

- **SRS-ERR-001:** The system shall return consistent, documented error responses containing a stable machine-readable code, user-safe message, and correlation identifier where appropriate.
- **SRS-ERR-002:** The UI shall show clear, actionable, accessible error states without exposing stack traces, secrets, provider credentials, database details, or authorization internals.
- **SRS-ERR-003:** Client-side validation shall provide prompt feedback, but the backend shall independently validate every request.
- **SRS-ERR-004:** Authentication failures shall not reveal whether a specific email account exists beyond the approved user experience.
- **SRS-ERR-005:** Authorization/ownership failures shall not disclose another user’s data existence or contents.
- **SRS-ERR-006:** AI-provider timeout, malformed output, quota, or service failure shall leave the affected interview/feedback in an accurate recoverable state and present retry or support guidance as appropriate.
- **SRS-ERR-007:** Browser voice permission, unsupported capability, recognition errors, and interrupted sessions shall preserve access to typed answering and must not discard submitted answers.
- **SRS-ERR-008:** Report-generation failures shall not mark a report successfully generated and shall allow a safe retry when the underlying interview is eligible.
- **SRS-ERR-009:** Unexpected server errors shall be logged with diagnostic context and return a generic safe response; users shall not be asked to retry unsafe non-idempotent actions without an idempotency/recovery mechanism.

## 8 Logging Requirements

- **SRS-LOG-001:** Backend logs shall be structured and include timestamp, severity, service/environment, correlation identifier, event category, and safe diagnostic context.
- **SRS-LOG-002:** Authentication events, authorization denials, validation failures, interview lifecycle transitions, AI request outcomes, report outcomes, health events, and unexpected exceptions shall be logged at appropriate levels.
- **SRS-LOG-003:** Logs shall not include plaintext passwords, JWTs, API keys, database credentials, raw authorization headers, or unnecessary interview-response content.
- **SRS-LOG-004:** Where user linkage is operationally necessary, logs shall prefer internal identifiers or privacy-conscious pseudonymous references over email addresses.
- **SRS-LOG-005:** Client-side error telemetry, if used, shall be scrubbed of sensitive form data and tied to approved privacy practices.
- **SRS-LOG-006:** Production log retention, access control, monitoring, alert thresholds, and incident escalation procedures shall be documented before launch.

## 9 Security Requirements

- **SRS-SEC-001:** The system shall enforce TLS for all production client-server and server-provider traffic.
- **SRS-SEC-002:** Secrets shall be stored in approved environment/secrets management facilities, excluded from source control and logs, and rotated according to an approved operational procedure.
- **SRS-SEC-003:** Passwords shall be hashed using a current adaptive one-way algorithm with an approved work factor; password policy and reset process require product/security approval before release.
- **SRS-SEC-004:** JWTs shall be signed, validated for issuer/audience/expiry as applicable, transported securely, and configured with an approved expiry/refresh strategy. Authorization shall not rely solely on client claims.
- **SRS-SEC-005:** All protected endpoints shall perform server-side authentication, role/permission checks where applicable, and resource ownership checks.
- **SRS-SEC-006:** The system shall validate and constrain all inputs, output-encode rendered/exported content, and defend against common injection, XSS, CSRF as applicable to the chosen auth transport, insecure deserialization, and mass-assignment risks.
- **SRS-SEC-007:** Sensitive endpoints shall have appropriate rate limiting and abuse controls, particularly registration, login, AI generation, and report generation.
- **SRS-SEC-008:** Dependencies shall be pinned/managed and scanned in CI; critical/high security findings shall be assessed and resolved or formally accepted before release.
- **SRS-SEC-009:** Production configuration shall set secure headers, least-privilege database access, restricted CORS origins, secure cookie settings if cookies are used, and environment separation.
- **SRS-SEC-010:** Security-relevant events shall be monitored and handled through documented incident response and recovery procedures.

## 10 Acceptance Criteria

The MVP is acceptable for controlled production launch only when all of the following conditions are demonstrated:

1. All **Must Have** functional requirements in Section 3 are implemented, tested, and traceable to release evidence.
2. A newly registered user can complete the core journey: register, log in, configure an interview, answer every question by voice on a supported browser or typed fallback, complete the session, view feedback, view history, and download a report.
3. Ownership tests prove that one authenticated user cannot access or alter another user’s profiles, interviews, answers, feedback, analytics, or reports.
4. Gemini question and feedback flows use server-side credentials, handle malformed/failed/slow provider responses safely, and retain accurate interview/feedback state.
5. Core typed workflows work on the latest two stable versions of Chrome, Edge, Firefox, and Safari; voice-support limitations and fallback behavior are documented and verified against the approved test matrix.
6. Core user flows meet the WCAG 2.1 AA target, including keyboard use, labels, focus, error/status feedback, and non-voice completion.
7. Security controls in Section 9 are verified through code review, automated checks, configuration review, and appropriate security testing; no known critical unresolved vulnerability is accepted for launch.
8. Performance and availability targets are tested or monitored with evidence appropriate to MVP load; health checks, structured logs, error monitoring, backups, and recovery/runbook documentation are operational.
9. Database migrations, CI quality gates, API documentation, environment documentation, and deployment instructions are complete and reproducible.
10. Product, engineering, security, and stakeholder owners approve the completed acceptance evidence and outstanding risks before production release.

---

**Change control:** Changes to this SRS that affect scope, privacy, security, interfaces, data lifecycle, or acceptance criteria require documented review and approval before implementation.

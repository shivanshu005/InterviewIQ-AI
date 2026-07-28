# InterviewIQ AI — Product Requirements Document

## Executive Summary

InterviewIQ AI is an AI-powered SaaS platform that helps candidates practice interviews in a realistic, repeatable way. Users select a target company, role, and difficulty; complete a guided mock interview using voice or typed answers; then receive structured feedback, analytics, interview history, and a downloadable report.

The MVP focuses on the individual job seeker. It delivers a complete, secure practice loop—from account creation to report download—while establishing a scalable product and technical foundation for personalization, resume intelligence, subscriptions, and organizational offerings.

## Product Vision

Make high-quality interview practice available on demand, so every candidate can enter an interview prepared, confident, and able to communicate their experience clearly.

InterviewIQ AI will become a trusted personal interview coach: accessible at any time, personalized to a candidate’s goals, and able to show measurable improvement over time.

## Problem Statement

Job seekers often know their subject matter but struggle to communicate it under interview pressure. Traditional preparation is inconsistent: peers and coaches are not always available, generic question lists do not provide feedback, and professional coaching can be expensive. Candidates lack a private, structured way to rehearse realistic questions, understand weaknesses, and track improvement.

## Goals

- Provide a simple end-to-end mock interview experience that users can complete independently.
- Turn responses into specific, understandable, and actionable feedback.
- Encourage repeated practice by preserving history and showing progress.
- Build trust through privacy, transparent expectations, reliability, and secure handling of user data.
- Establish a production-ready MVP that can validate demand and support future growth.

## Objectives

- Enable a new user to complete their first practice interview in less than 15 minutes.
- Support configurable interviews by target company, role, and difficulty.
- Produce feedback and a report after every completed interview.
- Provide voice-based answering on supported browsers with an equivalent typed-answer path.
- Allow users to revisit completed interviews and identify areas to improve.
- Deploy a stable, observable MVP suitable for a controlled beta launch.

## Success Metrics

| Metric | MVP Target | Rationale |
| --- | --- | --- |
| Registration-to-first-interview completion | ≥ 40% within 7 days | Measures activation and initial product value |
| Interview completion rate | ≥ 70% of started interviews | Measures usability and workflow reliability |
| Feedback/report generation success | ≥ 98% of completed interviews | Protects the core value moment |
| Time to feedback | Median ≤ 30 seconds after completion | Keeps the experience responsive |
| 30-day returning-user rate | ≥ 25% of activated users | Indicates repeat-practice value |
| User-rated feedback usefulness | ≥ 4.0 / 5 | Validates AI output quality |
| Critical security incidents | 0 | Baseline condition for launch |
| Core journey availability | ≥ 99.5% monthly | Supports dependable self-service practice |

## Target Audience

The initial target is English-speaking individual job seekers preparing for software, data, product, business, and entry-level professional roles. The first release prioritizes users who are comfortable using web applications and who benefit from repeated, self-directed practice. Secondary early audiences include career-switchers, final-year students, and professionals preparing for high-stakes interviews.

## User Personas

### 1. Aisha Khan — Final-Year Engineering Student

- **Background:** Aisha is a 22-year-old computer science student applying for graduate software engineering roles. She has completed projects and internships but has limited live interview experience.
- **Goals:** Build confidence, practice common technical and behavioral questions, articulate projects clearly, and identify what to improve before campus recruitment interviews.
- **Pain Points:** Friends are unavailable for regular mock interviews; generic online questions provide no coaching; she feels anxious speaking under time pressure.
- **Technical Skill Level:** High. Comfortable with web applications, developer tools, and browser permissions.

### 2. Rahul Mehta — Mid-Career Software Engineer

- **Background:** Rahul is a 30-year-old backend engineer with six years of experience. He is selectively applying to product companies while working full time.
- **Goals:** Practice senior-level behavioral and system-design communication, prepare efficiently during evenings, and improve clarity when explaining trade-offs.
- **Pain Points:** Limited preparation time, difficulty finding peers with relevant experience, and no objective record of recurring communication gaps.
- **Technical Skill Level:** High. Expects a polished, fast, secure product and understands browser/voice limitations.

### 3. Priya Nair — Career Switcher

- **Background:** Priya is a 27-year-old former operations analyst transitioning into product management after completing a certification program. Her interview experience is largely outside technology.
- **Goals:** Learn the language of product interviews, practice structured answers, gain confidence, and demonstrate transferable skills.
- **Pain Points:** Unsure which questions matter for her new role; receives vague feedback from peers; lacks a reliable way to measure whether practice is helping.
- **Technical Skill Level:** Medium. Comfortable with common consumer web products but needs clear guidance, plain language, and forgiving error messages.

### 4. Daniel Brooks — Early-Career Business Analyst

- **Background:** Daniel is a 24-year-old business graduate applying to consulting and analyst roles. He often practices on a shared laptop and relies on public or inconsistent internet connections.
- **Goals:** Complete focused interview drills, review feedback later, download reports for coaching sessions, and improve concise communication.
- **Pain Points:** Cannot always use a microphone privately; worries about data privacy; loses momentum if a tool is complex or slow.
- **Technical Skill Level:** Medium. Familiar with standard web workflows; benefits from keyboard-friendly, mobile-responsive, low-friction flows.

## User Journey

1. **Discovery:** The visitor arrives at the marketing website through search, referral, social content, or a direct link. They understand the core promise, supported interview types, browser/voice requirements, and privacy position.
2. **Evaluation:** The visitor reviews the value proposition and starts registration. Clear calls to action explain that a typed-answer fallback is available if microphone access is unavailable.
3. **Account creation:** The user registers with email and password, receives validation feedback, and logs in. They enter an authenticated dashboard with an empty-state guide to their first interview.
4. **Interview setup:** The user selects company, target role, difficulty, and available interview template/type. The system validates the selection and clearly communicates the expected format and approximate duration.
5. **Device readiness:** Before starting, the user sees microphone/browser compatibility status. On supported browsers they grant microphone permission; otherwise they choose typed responses without being blocked.
6. **Mock interview:** The system presents one AI-generated question at a time. The user speaks an answer that is transcribed or types an answer, reviews it where applicable, and submits it. Progress, question count, and safe exit/resume expectations are clear.
7. **Completion and analysis:** On the final answer, the interview is marked complete. The platform processes the transcript and responses, shows a progress state, and generates structured feedback.
8. **Feedback review:** The user sees an overall assessment, strengths, improvement areas, question-level observations, and suggested next actions. AI limitations and the informational nature of feedback are communicated appropriately.
9. **History and progress:** The completed interview is saved to history. The user can compare basic outcomes across prior sessions and choose a focus area for a future attempt.
10. **Report download:** The user requests a report export, receives a downloadable/print-ready interview report, and can use it for personal review or an external coach.

## MVP Scope

### Must Have

- Secure registration, login, logout, password storage, and JWT-based authenticated sessions.
- Interview setup using company, role, difficulty, and supported template/type selections.
- AI-generated interview questions and persistent interview sessions.
- Voice input through Web Speech API on compatible browsers plus typed-answer fallback.
- Answer storage and interview lifecycle management (start, in progress, completed).
- Structured AI feedback: overall score/assessment, strengths, improvements, per-question feedback, and next actions.
- Interview history, basic analytics/progress views, and downloadable report export.
- Responsive web UI, validation, recoverable errors, API documentation, automated CI, Dockerized local setup, and initial production deployment configuration.

### Should Have

- Guided onboarding and contextual preparation tips.
- Question review before final submission where transcription is available.
- Basic filters/sorting for interview history.
- Feedback usefulness rating and lightweight in-product feedback capture.
- Loading, retry, and recovery experiences for temporary AI-provider failures.
- Baseline product and operational analytics with privacy-conscious event collection.

### Could Have

- Timed-answer mode and practice reminders.
- Curated role-specific question packs.
- Shareable report link with user-controlled access.
- Dark mode, richer charts, and optional question bookmarking.
- Simple adaptive recommendations based on past feedback.

### Won't Have (MVP)

- Resume upload, parsing, or resume-grounded interview questions.
- Video interviews, interviewer avatars, or streaming conversational AI.
- Payments, subscriptions, promotional codes, or entitlement management.
- Team, recruiter, coach, enterprise, or administration portals.
- Native mobile applications.
- Non-English language support, advanced speech sentiment analysis, or formal hiring assessments.

## Functional Requirements

- **FR-001:** The system shall allow a visitor to register using a valid email address and password that meets the documented password policy.
- **FR-002:** The system shall validate registration inputs and provide clear, non-sensitive error messages for invalid or duplicate data.
- **FR-003:** The system shall allow registered users to authenticate and end their session through logout.
- **FR-004:** The system shall protect authenticated application data and endpoints so users can access only their own information.
- **FR-005:** The system shall allow an authenticated user to view and update their basic profile details as defined for the MVP.
- **FR-006:** The system shall allow a user to create an interview configuration with company, role, difficulty, and supported interview type/template.
- **FR-007:** The system shall validate interview configuration values against supported options and reject invalid requests.
- **FR-008:** The system shall create and persist an interview session with a defined lifecycle state.
- **FR-009:** The system shall generate interview questions through the configured AI provider using a controlled, versioned prompt contract.
- **FR-010:** The system shall present one question at a time and show clear interview progress.
- **FR-011:** The system shall support typed responses for every interview question.
- **FR-012:** On compatible browsers, the system shall support microphone permission and browser speech transcription for spoken responses.
- **FR-013:** The system shall clearly offer typed input when voice support, permission, or transcription is unavailable.
- **FR-014:** The system shall allow the user to submit an answer and persist it against the correct interview question and session.
- **FR-015:** The system shall prevent unauthorized modification or retrieval of another user’s interview, questions, answers, reports, or analytics.
- **FR-016:** The system shall allow an in-progress interview to be resumed when its persisted state permits it.
- **FR-017:** The system shall mark an interview complete only when completion criteria are satisfied.
- **FR-018:** The system shall generate structured AI feedback for a completed interview, including overall assessment, strengths, improvement areas, per-question feedback, and recommended next actions.
- **FR-019:** The system shall validate AI-generated feedback before displaying or storing it and present a recoverable status when generation fails.
- **FR-020:** The system shall allow a user to view feedback only for their completed interviews.
- **FR-021:** The system shall display a user’s interview history and basic progress analytics based on their stored interviews.
- **FR-022:** The system shall generate a downloadable or print-ready report for a completed interview.
- **FR-023:** The system shall provide actionable, accessible error messages and safe retry paths for expected failures.
- **FR-024:** The system shall record appropriate application events and errors for operational troubleshooting without logging credentials or unnecessary sensitive content.
- **FR-025:** The system shall expose documented API contracts for supported frontend-backend interactions.

## Non-Functional Requirements

### Performance

- Standard authenticated screens should reach an interactive state within 3 seconds on a typical broadband connection under normal load.
- Non-AI API requests should target a p95 response time of 500 ms or less, excluding network transit.
- Feedback generation should target a median completion time of 30 seconds or less and must expose meaningful progress/retry states when slower.

### Security

- All production traffic must use HTTPS; secrets and credentials must be managed exclusively through environment/configuration mechanisms.
- Passwords must be hashed using an industry-standard adaptive algorithm; plaintext passwords must never be stored or logged.
- Authentication and authorization must use short-lived, validated JWTs and least-privilege access controls.
- Inputs, AI outputs, uploads added in future releases, and export requests must be validated and safely encoded/handled.
- Security headers, rate limiting for sensitive endpoints, dependency scanning, audit-friendly logs, and a documented data-retention policy are required before production launch.

### Scalability

- Application services should be stateless where practical and capable of horizontal scaling.
- Data design must support user-scoped queries, pagination, and indexed history/report access.
- AI integration must be isolated behind an interface so providers, quotas, retries, and backoff behavior can evolve without broad product changes.

### Accessibility

- The MVP shall target WCAG 2.1 AA for core user journeys.
- Keyboard navigation, visible focus, semantic form labels, accessible validation/errors, sufficient color contrast, and screen-reader-friendly status messages are required.
- Voice interaction must never be the sole way to complete an interview.

### Browser Support

- The core typed-answer experience must support the latest two stable versions of Chrome, Edge, Firefox, and Safari on desktop and mobile where the browser supports the application.
- Voice transcription support must be explicitly tested and documented for supported browser/platform combinations; the typed fallback must work elsewhere.

### Reliability

- Critical state transitions and stored answers must be durable and idempotent where retries are expected.
- AI-provider failures must not corrupt interview state; users must receive a clear recovery path.
- Automated tests must cover authentication, authorization boundaries, validation, interview lifecycle, and report access.

### Availability

- The MVP target is 99.5% monthly availability for core application flows, excluding scheduled maintenance and upstream AI-provider outages.
- Production must include health checks, structured logging, error monitoring, and documented incident/recovery procedures.

### Maintainability

- Code must follow clean architecture, SOLID, DRY, KISS, clear bounded modules, and agreed formatting/linting conventions.
- Public APIs, architecture decisions, configuration, local setup, and deployment procedures must be documented.
- Database changes must be versioned through migrations; CI must run relevant checks before merge.

## Assumptions

- Initial users have valid email access, modern web browsers, and sufficient connectivity for an online interview session.
- Gemini API access, terms, quota, and cost profile are appropriate for the selected MVP use cases.
- Web Speech API can be treated as an enhancement because typed response remains fully supported.
- The startup will provide product decisions, design direction, legal/privacy language, and test users in time for milestone reviews.
- Initial company and role values will be a curated catalog or validated free-form fields, decided during architecture/product discovery.

## Constraints

- The MVP technology stack is React, Vite, TypeScript, Tailwind CSS, shadcn/ui, TanStack Query, Java 21, Spring Boot 3, Spring Security, JWT, Spring Data JPA, MySQL, Gemini API, Web Speech API, Docker, GitHub Actions, Vercel, and Railway.
- No secrets may be embedded in source code, documentation examples, or client-side bundles.
- The team must ship within the roadmap’s 10–12 week indicative MVP window unless scope or resourcing changes.
- Browser-native speech recognition behavior and availability are controlled by browser vendors and user permissions.
- AI feedback is advisory interview-practice content, not a hiring decision or professional guarantee.

## Risks

| Risk | Product Impact | Response |
| --- | --- | --- |
| AI feedback is generic, inaccurate, or inconsistent | Low trust and poor retention | Structured prompts, schemas, evaluation set, feedback ratings, and iterative tuning |
| AI service latency, quota limits, or outages | Interrupted completion and delayed feedback | Timeouts, retries/backoff, usage limits, provider abstraction, transparent recovery UX |
| Voice recognition quality varies | Frustration or inaccessible experience | Compatibility messaging, transcript review, typed fallback, browser test matrix |
| Mishandling personal/interview data | Legal, reputational, and user harm | Secure defaults, data minimization, retention decisions, access controls, monitoring, security review |
| MVP scope grows beyond capacity | Delayed validation and launch | MoSCoW discipline, approval gates, protected backlog, measurable release criteria |
| Users do not perceive enough value after one session | Weak activation and retention | Focus on first-session quality, actionable feedback, onboarding, and user research |

## Future Enhancements

- Resume upload and parsing with user-approved, resume-grounded questions.
- Personalized interview plans and adaptive question selection.
- Multiple languages, accessibility enhancements, and localized role guidance.
- Advanced speech analysis for pacing, filler words, pauses, and clarity trends.
- Video practice, live conversational interviewing, and AI interviewer personas.
- Paid plans, usage entitlements, and billing.
- Coach, recruiter, university, and team workspaces with consented sharing and dashboards.
- Native mobile experiences, notifications, integrations, and richer benchmarks.

---

**Document status:** Draft for Phase 0 review. This PRD defines product intent and scope; implementation begins only after the required discovery and architecture approvals.

# InterviewIQ AI — Project Roadmap

## 1. Project Overview

InterviewIQ AI is a SaaS platform for realistic, AI-powered mock interviews. Users will authenticate, configure an interview by company, target role, and difficulty, answer questions by voice, and receive actionable AI feedback, reports, analytics, and interview history.

The MVP will use a React/Vite/TypeScript frontend and a Java 21/Spring Boot backend with MySQL. Gemini will generate interview content and feedback. Browser-native Web Speech APIs will capture and transcribe voice responses. The system will be designed around secure APIs, clear domain boundaries, reusable UI components, validated inputs, and environment-managed secrets.

## 2. MVP Scope

### Included

- Email/password registration, login, logout, and JWT-based session handling.
- Secure user profile and authenticated application shell.
- Interview configuration: company, role, difficulty, and interview type/template.
- AI-generated question flow with a structured text transcript captured through Web Speech API.
- Answer submission, interview completion, and Gemini-generated feedback.
- Feedback categories: overall score, strengths, improvement areas, per-question feedback, and recommended next actions.
- Interview history and basic progress analytics.
- Downloadable interview report (initially PDF or a print-ready HTML export, based on implementation decision).
- Responsive frontend, API documentation, Dockerized local environment, automated CI, and initial Vercel/Railway deployment configuration.

### Explicit MVP Constraints

- English-only experience.
- Web Speech API support limited to compatible browsers; typed-answer fallback is required.
- No resume upload or parsing in the MVP.
- No billing, teams, admin portal, live human coaching, or real-time video interview.

## 3. Future Features

- Resume upload, parsing, and resume-grounded question generation.
- Role-specific interview rubrics, question libraries, and custom company templates.
- Multi-language interviews and accessibility enhancements.
- Advanced speech metrics: pace, filler words, pauses, confidence signals, and sentiment trends.
- Video interviews, interviewer avatars, and streaming conversational AI.
- Personalized learning plans, practice reminders, and adaptive difficulty.
- Subscription billing, entitlements, usage limits, and organization/team accounts.
- Recruiter/coaching dashboards, sharing, collaboration, and benchmark comparisons.
- Native mobile applications and richer observability/audit capabilities.

## 4. Milestones

| Milestone | Outcome | Exit Criteria |
| --- | --- | --- |
| M0 — Foundation | Architecture and delivery baseline agreed | Roadmap, architecture, data model, UX flows, and backlog approved |
| M1 — Platform Core | Secure, deployable authenticated application | Registration/login, JWT security, database migrations, frontend shell, CI green |
| M2 — Interview Experience | End-to-end mock interview usable | Configuration, AI questions, voice/text answers, persistence, completion flow |
| M3 — Feedback & Insights | Users receive and revisit value | AI feedback, report export, history, analytics, graceful error states |
| M4 — Production Readiness | MVP can be launched safely | Security review, tests, monitoring, deployment, operational runbook, acceptance sign-off |

## 5. Development Phases

### Phase 0 — Product and Architecture Discovery

Define personas, user stories, MVP acceptance criteria, UX journey, domain model, API contracts, architecture decisions, security baseline, and prioritized backlog. Confirm Gemini prompting, rate-limit strategy, retention policy, and report format before implementation begins.

**Deliverables:** product requirements, architecture document, ERD, API specification, wireframes, threat model, ADRs, refined backlog, and definition of done.

### Phase 1 — Engineering Foundation

Initialize frontend and backend standards, repository conventions, environment templates, linting/formatting, testing baseline, Docker Compose, database migration process, CI pipeline, and deployment environments. Establish logging, correlation IDs, health checks, and error-response conventions.

**Deliverables:** runnable local stack, CI workflow, environment documentation, coding standards, project skeletons, database migration baseline, and deployment plan.

### Phase 2 — Identity and Core Domain

Implement the secure authentication and authorization foundation plus users, interview configuration, interview sessions, questions, answers, and status lifecycle. Add validation, rate limiting where appropriate, audit-friendly timestamps, and consistent API errors.

**Deliverables:** authentication APIs/UI, JWT security configuration, core schema and migrations, protected routes, interview setup flow, API tests, and integration tests.

### Phase 3 — AI Interview Workflow

Integrate Gemini through an isolated application service, with prompt versioning, structured output validation, retries/timeouts, usage controls, and provider-safe error handling. Build the interview session UI, voice transcription integration, typed fallback, answer persistence, and resume/recovery behavior.

**Deliverables:** complete interview flow, Gemini integration, Web Speech compatibility/fallback UX, stored transcripts, prompt contracts, and end-to-end tests.

### Phase 4 — Feedback, Reporting, and Analytics

Generate structured feedback, display it accessibly, produce downloadable reports, and implement history and baseline analytics. Validate that feedback is useful, traceable to responses, and safely handled when AI output is unavailable or malformed.

**Deliverables:** feedback engine/UI, report export, interview history, analytics dashboard, feedback evaluation checklist, and user acceptance scenarios.

### Phase 5 — Quality, Security, and Launch

Complete performance and accessibility checks, test coverage targets, dependency/security scanning, production configuration, secrets handling, backups, monitoring, alerting, and release procedures. Run a controlled beta and resolve launch-blocking feedback.

**Deliverables:** production deployment, observability dashboard, runbooks, security checklist, test report, release notes, launch checklist, and post-launch support plan.

## 6. Estimated Timeline

Assuming one focused full-stack engineer, product/design availability, and timely decisions:

| Phase | Estimated Duration | Calendar Target |
| --- | ---: | --- |
| Phase 0 | 1–2 weeks | Weeks 1–2 |
| Phase 1 | 1 week | Week 3 |
| Phase 2 | 2 weeks | Weeks 4–5 |
| Phase 3 | 2–3 weeks | Weeks 6–8 |
| Phase 4 | 1–2 weeks | Weeks 9–10 |
| Phase 5 | 1–2 weeks | Weeks 11–12 |

**MVP target:** approximately 10–12 weeks. Add capacity for design iteration, AI quality tuning, and browser-specific voice testing; these are the most likely schedule variables.

## 7. Key Risks and Mitigations

| Risk | Impact | Mitigation |
| --- | --- | --- |
| Inconsistent AI outputs | Poor feedback quality or broken UX | Enforce JSON schemas, prompt versions, output validation, fallbacks, and evaluation samples |
| AI latency/cost/rate limits | Slow or expensive sessions | Timeouts, retries, quotas, usage telemetry, caching where safe, and a provider abstraction |
| Browser voice variability | Failed transcription for some users | Compatibility checks, clear permissions UX, typed fallback, and supported-browser guidance |
| Sensitive user data | Privacy/security exposure | Least privilege, TLS, password hashing, short-lived JWTs, secret management, retention policy, and security review |
| Scope expansion | Missed MVP date | Maintain explicit MVP boundaries, milestone sign-offs, and a prioritized post-MVP backlog |
| Deployment configuration drift | Production defects | Environment templates, CI checks, Docker parity, migration discipline, and staged releases |

## 8. Success Criteria

- A new user can register, authenticate, configure, complete, and review a mock interview without staff assistance.
- Compatible-browser voice input works reliably, and every voice step has a usable typed fallback.
- Feedback is structured, actionable, and linked to the completed interview.
- Users can view prior interviews and download a report.
- Secrets are never committed; security, validation, and error handling meet the documented baseline.
- Core user journeys have automated coverage and CI passes before merging.
- The deployed MVP is observable, recoverable, responsive on desktop/mobile web, and accepted against agreed user stories.

## 9. Approval Gates

1. Approve this roadmap and MVP boundary.
2. Approve Phase 0 product/architecture artifacts before implementation.
3. Approve UX/API contracts before Phase 2.
4. Approve end-to-end interview workflow before feedback/report work.
5. Approve launch-readiness evidence before production release.

---

**Next step after approval:** create the Phase 0 product and architecture documentation set; application code will begin only after those artifacts are reviewed and approved.

# InterviewIQ AI — Product Backlog and User Stories

**Document status:** Draft for Phase 0 backlog refinement  
**Product:** InterviewIQ AI MVP  
**Planning convention:** Story points use a modified Fibonacci scale (1, 2, 3, 5, 8, 13). Priorities use MoSCoW. “Won’t” means explicitly excluded from the MVP, not permanently rejected.

## Backlog Operating Model

Each story is independently testable wherever practical. Story points estimate relative delivery effort, including implementation, automated testing, review, and integration—not elapsed time. Dependencies identify required predecessor capabilities; they are not an implementation sequence by themselves. A story can be accepted only when its acceptance criteria and definition of done are met.

### Shared Definition of Done

Unless a story specifies an additional condition, every completed story must:

- Meet all stated acceptance criteria and be product-owner reviewable.
- Follow approved security, accessibility, validation, privacy, and architecture standards.
- Include appropriate automated tests and documented error/empty/loading states.
- Have no unresolved critical defects and no hard-coded credentials or secrets.
- Update relevant API, user, operational, and release documentation when behavior changes.
- Pass CI and peer review, with observability added for material backend failures.

## Epic 1 — Authentication

### US-AUTH-001 — Register an account

- **Epic:** Authentication
- **Title:** Email and password registration
- **Description:** As a visitor, I want to create an account with my email and password, so that I can save and access my interview practice.
- **Acceptance Criteria:** Valid registration creates one account; invalid fields receive clear validation feedback; duplicate emails receive a safe response; no plaintext password is stored or logged.
- **Priority:** Must
- **Story Points:** 5
- **Dependencies:** None
- **Definition of Done:** Shared DoD; registration API and accessible UI are integrated.
- **Business Value:** High
- **Risk Level:** Medium

### US-AUTH-002 — Log in securely

- **Epic:** Authentication
- **Title:** User login
- **Description:** As a registered user, I want to log in securely, so that I can access my personal interview data.
- **Acceptance Criteria:** Valid credentials establish a secure session; invalid credentials show a safe generic error; protected screens require authentication; session state survives an approved refresh flow.
- **Priority:** Must
- **Story Points:** 5
- **Dependencies:** US-AUTH-001
- **Definition of Done:** Shared DoD; authentication flow is tested end to end.
- **Business Value:** High
- **Risk Level:** High

### US-AUTH-003 — Log out

- **Epic:** Authentication
- **Title:** End authenticated session
- **Description:** As an authenticated user, I want to log out, so that I can protect my account on a shared device.
- **Acceptance Criteria:** Logout is available from authenticated navigation; local authentication state is cleared; protected routes cannot be reopened without re-authentication.
- **Priority:** Must
- **Story Points:** 2
- **Dependencies:** US-AUTH-002
- **Definition of Done:** Shared DoD; session-expiry/logout behavior is covered by tests.
- **Business Value:** High
- **Risk Level:** Medium

### US-AUTH-004 — Recover password

- **Epic:** Authentication
- **Title:** Password reset
- **Description:** As a user who cannot access my account, I want to reset my password securely, so that I can regain access without support intervention.
- **Acceptance Criteria:** User can request a reset without account enumeration; token/link expiry and one-time use are enforced; new password follows policy; existing sessions follow the approved invalidation policy.
- **Priority:** Should
- **Story Points:** 8
- **Dependencies:** US-AUTH-001, email delivery decision
- **Definition of Done:** Shared DoD; abuse controls and expiry tests are included.
- **Business Value:** High
- **Risk Level:** High

### US-AUTH-005 — Enforce session expiry

- **Epic:** Authentication
- **Title:** Secure session lifecycle
- **Description:** As a user, I want expired sessions handled safely, so that my account remains secure without confusing interruptions.
- **Acceptance Criteria:** Expired/invalid tokens cannot access protected APIs; the UI explains that re-login is required; no private data is shown after expiry.
- **Priority:** Must
- **Story Points:** 3
- **Dependencies:** US-AUTH-002
- **Definition of Done:** Shared DoD; token validation and expired-session tests are present.
- **Business Value:** High
- **Risk Level:** High

### US-AUTH-006 — Limit authentication abuse

- **Epic:** Authentication
- **Title:** Login and registration rate protection
- **Description:** As the business, I want authentication attempts protected from abuse, so that accounts and platform availability are safeguarded.
- **Acceptance Criteria:** Sensitive authentication endpoints apply approved rate limits; users receive safe retry guidance; events are logged without credentials; legitimate flows remain usable.
- **Priority:** Must
- **Story Points:** 5
- **Dependencies:** US-AUTH-001, US-AUTH-002
- **Definition of Done:** Shared DoD; rate-limit behavior is documented and tested.
- **Business Value:** High
- **Risk Level:** High

## Epic 2 — User Profile

### US-PRO-001 — View profile

- **Epic:** User Profile
- **Title:** Personal profile overview
- **Description:** As an authenticated user, I want to view my basic profile, so that I can confirm the account information associated with my practice history.
- **Acceptance Criteria:** Only the current user’s permitted profile fields are displayed; loading, empty, and error states are accessible; data is not exposed to other users.
- **Priority:** Should
- **Story Points:** 3
- **Dependencies:** US-AUTH-002
- **Definition of Done:** Shared DoD.
- **Business Value:** Medium
- **Risk Level:** Low

### US-PRO-002 — Update profile

- **Epic:** User Profile
- **Title:** Edit basic profile details
- **Description:** As an authenticated user, I want to update approved profile details, so that my account remains accurate.
- **Acceptance Criteria:** Editable fields are defined and validated; valid changes persist; invalid changes show field errors; updates are restricted to the owner.
- **Priority:** Should
- **Story Points:** 3
- **Dependencies:** US-PRO-001
- **Definition of Done:** Shared DoD; authorization and validation are tested.
- **Business Value:** Medium
- **Risk Level:** Medium

### US-PRO-003 — Manage data deletion request

- **Epic:** User Profile
- **Title:** Request account deletion
- **Description:** As a user, I want to request deletion of my account and practice data, so that I can control my personal information.
- **Acceptance Criteria:** The request clearly states approved consequences; confirmation prevents accidental action; processing follows the approved retention/deletion policy; user is signed out when appropriate.
- **Priority:** Should
- **Story Points:** 8
- **Dependencies:** Approved retention/deletion policy, US-AUTH-003
- **Definition of Done:** Shared DoD; deletion/audit behavior is documented and tested.
- **Business Value:** High
- **Risk Level:** High

### US-PRO-004 — View privacy summary

- **Epic:** User Profile
- **Title:** Data-use transparency
- **Description:** As a privacy-conscious user, I want to understand how my interview data is used, so that I can make an informed decision to practice on the platform.
- **Acceptance Criteria:** Privacy summary is linked from relevant journeys; it explains voice/transcript, AI, report, and retention treatment in approved language; it is accessible without login.
- **Priority:** Must
- **Story Points:** 2
- **Dependencies:** Approved legal/privacy content
- **Definition of Done:** Shared DoD; content approval is recorded.
- **Business Value:** High
- **Risk Level:** Medium

## Epic 3 — Landing Website

### US-LAND-001 — Understand the value proposition

- **Epic:** Landing Website
- **Title:** Product marketing homepage
- **Description:** As a visitor, I want to understand what InterviewIQ AI offers, so that I can decide whether to try it.
- **Acceptance Criteria:** Homepage explains audience, key benefits, core flow, and primary CTA; content is responsive and accessible; CTA routes correctly to registration/login.
- **Priority:** Must
- **Story Points:** 5
- **Dependencies:** Product messaging approval
- **Definition of Done:** Shared DoD; analytics event for CTA is defined.
- **Business Value:** High
- **Risk Level:** Low

### US-LAND-002 — Understand voice compatibility

- **Epic:** Landing Website
- **Title:** Voice and browser expectations
- **Description:** As a visitor, I want to know voice/browser requirements before registering, so that I can avoid an unexpected setup failure.
- **Acceptance Criteria:** Supported browser guidance and typed fallback are clearly described; content does not overpromise speech recognition; help link is available.
- **Priority:** Must
- **Story Points:** 2
- **Dependencies:** Approved browser support matrix
- **Definition of Done:** Shared DoD.
- **Business Value:** Medium
- **Risk Level:** Low

### US-LAND-003 — Review trust information

- **Epic:** Landing Website
- **Title:** Terms and privacy access
- **Description:** As a visitor, I want to access terms and privacy information, so that I can assess whether the product handles my data responsibly.
- **Acceptance Criteria:** Approved legal pages are reachable from public navigation/footer; links work on mobile; pages are versioned or otherwise traceable for release governance.
- **Priority:** Must
- **Story Points:** 2
- **Dependencies:** Approved legal content
- **Definition of Done:** Shared DoD.
- **Business Value:** High
- **Risk Level:** Medium

### US-LAND-004 — Access responsive marketing content

- **Epic:** Landing Website
- **Title:** Responsive landing experience
- **Description:** As a mobile or desktop visitor, I want the landing website to work well on my device, so that I can evaluate the product without friction.
- **Acceptance Criteria:** Layout is usable at approved viewport sizes; keyboard navigation and contrast meet accessibility targets; major content does not overflow or become inaccessible.
- **Priority:** Must
- **Story Points:** 3
- **Dependencies:** US-LAND-001
- **Definition of Done:** Shared DoD; responsive and accessibility QA completed.
- **Business Value:** Medium
- **Risk Level:** Low

### US-LAND-005 — Measure acquisition sources

- **Epic:** Landing Website
- **Title:** Privacy-conscious acquisition analytics
- **Description:** As a product team member, I want to measure anonymized landing conversion signals, so that we can improve acquisition.
- **Acceptance Criteria:** Approved events track landing view and key CTA usage; collection follows privacy policy; events omit sensitive form content and credentials.
- **Priority:** Could
- **Story Points:** 3
- **Dependencies:** Analytics/privacy decision
- **Definition of Done:** Shared DoD; event catalog documented.
- **Business Value:** Medium
- **Risk Level:** Medium

## Epic 4 — Dashboard

### US-DASH-001 — See next best action

- **Epic:** Dashboard
- **Title:** Authenticated dashboard home
- **Description:** As an authenticated user, I want a clear dashboard landing page, so that I know whether to start, resume, or review an interview.
- **Acceptance Criteria:** Dashboard shows a prominent start action, eligible resume action, and useful empty state; only user-owned data is shown; loading/errors are handled.
- **Priority:** Must
- **Story Points:** 5
- **Dependencies:** US-AUTH-002, US-SET-001, US-ENG-004
- **Definition of Done:** Shared DoD.
- **Business Value:** High
- **Risk Level:** Low

### US-DASH-002 — See recent interview activity

- **Epic:** Dashboard
- **Title:** Recent interview summary
- **Description:** As a returning user, I want to see recent interviews, so that I can quickly continue my preparation.
- **Acceptance Criteria:** Recent records show status, date, and relevant configuration; selection routes to the correct owned interview; empty state is meaningful.
- **Priority:** Must
- **Story Points:** 3
- **Dependencies:** US-ENG-004, US-REP-003
- **Definition of Done:** Shared DoD.
- **Business Value:** High
- **Risk Level:** Low

### US-DASH-003 — See basic progress snapshot

- **Epic:** Dashboard
- **Title:** Practice progress summary
- **Description:** As a user, I want a simple progress snapshot, so that I can see whether repeated practice is helping.
- **Acceptance Criteria:** Summary uses only completed owned interviews; values reconcile with analytics; no data state has a helpful explanation; AI scores are labeled as advisory.
- **Priority:** Should
- **Story Points:** 5
- **Dependencies:** US-AN-001
- **Definition of Done:** Shared DoD; calculation tests included.
- **Business Value:** High
- **Risk Level:** Medium

### US-DASH-004 — Recover from dashboard failures

- **Epic:** Dashboard
- **Title:** Dashboard loading and recovery states
- **Description:** As a user, I want clear loading and retry states, so that temporary service problems do not leave me stranded.
- **Acceptance Criteria:** Loading, empty, unauthorized, and retryable error states are distinct and accessible; retry does not duplicate actions; support guidance is available for unexpected errors.
- **Priority:** Must
- **Story Points:** 3
- **Dependencies:** US-DASH-001
- **Definition of Done:** Shared DoD.
- **Business Value:** Medium
- **Risk Level:** Low

## Epic 5 — Interview Setup

### US-SET-001 — Configure an interview

- **Epic:** Interview Setup
- **Title:** Choose company, role, difficulty, and type
- **Description:** As a job seeker, I want to configure my mock interview, so that my practice matches my target opportunity.
- **Acceptance Criteria:** Required configuration fields are available; selections are validated client/server side; valid configuration can begin a session; invalid input is explained clearly.
- **Priority:** Must
- **Story Points:** 5
- **Dependencies:** US-AUTH-002, approved configuration catalog
- **Definition of Done:** Shared DoD; API/UI validation coverage included.
- **Business Value:** High
- **Risk Level:** Medium

### US-SET-002 — Understand interview format

- **Epic:** Interview Setup
- **Title:** Show interview expectations
- **Description:** As a user, I want to understand the interview format before I start, so that I can prepare appropriately.
- **Acceptance Criteria:** Setup displays approved question count/duration guidance, voice/typed options, and completion expectations; information updates based on selected template when applicable.
- **Priority:** Must
- **Story Points:** 3
- **Dependencies:** US-SET-001, interview template decision
- **Definition of Done:** Shared DoD.
- **Business Value:** Medium
- **Risk Level:** Low

### US-SET-003 — Check device readiness

- **Epic:** Interview Setup
- **Title:** Microphone and browser readiness
- **Description:** As a user, I want to check voice readiness before starting, so that I can choose voice or typing with confidence.
- **Acceptance Criteria:** UI communicates supported/unsupported/permission states; microphone use requires user action; typed fallback is always available; no microphone permission is requested unnecessarily.
- **Priority:** Must
- **Story Points:** 5
- **Dependencies:** US-VOICE-001, US-VOICE-004
- **Definition of Done:** Shared DoD; supported and unsupported scenarios are tested.
- **Business Value:** High
- **Risk Level:** Medium

### US-SET-004 — Save setup draft

- **Epic:** Interview Setup
- **Title:** Preserve unfinished configuration
- **Description:** As a user, I want my setup selections preserved while I navigate, so that I do not need to re-enter them accidentally.
- **Acceptance Criteria:** Approved draft behavior restores selections within the defined context; stale drafts do not create interviews; user can intentionally reset selections.
- **Priority:** Should
- **Story Points:** 3
- **Dependencies:** US-SET-001
- **Definition of Done:** Shared DoD.
- **Business Value:** Medium
- **Risk Level:** Low

### US-SET-005 — Use curated configuration options

- **Epic:** Interview Setup
- **Title:** Supported company and role catalog
- **Description:** As a user, I want clear supported company and role options, so that I can create a meaningful interview configuration.
- **Acceptance Criteria:** Catalog values are governed and validated; empty/search states are usable; fallback/free-form policy is explicitly implemented or excluded; invalid values cannot be persisted.
- **Priority:** Must
- **Story Points:** 5
- **Dependencies:** Product catalog decision
- **Definition of Done:** Shared DoD; catalog source and governance documented.
- **Business Value:** High
- **Risk Level:** Medium

### US-SET-006 — Select a practice mode

- **Epic:** Interview Setup
- **Title:** Choose interview template
- **Description:** As a user, I want to choose an available interview template, so that I can focus on behavioral, technical, or role-relevant practice.
- **Acceptance Criteria:** Only MVP-approved templates appear; each has a plain-language description; selection influences generation contract; unsupported combinations are prevented.
- **Priority:** Should
- **Story Points:** 5
- **Dependencies:** US-SET-001, prompt/template design
- **Definition of Done:** Shared DoD; template selection is covered in integration tests.
- **Business Value:** High
- **Risk Level:** Medium

## Epic 6 — AI Interview Engine

### US-ENG-001 — Generate tailored questions

- **Epic:** AI Interview Engine
- **Title:** Generate interview questions from configuration
- **Description:** As a user, I want questions generated for my selected role and difficulty, so that the mock interview feels relevant.
- **Acceptance Criteria:** Backend sends only approved context to Gemini; questions are structured, ordered, and persisted to the correct interview; malformed output is rejected; provider credentials remain server-side.
- **Priority:** Must
- **Story Points:** 13
- **Dependencies:** US-SET-001, Gemini integration decision, prompt contract
- **Definition of Done:** Shared DoD; schema validation, timeout, and provider failure tests included.
- **Business Value:** High
- **Risk Level:** High

### US-ENG-002 — Take a sequential interview

- **Epic:** AI Interview Engine
- **Title:** Present questions and progress
- **Description:** As a user, I want one question at a time with visible progress, so that I can focus and manage my interview session.
- **Acceptance Criteria:** Current question/order/progress are accurate; question text is accessible; user cannot submit to the wrong question; approved navigation behavior is enforced.
- **Priority:** Must
- **Story Points:** 5
- **Dependencies:** US-ENG-001, US-ANS-001
- **Definition of Done:** Shared DoD.
- **Business Value:** High
- **Risk Level:** Medium

### US-ENG-003 — Save answers safely

- **Epic:** AI Interview Engine
- **Title:** Persist question responses
- **Description:** As a user, I want submitted answers saved reliably, so that my work contributes to accurate feedback.
- **Acceptance Criteria:** Answer belongs to the active owned interview/question; validation rejects empty/invalid states; successful save is confirmed; safe retry does not create conflicting answers.
- **Priority:** Must
- **Story Points:** 8
- **Dependencies:** US-ENG-002
- **Definition of Done:** Shared DoD; idempotency/state-integrity tests included.
- **Business Value:** High
- **Risk Level:** High

### US-ENG-004 — Track interview status

- **Epic:** AI Interview Engine
- **Title:** Manage interview lifecycle
- **Description:** As a user, I want my interview status tracked, so that I know whether to start, resume, review, or wait for feedback.
- **Acceptance Criteria:** Approved lifecycle states are persisted; invalid transitions are rejected; dashboard/history display accurate state; transitions are auditable with safe diagnostic logs.
- **Priority:** Must
- **Story Points:** 8
- **Dependencies:** US-ENG-001, US-ENG-003
- **Definition of Done:** Shared DoD; state transition test matrix completed.
- **Business Value:** High
- **Risk Level:** High

### US-ENG-005 — Resume an interview

- **Epic:** AI Interview Engine
- **Title:** Resume in-progress practice
- **Description:** As a user, I want to resume an unfinished interview, so that a refresh or interruption does not waste my preparation effort.
- **Acceptance Criteria:** Eligible interview resumes at approved next state; saved answers are preserved; completed interviews cannot be resumed as active; ownership is enforced.
- **Priority:** Should
- **Story Points:** 5
- **Dependencies:** US-ENG-004
- **Definition of Done:** Shared DoD; refresh/resume scenarios tested.
- **Business Value:** High
- **Risk Level:** Medium

### US-ENG-006 — Complete an interview

- **Epic:** AI Interview Engine
- **Title:** Finalize practice session
- **Description:** As a user, I want to finish my interview deliberately, so that feedback can be generated from a complete response set.
- **Acceptance Criteria:** Completion confirms required answers/state; duplicate requests are safe; completed status is durable; user sees feedback processing status.
- **Priority:** Must
- **Story Points:** 5
- **Dependencies:** US-ENG-003, US-ENG-004
- **Definition of Done:** Shared DoD; completion/retry behavior tested.
- **Business Value:** High
- **Risk Level:** High

### US-ENG-007 — Generate structured feedback

- **Epic:** AI Interview Engine
- **Title:** Analyze completed interview
- **Description:** As a user, I want structured feedback after completing an interview, so that I know what to improve.
- **Acceptance Criteria:** Feedback contains approved overall assessment, strengths, improvements, question-level observations, and next actions; output is schema-validated; pending/failed/retry states are accurate.
- **Priority:** Must
- **Story Points:** 13
- **Dependencies:** US-ENG-006, Gemini feedback prompt/rubric
- **Definition of Done:** Shared DoD; evaluation samples and failure recovery tests included.
- **Business Value:** High
- **Risk Level:** High

### US-ENG-008 — Protect against AI-provider failures

- **Epic:** AI Interview Engine
- **Title:** Resilient AI service handling
- **Description:** As a user, I want AI delays or failures handled clearly, so that I do not lose data or receive misleading results.
- **Acceptance Criteria:** Timeouts, rate limits, malformed output, and provider outage states are distinguished internally; no corrupt data is persisted; retry policy is controlled; user-facing message is actionable.
- **Priority:** Must
- **Story Points:** 8
- **Dependencies:** US-ENG-001, US-ENG-007
- **Definition of Done:** Shared DoD; fault-injection/contract tests included.
- **Business Value:** High
- **Risk Level:** High

## Epic 7 — Voice Interview

### US-VOICE-001 — Check voice support

- **Epic:** Voice Interview
- **Title:** Detect speech-recognition capability
- **Description:** As a user, I want the product to identify whether voice input is available, so that I can choose the right answer method.
- **Acceptance Criteria:** Capability is detected without blocking typed entry; unsupported state is clearly described; detection respects browser privacy/permission behavior.
- **Priority:** Must
- **Story Points:** 3
- **Dependencies:** Browser support matrix
- **Definition of Done:** Shared DoD; compatibility tests documented.
- **Business Value:** High
- **Risk Level:** Medium

### US-VOICE-002 — Grant microphone permission

- **Epic:** Voice Interview
- **Title:** Permission-aware microphone access
- **Description:** As a user, I want to grant microphone permission intentionally, so that I can speak my response while retaining control over access.
- **Acceptance Criteria:** Permission request occurs only after user action; explanation precedes request; denial does not block typed answering; UI reflects current permission state.
- **Priority:** Must
- **Story Points:** 3
- **Dependencies:** US-VOICE-001
- **Definition of Done:** Shared DoD.
- **Business Value:** High
- **Risk Level:** Medium

### US-VOICE-003 — Transcribe spoken answer

- **Epic:** Voice Interview
- **Title:** Voice-to-text answer capture
- **Description:** As a user, I want my spoken answer transcribed, so that I can practice a natural interview response.
- **Acceptance Criteria:** Recognition states are visible; final transcript is shown in editable text; user can submit through the same validated answer path; raw audio is not stored in MVP.
- **Priority:** Must
- **Story Points:** 8
- **Dependencies:** US-VOICE-001, US-VOICE-002, US-ENG-003
- **Definition of Done:** Shared DoD; successful recognition lifecycle tested.
- **Business Value:** High
- **Risk Level:** High

### US-VOICE-004 — Fall back to typing

- **Epic:** Voice Interview
- **Title:** Accessible typed answer fallback
- **Description:** As a user without usable voice recognition, I want to type my response, so that I can complete every interview independently.
- **Acceptance Criteria:** Typed input is always available; it works after unsupported/denied/error recognition; switching method does not erase intentionally retained text; keyboard-only flow is complete.
- **Priority:** Must
- **Story Points:** 3
- **Dependencies:** US-ENG-003
- **Definition of Done:** Shared DoD; accessibility tests completed.
- **Business Value:** High
- **Risk Level:** Medium

### US-VOICE-005 — Recover from speech errors

- **Epic:** Voice Interview
- **Title:** Recognition error handling
- **Description:** As a user, I want understandable voice-error guidance, so that I can retry or continue typing without losing momentum.
- **Acceptance Criteria:** Permission, unsupported, network, timeout, interruption, and no-speech conditions show approved guidance; no stack traces are shown; typed fallback remains available.
- **Priority:** Must
- **Story Points:** 5
- **Dependencies:** US-VOICE-003, US-VOICE-004
- **Definition of Done:** Shared DoD; error-state matrix tested.
- **Business Value:** High
- **Risk Level:** Medium

### US-VOICE-006 — Review transcription before submitting

- **Epic:** Voice Interview
- **Title:** Edit spoken transcript
- **Description:** As a user, I want to review and edit a voice transcript, so that recognition inaccuracies do not distort my feedback.
- **Acceptance Criteria:** Final transcript is editable before answer submission; edits follow normal validation; user can discard transcript and type a replacement; state is accessible by keyboard.
- **Priority:** Should
- **Story Points:** 3
- **Dependencies:** US-VOICE-003
- **Definition of Done:** Shared DoD.
- **Business Value:** High
- **Risk Level:** Low

## Epic 8 — Interview Report

### US-REP-001 — View interview feedback

- **Epic:** Interview Report
- **Title:** Feedback results page
- **Description:** As a user, I want to view my completed interview feedback, so that I can understand my performance and plan improvement.
- **Acceptance Criteria:** Page shows approved feedback components; data matches selected owned interview; pending/failed states are clear; AI advisory language is present; layout is accessible.
- **Priority:** Must
- **Story Points:** 5
- **Dependencies:** US-ENG-007
- **Definition of Done:** Shared DoD.
- **Business Value:** High
- **Risk Level:** Medium

### US-REP-002 — Read question-level feedback

- **Epic:** Interview Report
- **Title:** Per-question coaching detail
- **Description:** As a user, I want feedback for each answer, so that I can identify concrete areas to improve.
- **Acceptance Criteria:** Each feedback item links to the correct question/answer context; missing content is handled gracefully; only owner can access details; content is safely rendered.
- **Priority:** Must
- **Story Points:** 5
- **Dependencies:** US-REP-001
- **Definition of Done:** Shared DoD; mapping/security tests included.
- **Business Value:** High
- **Risk Level:** Medium

### US-REP-003 — Browse interview history

- **Epic:** Interview Report
- **Title:** Interview history list
- **Description:** As a user, I want to see my previous interviews, so that I can revisit my practice and feedback.
- **Acceptance Criteria:** History contains owned eligible interviews with status/date/configuration; records are ordered consistently; empty/loading/error states are available; large result sets are bounded or paginated.
- **Priority:** Must
- **Story Points:** 5
- **Dependencies:** US-ENG-004, US-REP-001
- **Definition of Done:** Shared DoD; ownership/pagination tests included.
- **Business Value:** High
- **Risk Level:** Medium

### US-REP-004 — Download a report

- **Epic:** Interview Report
- **Title:** Export completed interview report
- **Description:** As a user, I want to download or print an interview report, so that I can review it offline or use it with a coach.
- **Acceptance Criteria:** Only completed owned interviews can be exported; report contains approved summary/feedback fields; downloadable or print-ready output is legible; failures allow safe retry and expose no other user data.
- **Priority:** Must
- **Story Points:** 8
- **Dependencies:** US-REP-001, approved report format
- **Definition of Done:** Shared DoD; export security and visual QA completed.
- **Business Value:** High
- **Risk Level:** Medium

### US-REP-005 — Rate feedback usefulness

- **Epic:** Interview Report
- **Title:** Feedback quality rating
- **Description:** As a user, I want to rate the usefulness of feedback, so that the product can improve its AI coaching quality.
- **Acceptance Criteria:** User can submit one approved rating for owned feedback; rating confirmation is clear; stored data minimizes sensitive content; repeat behavior follows approved policy.
- **Priority:** Should
- **Story Points:** 3
- **Dependencies:** US-REP-001, US-ADM-004
- **Definition of Done:** Shared DoD; analytics event/data contract documented.
- **Business Value:** Medium
- **Risk Level:** Low

### US-REP-006 — Filter history

- **Epic:** Interview Report
- **Title:** Find relevant past interviews
- **Description:** As a repeat user, I want to filter or sort my history, so that I can quickly find a comparable practice session.
- **Acceptance Criteria:** Approved filters/sorts apply only to user-owned records; state is clear and reversible; empty filtered state is meaningful; query remains performant.
- **Priority:** Should
- **Story Points:** 5
- **Dependencies:** US-REP-003
- **Definition of Done:** Shared DoD.
- **Business Value:** Medium
- **Risk Level:** Low

## Epic 9 — Analytics

### US-AN-001 — View practice analytics

- **Epic:** Analytics
- **Title:** Basic progress dashboard
- **Description:** As a user, I want to see basic practice trends, so that I can recognize progress and choose what to work on next.
- **Acceptance Criteria:** Approved metrics derive only from completed owned interviews; trends are internally consistent; empty state avoids misleading conclusions; charts/text alternatives are accessible.
- **Priority:** Must
- **Story Points:** 8
- **Dependencies:** US-ENG-007, US-REP-003
- **Definition of Done:** Shared DoD; metric calculation tests and accessibility QA completed.
- **Business Value:** High
- **Risk Level:** Medium

### US-AN-002 — Compare feedback over time

- **Epic:** Analytics
- **Title:** Improvement comparison
- **Description:** As a returning user, I want to compare assessments across interviews, so that I can see whether targeted practice is improving.
- **Acceptance Criteria:** Comparison uses compatible completed data; explanatory labels identify advisory AI scoring; users can access source interviews; missing/comparable-data limitations are explicit.
- **Priority:** Should
- **Story Points:** 8
- **Dependencies:** US-AN-001
- **Definition of Done:** Shared DoD; data-consistency tests completed.
- **Business Value:** High
- **Risk Level:** Medium

### US-AN-003 — See recommended focus areas

- **Epic:** Analytics
- **Title:** Improvement focus summary
- **Description:** As a user, I want my repeated improvement themes summarized, so that I can choose my next practice goal.
- **Acceptance Criteria:** Summary is derived from approved feedback fields; recommendations do not claim hiring prediction; no data state is clear; links to next interview setup where available.
- **Priority:** Should
- **Story Points:** 5
- **Dependencies:** US-AN-001, US-ENG-007
- **Definition of Done:** Shared DoD.
- **Business Value:** High
- **Risk Level:** Medium

### US-AN-004 — Capture product health events

- **Epic:** Analytics
- **Title:** Product funnel instrumentation
- **Description:** As a product team member, I want privacy-conscious funnel events, so that we can measure activation and completion.
- **Acceptance Criteria:** Event catalog covers approved lifecycle milestones; events omit passwords/tokens/raw answers; consent/privacy requirements are observed; data can calculate stated success metrics.
- **Priority:** Should
- **Story Points:** 5
- **Dependencies:** Privacy decision, US-ENG-004
- **Definition of Done:** Shared DoD; catalog and ownership documented.
- **Business Value:** High
- **Risk Level:** Medium

### US-AN-005 — Export personal analytics

- **Epic:** Analytics
- **Title:** Download progress summary
- **Description:** As a user, I want to export my high-level progress summary, so that I can discuss my preparation with a coach.
- **Acceptance Criteria:** Export is limited to approved, owned analytics; format is clear and accessible; it excludes secrets and unrelated data; failure is retryable.
- **Priority:** Could
- **Story Points:** 5
- **Dependencies:** US-AN-001, report export approach
- **Definition of Done:** Shared DoD.
- **Business Value:** Medium
- **Risk Level:** Low

## Epic 10 — Settings

### US-SETT-001 — Manage application preferences

- **Epic:** Settings
- **Title:** User preferences
- **Description:** As a user, I want to manage approved preferences, so that the product better fits how I practice.
- **Acceptance Criteria:** MVP-defined preferences are visible with defaults; valid changes persist per user; changes do not override security/privacy controls; state is accessible.
- **Priority:** Should
- **Story Points:** 3
- **Dependencies:** US-AUTH-002
- **Definition of Done:** Shared DoD.
- **Business Value:** Medium
- **Risk Level:** Low

### US-SETT-002 — Control notifications

- **Epic:** Settings
- **Title:** Notification preference controls
- **Description:** As a user, I want to choose whether I receive optional notifications, so that I stay in control of communication.
- **Acceptance Criteria:** Preferences use opt-in/opt-out rules approved by the business; changes take effect predictably; required service/security messages are distinguished from optional communication.
- **Priority:** Should
- **Story Points:** 5
- **Dependencies:** US-NOTIF-001, legal decision
- **Definition of Done:** Shared DoD; preference enforcement tested.
- **Business Value:** Medium
- **Risk Level:** Medium

### US-SETT-003 — Manage accessibility preferences

- **Epic:** Settings
- **Title:** Accessibility accommodations
- **Description:** As a user, I want appropriate display and interaction preferences, so that I can use InterviewIQ AI comfortably.
- **Acceptance Criteria:** Approved preference options have accessible labels and defaults; changes do not reduce WCAG baseline compliance; user can reset preferences.
- **Priority:** Could
- **Story Points:** 5
- **Dependencies:** Accessibility design decision
- **Definition of Done:** Shared DoD.
- **Business Value:** Medium
- **Risk Level:** Low

### US-SETT-004 — View account security information

- **Epic:** Settings
- **Title:** Security and session guidance
- **Description:** As a user, I want to understand my account’s security controls, so that I can keep my access safe.
- **Acceptance Criteria:** Page provides approved password/session guidance and logout action; it does not expose tokens or sensitive internals; content links to reset process when delivered.
- **Priority:** Should
- **Story Points:** 2
- **Dependencies:** US-AUTH-003, US-AUTH-004
- **Definition of Done:** Shared DoD.
- **Business Value:** Medium
- **Risk Level:** Low

## Epic 11 — Notifications

### US-NOTIF-001 — Receive feedback-ready notice

- **Epic:** Notifications
- **Title:** Feedback completion notification
- **Description:** As a user, I want to know when my feedback is ready, so that I can return to review it without repeatedly checking.
- **Acceptance Criteria:** Approved in-app and/or email notification is sent only after feedback is available; link routes to owned feedback; delivery failure is observable and does not affect feedback availability.
- **Priority:** Should
- **Story Points:** 8
- **Dependencies:** US-ENG-007, notification channel decision, US-SETT-002
- **Definition of Done:** Shared DoD; preference and delivery tests included.
- **Business Value:** Medium
- **Risk Level:** Medium

### US-NOTIF-002 — Receive practice reminder

- **Epic:** Notifications
- **Title:** Optional practice reminder
- **Description:** As a user, I want optional reminders to practice, so that I can maintain a consistent preparation routine.
- **Acceptance Criteria:** User explicitly opts in; timing/frequency follows approved rules; unsubscribe/preference change is honored; reminders avoid sensitive answer content.
- **Priority:** Could
- **Story Points:** 8
- **Dependencies:** US-SETT-002, notification infrastructure
- **Definition of Done:** Shared DoD; scheduling and opt-out tests completed.
- **Business Value:** Medium
- **Risk Level:** Medium

### US-NOTIF-003 — See in-app status messages

- **Epic:** Notifications
- **Title:** Action outcome notifications
- **Description:** As a user, I want timely in-app status messages, so that I know whether important actions succeeded or require attention.
- **Acceptance Criteria:** Success, warning, pending, and error messages are accessible; messages do not expose sensitive detail; transient notifications do not replace durable feedback for critical states.
- **Priority:** Must
- **Story Points:** 3
- **Dependencies:** Shared UI foundation
- **Definition of Done:** Shared DoD; keyboard/screen-reader behavior tested.
- **Business Value:** High
- **Risk Level:** Low

### US-NOTIF-004 — Receive service incident communication

- **Epic:** Notifications
- **Title:** Service-status messaging
- **Description:** As a user affected by a material processing issue, I want clear service-status information, so that I understand what happened to my interview or feedback.
- **Acceptance Criteria:** Product surfaces approved outage/degradation messages; messages are factual and non-sensitive; retry/support route is available; internal incident details remain private.
- **Priority:** Should
- **Story Points:** 5
- **Dependencies:** US-ENG-008, operational monitoring
- **Definition of Done:** Shared DoD; documented operational playbook exists.
- **Business Value:** Medium
- **Risk Level:** Medium

## Epic 12 — Admin

### US-ADM-001 — Monitor application health

- **Epic:** Admin
- **Title:** Operational health visibility
- **Description:** As an operations team member, I want to see service health and core failure signals, so that I can respond before user issues become widespread.
- **Acceptance Criteria:** Health checks and approved dashboards show service status; access is least privilege; health data excludes user secrets; alerts follow documented thresholds.
- **Priority:** Must
- **Story Points:** 8
- **Dependencies:** Deployment platform, observability design
- **Definition of Done:** Shared DoD; runbook and alert test completed.
- **Business Value:** High
- **Risk Level:** Medium

### US-ADM-002 — Review operational errors

- **Epic:** Admin
- **Title:** Structured error observability
- **Description:** As an operations team member, I want correlated error records, so that I can diagnose failed core journeys without exposing sensitive user data.
- **Acceptance Criteria:** Logs include approved correlation/event context; credentials/tokens/raw answers are excluded; access is restricted; errors can be traced to service and release version.
- **Priority:** Must
- **Story Points:** 5
- **Dependencies:** US-ADM-001
- **Definition of Done:** Shared DoD; log-scrubbing review completed.
- **Business Value:** High
- **Risk Level:** High

### US-ADM-003 — Manage configuration catalog

- **Epic:** Admin
- **Title:** Govern interview configuration options
- **Description:** As a product operations member, I want a controlled way to manage approved interview configuration values, so that users receive valid choices.
- **Acceptance Criteria:** MVP governance approach is documented; changes are authorized, auditable, and validated; invalid/deprecated options do not break existing interviews.
- **Priority:** Could
- **Story Points:** 8
- **Dependencies:** US-SET-005, admin authorization design
- **Definition of Done:** Shared DoD; audit/rollback approach defined.
- **Business Value:** Medium
- **Risk Level:** Medium

### US-ADM-004 — Review feedback quality trends

- **Epic:** Admin
- **Title:** Feedback quality monitoring
- **Description:** As a product operations member, I want aggregated feedback ratings and failure trends, so that we can improve the AI interview experience.
- **Acceptance Criteria:** Data is aggregated and privacy-conscious; no unrestricted raw user interview content is required; trends distinguish provider/validation failures from ratings; access is least privilege.
- **Priority:** Should
- **Story Points:** 5
- **Dependencies:** US-REP-005, US-AN-004
- **Definition of Done:** Shared DoD; access/data minimization review completed.
- **Business Value:** High
- **Risk Level:** Medium

### US-ADM-005 — Run deployment and recovery procedures

- **Epic:** Admin
- **Title:** Release operational readiness
- **Description:** As an operations team member, I want documented deployment, migration, backup, and recovery procedures, so that releases and incidents are managed safely.
- **Acceptance Criteria:** Procedures are reproducible in a non-production environment; rollback/recovery ownership is defined; database migration and secret handling are included; runbook is reviewed before launch.
- **Priority:** Must
- **Story Points:** 5
- **Dependencies:** CI/CD and hosting decisions
- **Definition of Done:** Shared DoD; readiness exercise recorded.
- **Business Value:** High
- **Risk Level:** High

## Epic 13 — Future Features

### US-FUT-001 — Upload a resume

- **Epic:** Future Features
- **Title:** Resume upload
- **Description:** As a job seeker, I want to upload my resume, so that interview practice can reflect my own experience.
- **Acceptance Criteria:** Not implemented in MVP; future scope requires secure upload, file validation, consent, malware handling, retention policy, and clear data-use disclosure.
- **Priority:** Won't
- **Story Points:** 13
- **Dependencies:** Privacy/legal approval, document-processing architecture
- **Definition of Done:** Post-MVP discovery and security design completed before implementation.
- **Business Value:** High
- **Risk Level:** High

### US-FUT-002 — Generate resume-grounded questions

- **Epic:** Future Features
- **Title:** Personalized resume interview
- **Description:** As a user, I want questions grounded in my resume, so that the practice closely matches how I may be interviewed.
- **Acceptance Criteria:** Not implemented in MVP; future solution must require explicit consent, source traceability, secure processing, and safe AI evaluation.
- **Priority:** Won't
- **Story Points:** 13
- **Dependencies:** US-FUT-001, prompt/evaluation framework
- **Definition of Done:** Post-MVP architecture and acceptance rubric approved.
- **Business Value:** High
- **Risk Level:** High

### US-FUT-003 — Practice in other languages

- **Epic:** Future Features
- **Title:** Multilingual interviews
- **Description:** As a non-English-speaking user, I want to practice in my preferred language, so that I can prepare in the language relevant to my interview.
- **Acceptance Criteria:** Not implemented in MVP; future scope requires localized UI, supported speech matrix, localized prompts/rubrics, and language-quality testing.
- **Priority:** Won't
- **Story Points:** 13
- **Dependencies:** Localization strategy, provider capability validation
- **Definition of Done:** Post-MVP language rollout plan approved.
- **Business Value:** High
- **Risk Level:** High

### US-FUT-004 — Analyze speech delivery

- **Epic:** Future Features
- **Title:** Advanced speaking metrics
- **Description:** As a user, I want feedback on pace, pauses, and filler words, so that I can improve my spoken delivery.
- **Acceptance Criteria:** Not implemented in MVP; future design must establish accuracy limits, consent, privacy treatment, accessibility impact, and browser/device strategy.
- **Priority:** Won't
- **Story Points:** 13
- **Dependencies:** Audio-processing architecture, legal/privacy review
- **Definition of Done:** Post-MVP feasibility and risk assessment accepted.
- **Business Value:** High
- **Risk Level:** High

### US-FUT-005 — Subscribe to paid plans

- **Epic:** Future Features
- **Title:** Billing and entitlements
- **Description:** As a frequent user, I want to subscribe to a plan, so that I can access premium practice capabilities.
- **Acceptance Criteria:** Not implemented in MVP; future scope requires pricing, payment provider, taxes, invoices, entitlement enforcement, cancellation, and support processes.
- **Priority:** Won't
- **Story Points:** 13
- **Dependencies:** Commercial model, payments architecture, legal review
- **Definition of Done:** Post-MVP monetization requirements approved.
- **Business Value:** High
- **Risk Level:** High

### US-FUT-006 — Work with a coach or team

- **Epic:** Future Features
- **Title:** Shared coaching workspace
- **Description:** As a candidate, I want to share selected reports with a coach, so that I can receive guided support.
- **Acceptance Criteria:** Not implemented in MVP; future scope requires explicit consent, sharing controls, revocation, role-based access, audit trails, and organization data boundaries.
- **Priority:** Won't
- **Story Points:** 13
- **Dependencies:** Multi-tenant authorization design, privacy review
- **Definition of Done:** Post-MVP access-control model approved.
- **Business Value:** High
- **Risk Level:** High

### US-FUT-007 — Use video interviews

- **Epic:** Future Features
- **Title:** Video mock interview
- **Description:** As a user, I want to practice through video, so that the experience more closely resembles a live interview.
- **Acceptance Criteria:** Not implemented in MVP; future scope requires consent, media architecture, storage policy, device testing, and enhanced privacy/security controls.
- **Priority:** Won't
- **Story Points:** 13
- **Dependencies:** Media platform decision, legal/privacy review
- **Definition of Done:** Post-MVP feasibility decision completed.
- **Business Value:** Medium
- **Risk Level:** High

### US-FUT-008 — Receive adaptive practice plans

- **Epic:** Future Features
- **Title:** Personalized learning plan
- **Description:** As a repeat user, I want an adaptive practice plan, so that my preparation targets the gaps that matter most.
- **Acceptance Criteria:** Not implemented in MVP; future recommendation logic must be explainable, based on approved data, and allow user control.
- **Priority:** Won't
- **Story Points:** 13
- **Dependencies:** US-AN-002, evaluation framework
- **Definition of Done:** Post-MVP recommendation ethics/quality review approved.
- **Business Value:** High
- **Risk Level:** High

## Additional Refined Stories by Existing Epic

### US-AUTH-007 — Verify an email address

- **Epic:** Authentication
- **Title:** Email verification
- **Description:** As a newly registered user, I want to verify my email address, so that the platform can protect my account and communicate reliably.
- **Acceptance Criteria:** Verification uses an expiring, single-use mechanism; resend requests are rate protected; verified state is recorded; account existence is not unnecessarily disclosed.
- **Priority:** Should
- **Story Points:** 5
- **Dependencies:** US-AUTH-001, email delivery decision
- **Definition of Done:** Shared DoD; expiry, resend, and abuse controls are tested.
- **Business Value:** High
- **Risk Level:** High

### US-PRO-005 — Complete first-use onboarding

- **Epic:** User Profile
- **Title:** New-user orientation
- **Description:** As a new user, I want a brief orientation, so that I understand how to begin my first mock interview.
- **Acceptance Criteria:** Onboarding explains approved core steps; it can be skipped and revisited; it does not block core use; completion state follows the approved product design.
- **Priority:** Should
- **Story Points:** 3
- **Dependencies:** US-DASH-001
- **Definition of Done:** Shared DoD; accessibility and empty-state review completed.
- **Business Value:** High
- **Risk Level:** Low

### US-LAND-006 — Review common questions

- **Epic:** Landing Website
- **Title:** Public FAQ
- **Description:** As a visitor, I want answers to common product questions, so that I can decide whether InterviewIQ AI is right for me.
- **Acceptance Criteria:** FAQ covers approved topics including AI feedback, voice support, typing fallback, privacy, and report access; answers are accessible and do not make unsupported claims.
- **Priority:** Should
- **Story Points:** 2
- **Dependencies:** Product/legal messaging approval
- **Definition of Done:** Shared DoD; content has product-owner approval.
- **Business Value:** Medium
- **Risk Level:** Low

### US-DASH-005 — Start a new interview quickly

- **Epic:** Dashboard
- **Title:** Quick-start interview action
- **Description:** As a returning user, I want to start a new interview from the dashboard, so that I can begin practice with minimal navigation.
- **Acceptance Criteria:** A clear action routes to interview setup; it does not overwrite an in-progress session; keyboard and mobile use are supported.
- **Priority:** Should
- **Story Points:** 2
- **Dependencies:** US-DASH-001, US-SET-001
- **Definition of Done:** Shared DoD.
- **Business Value:** Medium
- **Risk Level:** Low

### US-SET-007 — Confirm readiness before start

- **Epic:** Interview Setup
- **Title:** Interview start confirmation
- **Description:** As a user, I want a final setup confirmation, so that I can verify my chosen interview details before questions are generated.
- **Acceptance Criteria:** Confirmation shows selected configuration and input mode; user can return to edit; starting creates no duplicate session on repeated interaction.
- **Priority:** Should
- **Story Points:** 3
- **Dependencies:** US-SET-001, US-SET-003
- **Definition of Done:** Shared DoD; duplicate-submit protection tested.
- **Business Value:** Medium
- **Risk Level:** Low

### US-ENG-009 — Exit an in-progress interview safely

- **Epic:** AI Interview Engine
- **Title:** Pause or abandon practice session
- **Description:** As a user, I want to leave an interview safely, so that I retain approved progress without accidentally completing it.
- **Acceptance Criteria:** Exit behavior explains whether progress is saved; saved sessions remain resumable where eligible; abandoning requires confirmation; no feedback is generated for incomplete sessions.
- **Priority:** Should
- **Story Points:** 5
- **Dependencies:** US-ENG-004, US-ENG-005
- **Definition of Done:** Shared DoD; lifecycle and data-retention behavior tested.
- **Business Value:** Medium
- **Risk Level:** Medium

### US-VOICE-007 — Understand voice data handling

- **Epic:** Voice Interview
- **Title:** Voice privacy disclosure
- **Description:** As a user, I want to understand what happens to my spoken response, so that I can choose voice input with informed consent.
- **Acceptance Criteria:** Before voice use, approved copy explains browser recognition and transcript treatment; raw-audio storage policy is explicit; typed fallback is prominent; disclosure is accessible.
- **Priority:** Must
- **Story Points:** 2
- **Dependencies:** Approved privacy content, US-VOICE-002
- **Definition of Done:** Shared DoD; legal/product approval recorded.
- **Business Value:** High
- **Risk Level:** Medium

### US-REP-007 — Regenerate an eligible report

- **Epic:** Interview Report
- **Title:** Retry report generation
- **Description:** As a user whose report export failed, I want to retry it safely, so that I can still obtain my completed interview report.
- **Acceptance Criteria:** Eligible failed export can be retried; duplicate requests do not leak or corrupt data; success/failure status is visible; only owner can retry.
- **Priority:** Should
- **Story Points:** 3
- **Dependencies:** US-REP-004
- **Definition of Done:** Shared DoD; retry/idempotency tests included.
- **Business Value:** Medium
- **Risk Level:** Medium

### US-AN-006 — Set a practice focus

- **Epic:** Analytics
- **Title:** Personal improvement goal
- **Description:** As a user, I want to set a simple practice focus, so that I can make my next interview session intentional.
- **Acceptance Criteria:** User can select or enter an approved goal; goal is private by default; it is shown in relevant dashboard/setup context; user can update or remove it.
- **Priority:** Could
- **Story Points:** 3
- **Dependencies:** US-AN-003, US-SETT-001
- **Definition of Done:** Shared DoD; validation and ownership tests completed.
- **Business Value:** Medium
- **Risk Level:** Low

## Product Backlog

The backlog contains **80 user stories** across 13 epics. The following sequencing reflects value, risk reduction, and dependency order; it is not a commitment until capacity and design are confirmed.

| Backlog Order | Epic | Stories | Release Intent |
| ---: | --- | --- | --- |
| 1 | Authentication | US-AUTH-001 to US-AUTH-003, US-AUTH-005, US-AUTH-006 | MVP foundation |
| 2 | Landing Website | US-LAND-001 to US-LAND-004 | MVP acquisition/trust |
| 3 | Interview Setup | US-SET-001 to US-SET-003, US-SET-005 | MVP core |
| 4 | Voice Interview | US-VOICE-001 to US-VOICE-005 | MVP core |
| 5 | AI Interview Engine | US-ENG-001 to US-ENG-008 | MVP core and highest technical risk |
| 6 | Interview Report | US-REP-001 to US-REP-004 | MVP value realization |
| 7 | Dashboard | US-DASH-001, US-DASH-002, US-DASH-004 | MVP navigation/recovery |
| 8 | Analytics | US-AN-001 | MVP retention value |
| 9 | Admin | US-ADM-001, US-ADM-002, US-ADM-005 | MVP launch readiness |
| 10 | Notifications | US-NOTIF-003 | MVP UX quality |
| 11 | User Profile | US-PRO-004 | MVP trust/legal dependency |
| 12 | Remaining Should/Could stories | All Should/Could items | Post-MVP or capacity-based |
| 13 | Future Features | US-FUT-001 to US-FUT-008 | Explicitly post-MVP |

## Sprint Plan

The following is an indicative plan for a single cross-functional MVP team after Phase 0 approval. Sprint capacity must be calibrated from actual velocity; unestimated discovery tasks and integration spikes may be added without inflating the MVP scope.

| Sprint | Objective | Planned Story Focus | Key Outcome |
| --- | --- | --- | --- |
| Sprint 0 (1 week) | Delivery foundation and refinement | Architecture/API/UX refinement; CI, environments, observability, test strategy; no customer feature commitment | Implementation-ready baseline |
| Sprint 1 (2 weeks) | Establish secure entry and conversion | US-LAND-001–004, US-AUTH-001–003, US-AUTH-005, US-AUTH-006, US-PRO-004, US-NOTIF-003 | Secure user can enter product |
| Sprint 2 (2 weeks) | Create and configure interview | US-SET-001–003, US-SET-005, US-ENG-004 foundation, US-DASH-001 | User can configure a durable interview |
| Sprint 3 (2 weeks) | Deliver answer-taking experience | US-ENG-001–003, US-ENG-002, US-VOICE-001–005 | User can complete questions by voice or text |
| Sprint 4 (2 weeks) | Deliver AI value moment | US-ENG-006–008, US-REP-001–002, US-DASH-002/004 | User receives resilient feedback |
| Sprint 5 (2 weeks) | Complete retention and report loop | US-REP-003–004, US-AN-001, US-ADM-001–002/005 | User can review, export, and product is launch-operable |
| Sprint 6 (1–2 weeks) | Hardening and beta | Cross-browser, accessibility, security, performance, reliability, UAT, defect fixes | Controlled MVP launch readiness |

## MVP Stories

The MVP comprises all **Must** stories below. Should stories may be admitted only if they do not threaten the launch criteria or hardening capacity.

- Authentication: US-AUTH-001, US-AUTH-002, US-AUTH-003, US-AUTH-005, US-AUTH-006.
- User Profile: US-PRO-004.
- Landing Website: US-LAND-001, US-LAND-002, US-LAND-003, US-LAND-004.
- Dashboard: US-DASH-001, US-DASH-002, US-DASH-004.
- Interview Setup: US-SET-001, US-SET-002, US-SET-003, US-SET-005.
- AI Interview Engine: US-ENG-001, US-ENG-002, US-ENG-003, US-ENG-004, US-ENG-006, US-ENG-007, US-ENG-008.
- Voice Interview: US-VOICE-001, US-VOICE-002, US-VOICE-003, US-VOICE-004, US-VOICE-005, US-VOICE-007.
- Interview Report: US-REP-001, US-REP-002, US-REP-003, US-REP-004.
- Analytics: US-AN-001.
- Notifications: US-NOTIF-003.
- Admin: US-ADM-001, US-ADM-002, US-ADM-005.

## Post-MVP Stories

### Priority Should

US-AUTH-004, US-PRO-001–003, US-DASH-003, US-SET-004, US-SET-006, US-ENG-005, US-VOICE-006, US-REP-005–006, US-AN-002–004, US-SETT-001–002/004, US-NOTIF-001/004, and US-ADM-004.

### Priority Could

US-LAND-005, US-AN-005, US-SETT-003, US-NOTIF-002, and US-ADM-003.

### Explicitly Won’t Have in MVP

US-FUT-001 through US-FUT-008: resume intelligence, multilingual support, advanced speech analysis, billing, shared coaching/team capability, video, and adaptive learning plans.

---

**Backlog governance:** The Product Owner owns priority. The delivery team refines estimates and dependencies. Scope changes require impact assessment against the MVP acceptance criteria, roadmap milestones, capacity, security, and privacy obligations.

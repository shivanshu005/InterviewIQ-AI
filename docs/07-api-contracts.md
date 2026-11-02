# InterviewIQ AI — REST API Contract

**Document status:** Draft for Phase 0 API review  
**Contract style:** REST over HTTPS, OpenAPI 3.1-compatible  
**Base URL:** `https://api.interviewiq.ai/api/v1` (production; environment-specific hostnames vary)  
**Content type:** `application/json; charset=utf-8` unless an export response specifies otherwise

## 1. Contract Principles

- The API is versioned in the URL. Breaking changes require a new version; additive changes remain backward compatible.
- Every endpoint uses HTTPS. JSON request bodies must declare `Content-Type: application/json`.
- Authenticated endpoints require `Authorization: Bearer <access-token>` using the approved JWT transport strategy.
- The server is authoritative for authorization, ownership, validation, interview lifecycle, and AI-provider invocation. Client-side checks do not replace server checks.
- IDs are opaque positive integers in this initial contract. Clients must not infer ordering or internal meaning from them.
- All server timestamps use ISO 8601 UTC (`2026-07-28T10:30:00.000000Z`).
- Successful mutations return a resource representation or operation status. `DELETE` means a controlled soft-delete/lifecycle operation where the data model specifies it.
- Unknown JSON fields may be rejected to prevent mass assignment. Clients must not send server-managed audit, ownership, score, status, or provider fields.

## 2. Shared Conventions

### 2.1 Error Envelope

Every non-success response uses the following stable envelope. `fieldErrors` appears only for safe validation feedback. `correlationId` must be supplied to support when present.

```json
{
  "error": {
    "code": "VALIDATION_FAILED",
    "message": "One or more fields are invalid.",
    "fieldErrors": [
      { "field": "email", "code": "INVALID_FORMAT", "message": "Enter a valid email address." }
    ],
    "correlationId": "b7a0f84e-6ed3-47b1-9dea-2af4e38f95b8"
  }
}
```

### 2.2 Common Error Codes

| Code | HTTP | Meaning |
| --- | ---: | --- |
| `VALIDATION_FAILED` | 400 | Request shape, value, or state validation failed. |
| `UNAUTHENTICATED` | 401 | Missing, expired, malformed, or invalid credential. |
| `FORBIDDEN` | 403 | Authenticated caller lacks the required capability. |
| `NOT_FOUND` | 404 | Resource does not exist or is intentionally non-disclosed. |
| `CONFLICT` | 409 | Duplicate resource, stale state, or conflicting/idempotent mutation. |
| `RATE_LIMITED` | 429 | Caller exceeded endpoint policy; `Retry-After` may be present. |
| `AI_PROVIDER_UNAVAILABLE` | 503 | Gemini dependency is temporarily unavailable. |
| `OPERATION_PENDING` | 409 | Requested result is still being generated. |
| `INTERNAL_ERROR` | 500 | Unexpected safe server failure. |

### 2.3 Pagination, Filtering, and Sorting

Collection endpoints use cursor pagination unless marked “not applicable.” Request parameters are `limit` (default 20, minimum 1, maximum 100) and optional opaque `cursor`. Response payloads use:

```json
{
  "data": [],
  "page": { "nextCursor": "opaque-cursor-or-null", "limit": 20 }
}
```

Filters are endpoint-specific and use explicit query parameters. Sort uses `sort` with a whitelisted field and `order=asc|desc`; unsupported filters/sorts return `VALIDATION_FAILED`. Cursor pagination guarantees no duplicate records within a stable query ordering but does not promise a cross-request snapshot under concurrent writes.

### 2.4 Rate Limiting and Idempotency

Limits are per authenticated user and source IP where applicable, enforced in a rolling one-minute window. Responses include `X-RateLimit-Limit`, `X-RateLimit-Remaining`, and, where applicable, `Retry-After`. Published limits are product-safety defaults and may be tightened during abuse events.

For client-retryable creation/generation operations, clients should send `Idempotency-Key` as a unique UUID per intended action. The server retains idempotency records for the approved period and returns the original successful/accepted result for a duplicate key with the same canonical request. Reusing a key with different input returns `CONFLICT`.

### 2.5 Shared Resource Shapes

- **User:** `id`, `email`, `displayName`, `status`, `emailVerified`, `createdAt`, `updatedAt`.
- **InterviewSession:** `id`, `company`, `jobRole`, `difficultyLevel`, `template`, `status`, `questionCount`, `answeredCount`, `createdAt`, `startedAt`, `completedAt`.
- **InterviewQuestion:** `id`, `sequenceNumber`, `questionText`, `questionType`, `answerStatus`.
- **Feedback:** `status`, `overallScore`, `overallAssessment`, `strengths`, `improvementAreas`, `recommendedActions`, `questionFeedback`, `generatedAt`.
- **Report:** `id`, `format`, `status`, `generatedAt`, `expiresAt`, `downloadUrl` (short-lived when available).

## 3. Endpoint Contract Summary

The detailed module sections below define every MVP endpoint. “Body: —” means no request body. “Page/filter/sort: —” means not applicable.

| ID | Method & URL | Purpose | Auth | Request / Response | Pagination, Filtering, Sorting | Rate Limit |
| --- | --- | --- | --- | --- | --- | --- |
| AUTH-01 | `POST /auth/register` | Register account | No | RegisterRequest → User + session | — | 5/IP/min |
| AUTH-02 | `POST /auth/login` | Authenticate user | No | LoginRequest → session | — | 10/IP/min |
| AUTH-03 | `POST /auth/logout` | End current session | Yes | — → 204 | — | 30/user/min |
| AUTH-04 | `POST /auth/password-reset-requests` | Request reset | No | email → 202 | — | 3/IP/hour |
| AUTH-05 | `POST /auth/password-resets` | Complete reset | No | token/password → 204 | — | 5/IP/hour |
| USER-01 | `GET /users/me` | Read own profile | Yes | — → User | — | 120/user/min |
| USER-02 | `PATCH /users/me` | Update own profile | Yes | ProfilePatch → User | — | 30/user/min |
| USER-03 | `DELETE /users/me` | Request controlled account deletion | Yes | confirmation → 202 | — | 3/user/day |
| DASH-01 | `GET /dashboard` | Read next action/recent summary | Yes | — → Dashboard | — | 60/user/min |
| COMP-01 | `GET /companies` | List company catalog | Yes | — → Company[] | cursor, `q`, `active`, name | 120/user/min |
| ROLE-01 | `GET /job-roles` | List job role catalog | Yes | — → JobRole[] | cursor, `q`, `category`, name | 120/user/min |
| ROLE-02 | `GET /difficulty-levels` | List difficulty catalog | Yes | — → Difficulty[] | — | 120/user/min |
| ROLE-03 | `GET /interview-templates` | List interview templates | Yes | — → Template[] | cursor, `active`, name | 120/user/min |
| INT-01 | `POST /interview-sessions` | Create and generate questions | Yes | CreateInterview → InterviewSession | — | 6/user/hour |
| INT-02 | `GET /interview-sessions` | List own interviews | Yes | — → InterviewSession[] | cursor, `status`, `companyId`, `jobRoleId`, `from`, `to`, createdAt | 60/user/min |
| INT-03 | `GET /interview-sessions/{id}` | Read owned interview state | Yes | — → InterviewSession detail | — | 120/user/min |
| INT-04 | `POST /interview-sessions/{id}/start` | Mark ready session in progress | Yes | — → InterviewSession | — | 20/user/min |
| INT-05 | `POST /interview-sessions/{id}/complete` | Complete and trigger feedback | Yes | — → operation status | — | 10/user/hour |
| INT-06 | `POST /interview-sessions/{id}/cancel` | Cancel eligible session | Yes | reason? → InterviewSession | — | 10/user/hour |
| Q-01 | `GET /interview-sessions/{id}/questions` | List owned questions | Yes | — → Question[] | — | 120/user/min |
| Q-02 | `GET /interview-sessions/{id}/questions/{questionId}` | Read one owned question | Yes | — → Question | — | 120/user/min |
| ANS-01 | `PUT /interview-sessions/{id}/questions/{questionId}/answer` | Create/replace current answer | Yes | AnswerRequest → Answer | — | 60/user/min |
| ANS-02 | `GET /interview-sessions/{id}/questions/{questionId}/answer` | Read own answer | Yes | — → Answer | — | 120/user/min |
| AI-01 | `GET /interview-sessions/{id}/feedback` | Read feedback/status | Yes | — → Feedback | — | 60/user/min |
| AI-02 | `POST /interview-sessions/{id}/feedback/retry` | Retry eligible feedback generation | Yes | — → operation status | — | 3/user/hour |
| REP-01 | `POST /interview-sessions/{id}/reports` | Request report generation | Yes | ReportRequest → Report | — | 10/user/hour |
| REP-02 | `GET /interview-sessions/{id}/reports` | List report statuses | Yes | — → Report[] | cursor, `status`, `format`, generatedAt | 60/user/min |
| REP-03 | `GET /interview-sessions/{id}/reports/{reportId}/download` | Redirect or return download URL | Yes | — → 302 / ReportDownload | — | 30/user/min |
| AN-01 | `GET /analytics/overview` | Read own practice metrics | Yes | — → AnalyticsOverview | — | 30/user/min |
| AN-02 | `GET /analytics/trends` | Read score/completion trends | Yes | — → Trend[] | `from`, `to`, `groupBy`; date | 30/user/min |
| NOTIF-01 | `GET /notifications` | List own notifications | Yes | — → Notification[] | cursor, `status`, `type`, createdAt | 60/user/min |
| NOTIF-02 | `POST /notifications/{id}/read` | Mark notification read | Yes | — → Notification | — | 60/user/min |
| SET-01 | `GET /settings` | Read own preferences | Yes | — → Settings | — | 60/user/min |
| SET-02 | `PATCH /settings` | Update own preferences | Yes | SettingsPatch → Settings | — | 30/user/min |

## 4. Authentication Module

### AUTH-01 — Register

- **Purpose:** Create a candidate account and establish an approved session or return a verification-required state.
- **HTTP Method / URL:** `POST /auth/register`
- **Authentication:** None.
- **Request Body:** `RegisterRequest`: `email` (string), `password` (string), optional `displayName` (string).
- **Response Body:** `201 Created` with `User` and `SessionResponse` (`accessToken` only if approved transport returns it in JSON; otherwise secure response cookies are set).
- **Validation Rules:** Email is normalized and valid, maximum 254 characters; password follows approved policy (minimum 12 characters, at least one upper/lower/number; exact policy may be tightened); display name is trimmed, 1–120 characters if supplied; email uniqueness is case-insensitive.
- **Status Codes:** `201`, `400`, `409`, `429`, `500`.
- **Error Codes:** `VALIDATION_FAILED`, `CONFLICT`, `RATE_LIMITED`, `INTERNAL_ERROR`.
- **Pagination / Filtering / Sorting:** Not applicable.
- **Rate Limiting:** 5 requests per IP per minute.

### AUTH-02 — Login

- **Purpose:** Authenticate a registered user.
- **HTTP Method / URL:** `POST /auth/login`
- **Authentication:** None.
- **Request Body:** `LoginRequest`: `email`, `password`.
- **Response Body:** `200 OK` with `SessionResponse` and safe `User` summary.
- **Validation Rules:** Valid email-form input and non-empty password; failures must not reveal whether the account exists.
- **Status Codes:** `200`, `400`, `401`, `429`, `500`.
- **Error Codes:** `VALIDATION_FAILED`, `UNAUTHENTICATED`, `RATE_LIMITED`, `INTERNAL_ERROR`.
- **Pagination / Filtering / Sorting:** Not applicable.
- **Rate Limiting:** 10 requests per IP per minute; additional account-risk controls may apply.

### AUTH-03 — Logout

- **Purpose:** End the caller’s current authenticated session.
- **HTTP Method / URL:** `POST /auth/logout`
- **Authentication:** Required.
- **Request Body:** None.
- **Response Body:** `204 No Content`; server revokes/invalidates state when the chosen token strategy supports it.
- **Validation Rules:** Credential must be valid; repeat logout is safe.
- **Status Codes:** `204`, `401`, `429`.
- **Error Codes:** `UNAUTHENTICATED`, `RATE_LIMITED`.
- **Pagination / Filtering / Sorting:** Not applicable.
- **Rate Limiting:** 30 requests per user per minute.

### AUTH-04 — Request password reset

- **Purpose:** Initiate a password-reset message without account enumeration.
- **HTTP Method / URL:** `POST /auth/password-reset-requests`
- **Authentication:** None.
- **Request Body:** `{ "email": "candidate@example.com" }`.
- **Response Body:** `202 Accepted` with `{ "message": "If an account is eligible, reset instructions will be sent." }`.
- **Validation Rules:** Email syntax must be valid; an existing account is not disclosed.
- **Status Codes:** `202`, `400`, `429`, `500`.
- **Error Codes:** `VALIDATION_FAILED`, `RATE_LIMITED`, `INTERNAL_ERROR`.
- **Pagination / Filtering / Sorting:** Not applicable.
- **Rate Limiting:** 3 requests per IP per hour.

### AUTH-05 — Complete password reset

- **Purpose:** Replace password using a valid, single-use reset token.
- **HTTP Method / URL:** `POST /auth/password-resets`
- **Authentication:** None.
- **Request Body:** `resetToken`, `newPassword`.
- **Response Body:** `204 No Content`.
- **Validation Rules:** Token is valid, unexpired, and unused; new password follows the registration policy; token is never logged.
- **Status Codes:** `204`, `400`, `401`, `429`, `500`.
- **Error Codes:** `VALIDATION_FAILED`, `UNAUTHENTICATED`, `RATE_LIMITED`, `INTERNAL_ERROR`.
- **Pagination / Filtering / Sorting:** Not applicable.
- **Rate Limiting:** 5 requests per IP per hour.

## 5. Users and Dashboard Modules

### USER-01 — Get own profile

- **Purpose:** Retrieve the caller’s profile.
- **HTTP Method / URL:** `GET /users/me`
- **Authentication:** Required; owner is derived from token.
- **Request Body:** None.
- **Response Body:** `200 OK` with `User`.
- **Validation Rules:** No client-controlled user ID is accepted.
- **Status Codes:** `200`, `401`, `429`, `500`.
- **Error Codes:** `UNAUTHENTICATED`, `RATE_LIMITED`, `INTERNAL_ERROR`.
- **Pagination / Filtering / Sorting:** Not applicable.
- **Rate Limiting:** 120 requests per user per minute.

### USER-02 — Update own profile

- **Purpose:** Update allowed personal display fields.
- **HTTP Method / URL:** `PATCH /users/me`
- **Authentication:** Required.
- **Request Body:** `ProfilePatch`: optional `displayName`.
- **Response Body:** `200 OK` with updated `User`.
- **Validation Rules:** Only whitelisted mutable fields; `displayName` is trimmed and 1–120 characters if present; email/password/status cannot be changed here.
- **Status Codes:** `200`, `400`, `401`, `429`, `500`.
- **Error Codes:** `VALIDATION_FAILED`, `UNAUTHENTICATED`, `RATE_LIMITED`, `INTERNAL_ERROR`.
- **Pagination / Filtering / Sorting:** Not applicable.
- **Rate Limiting:** 30 requests per user per minute.

### USER-03 — Request account deletion

- **Purpose:** Start the documented soft-delete/purge workflow.
- **HTTP Method / URL:** `DELETE /users/me`
- **Authentication:** Required.
- **Request Body:** `{ "confirmation": "DELETE_MY_ACCOUNT" }`.
- **Response Body:** `202 Accepted` with deletion request identifier/status.
- **Validation Rules:** Exact explicit confirmation is required; request is rejected for invalid account state or duplicate active request according to policy.
- **Status Codes:** `202`, `400`, `401`, `409`, `429`, `500`.
- **Error Codes:** `VALIDATION_FAILED`, `UNAUTHENTICATED`, `CONFLICT`, `RATE_LIMITED`, `INTERNAL_ERROR`.
- **Pagination / Filtering / Sorting:** Not applicable.
- **Rate Limiting:** 3 requests per user per day.

### DASH-01 — Get dashboard

- **Purpose:** Return next action, resumable session, recent interviews, and basic progress snapshot.
- **HTTP Method / URL:** `GET /dashboard`
- **Authentication:** Required.
- **Request Body:** None.
- **Response Body:** `200 OK` with `DashboardResponse`.
- **Validation Rules:** Server derives all content from caller ownership; only bounded recent records are included.
- **Status Codes:** `200`, `401`, `429`, `500`.
- **Error Codes:** `UNAUTHENTICATED`, `RATE_LIMITED`, `INTERNAL_ERROR`.
- **Pagination / Filtering / Sorting:** Not applicable; nested recent records have fixed documented bounds.
- **Rate Limiting:** 60 requests per user per minute.

## 6. Companies and Roles Modules

### COMP-01 — List companies

- **Purpose:** Retrieve selectable active companies.
- **HTTP Method / URL:** `GET /companies`
- **Authentication:** Required.
- **Request Body:** None.
- **Response Body:** `200 OK` with paged `Company` resources.
- **Validation Rules:** `q` is 1–100 characters when supplied; `active` is boolean; sort only `name`; `order` is `asc` or `desc`.
- **Status Codes:** `200`, `400`, `401`, `429`, `500`.
- **Error Codes:** `VALIDATION_FAILED`, `UNAUTHENTICATED`, `RATE_LIMITED`, `INTERNAL_ERROR`.
- **Pagination / Filtering / Sorting:** Cursor; filters `q`, `active`; sort `name`.
- **Rate Limiting:** 120 requests per user per minute.

### ROLE-01 — List job roles

- **Purpose:** Retrieve selectable target job roles.
- **HTTP Method / URL:** `GET /job-roles`
- **Authentication:** Required.
- **Request Body:** None.
- **Response Body:** `200 OK` with paged `JobRole` resources.
- **Validation Rules:** `q` maximum 100 characters; `category` must be a known category; sort only `name`.
- **Status Codes:** `200`, `400`, `401`, `429`, `500`.
- **Error Codes:** `VALIDATION_FAILED`, `UNAUTHENTICATED`, `RATE_LIMITED`, `INTERNAL_ERROR`.
- **Pagination / Filtering / Sorting:** Cursor; filters `q`, `category`; sort `name`.
- **Rate Limiting:** 120 requests per user per minute.

### ROLE-02 — List difficulty levels

- **Purpose:** Retrieve active difficulty choices.
- **HTTP Method / URL:** `GET /difficulty-levels`
- **Authentication:** Required.
- **Request Body:** None.
- **Response Body:** `200 OK` with ordered `DifficultyLevel[]`.
- **Validation Rules:** No input; inactive levels are excluded by default.
- **Status Codes:** `200`, `401`, `429`, `500`.
- **Error Codes:** `UNAUTHENTICATED`, `RATE_LIMITED`, `INTERNAL_ERROR`.
- **Pagination / Filtering / Sorting:** Not applicable; fixed bounded catalog sorted by rank.
- **Rate Limiting:** 120 requests per user per minute.

### ROLE-03 — List interview templates

- **Purpose:** Retrieve interview templates/modes available for setup.
- **HTTP Method / URL:** `GET /interview-templates`
- **Authentication:** Required.
- **Request Body:** None.
- **Response Body:** `200 OK` with paged `InterviewTemplate` resources.
- **Validation Rules:** `active` is boolean; sort only `name`; inactive templates require explicitly authorized catalog access and are not exposed in MVP user flow.
- **Status Codes:** `200`, `400`, `401`, `429`, `500`.
- **Error Codes:** `VALIDATION_FAILED`, `UNAUTHENTICATED`, `RATE_LIMITED`, `INTERNAL_ERROR`.
- **Pagination / Filtering / Sorting:** Cursor; filter `active`; sort `name`.
- **Rate Limiting:** 120 requests per user per minute.

## 7. Interview Sessions, Questions, and Answers Modules

### INT-01 — Create interview session

- **Purpose:** Validate configuration, create a session, and begin question generation.
- **HTTP Method / URL:** `POST /interview-sessions`
- **Authentication:** Required; supports `Idempotency-Key`.
- **Request Body:** `CreateInterviewRequest`: `companyId`, `jobRoleId`, `difficultyLevelId`, optional `interviewTemplateId`.
- **Response Body:** `201 Created` with `InterviewSession`; response status may be `CREATING` until questions are available.
- **Validation Rules:** IDs must reference active selectable records; template must be valid for current MVP; caller cannot set owner/status/questions/prompt/model; one active session policy is enforced if adopted.
- **Status Codes:** `201`, `400`, `401`, `409`, `429`, `503`, `500`.
- **Error Codes:** `VALIDATION_FAILED`, `UNAUTHENTICATED`, `CONFLICT`, `RATE_LIMITED`, `AI_PROVIDER_UNAVAILABLE`, `INTERNAL_ERROR`.
- **Pagination / Filtering / Sorting:** Not applicable.
- **Rate Limiting:** 6 requests per user per hour.

### INT-02 — List own interview sessions

- **Purpose:** Retrieve caller-owned interview history and eligible in-progress sessions.
- **HTTP Method / URL:** `GET /interview-sessions`
- **Authentication:** Required.
- **Request Body:** None.
- **Response Body:** `200 OK` with paged `InterviewSession` summaries.
- **Validation Rules:** `status` is an allowed lifecycle value; date range is ISO 8601 and `from <= to`; catalog filters must be positive IDs; sort only `createdAt`, `completedAt`, `status`.
- **Status Codes:** `200`, `400`, `401`, `429`, `500`.
- **Error Codes:** `VALIDATION_FAILED`, `UNAUTHENTICATED`, `RATE_LIMITED`, `INTERNAL_ERROR`.
- **Pagination / Filtering / Sorting:** Cursor; filters `status`, `companyId`, `jobRoleId`, `from`, `to`; sort `createdAt`, `completedAt`, `status`.
- **Rate Limiting:** 60 requests per user per minute.

### INT-03 — Get interview session

- **Purpose:** Read one session and its safe current-state metadata.
- **HTTP Method / URL:** `GET /interview-sessions/{interviewSessionId}`
- **Authentication:** Required; caller must own session.
- **Request Body:** None.
- **Response Body:** `200 OK` with detailed `InterviewSession`.
- **Validation Rules:** Path ID is positive integer; ownership enforced; non-disclosing `404` for absent/unowned session.
- **Status Codes:** `200`, `401`, `404`, `429`, `500`.
- **Error Codes:** `UNAUTHENTICATED`, `NOT_FOUND`, `RATE_LIMITED`, `INTERNAL_ERROR`.
- **Pagination / Filtering / Sorting:** Not applicable.
- **Rate Limiting:** 120 requests per user per minute.

### INT-04 — Start interview

- **Purpose:** Transition a `READY` session to `IN_PROGRESS`.
- **HTTP Method / URL:** `POST /interview-sessions/{interviewSessionId}/start`
- **Authentication:** Required; caller must own session.
- **Request Body:** None.
- **Response Body:** `200 OK` with updated `InterviewSession`.
- **Validation Rules:** Session must be `READY`; repeat start is idempotent only while allowed by the lifecycle; generated questions must exist.
- **Status Codes:** `200`, `400`, `401`, `404`, `409`, `429`, `500`.
- **Error Codes:** `VALIDATION_FAILED`, `UNAUTHENTICATED`, `NOT_FOUND`, `CONFLICT`, `RATE_LIMITED`, `INTERNAL_ERROR`.
- **Pagination / Filtering / Sorting:** Not applicable.
- **Rate Limiting:** 20 requests per user per minute.

### INT-05 — Complete interview

- **Purpose:** Validate completion conditions and enqueue/trigger feedback generation.
- **HTTP Method / URL:** `POST /interview-sessions/{interviewSessionId}/complete`
- **Authentication:** Required; supports `Idempotency-Key`.
- **Request Body:** None.
- **Response Body:** `202 Accepted` with `{ "interviewSessionId": 123, "status": "FEEDBACK_PENDING" }`.
- **Validation Rules:** Session belongs to caller, is `IN_PROGRESS`, and has a valid submitted answer for every required question; duplicate call returns same accepted state when idempotency applies.
- **Status Codes:** `202`, `400`, `401`, `404`, `409`, `429`, `503`, `500`.
- **Error Codes:** `VALIDATION_FAILED`, `UNAUTHENTICATED`, `NOT_FOUND`, `CONFLICT`, `RATE_LIMITED`, `AI_PROVIDER_UNAVAILABLE`, `INTERNAL_ERROR`.
- **Pagination / Filtering / Sorting:** Not applicable.
- **Rate Limiting:** 10 requests per user per hour.

### INT-06 — Cancel interview

- **Purpose:** Cancel an eligible incomplete session without generating feedback.
- **HTTP Method / URL:** `POST /interview-sessions/{interviewSessionId}/cancel`
- **Authentication:** Required; caller must own session.
- **Request Body:** Optional `{ "reason": "USER_EXITED" }`.
- **Response Body:** `200 OK` with updated `InterviewSession` status `CANCELLED`.
- **Validation Rules:** Session must be in an approved cancellable status; reason is optional controlled value, not free-form user content in MVP.
- **Status Codes:** `200`, `400`, `401`, `404`, `409`, `429`, `500`.
- **Error Codes:** `VALIDATION_FAILED`, `UNAUTHENTICATED`, `NOT_FOUND`, `CONFLICT`, `RATE_LIMITED`, `INTERNAL_ERROR`.
- **Pagination / Filtering / Sorting:** Not applicable.
- **Rate Limiting:** 10 requests per user per hour.

### Q-01 — List session questions

- **Purpose:** Retrieve the ordered questions for an owned interview.
- **HTTP Method / URL:** `GET /interview-sessions/{interviewSessionId}/questions`
- **Authentication:** Required; caller must own session.
- **Request Body:** None.
- **Response Body:** `200 OK` with ordered `InterviewQuestion[]`.
- **Validation Rules:** Session must be at least `READY`; questions are immutable to the caller; question text is returned only for owned session.
- **Status Codes:** `200`, `401`, `404`, `409`, `429`, `500`.
- **Error Codes:** `UNAUTHENTICATED`, `NOT_FOUND`, `OPERATION_PENDING`, `RATE_LIMITED`, `INTERNAL_ERROR`.
- **Pagination / Filtering / Sorting:** Not applicable; bounded and ordered by `sequenceNumber`.
- **Rate Limiting:** 120 requests per user per minute.

### Q-02 — Get session question

- **Purpose:** Retrieve one question in an owned session.
- **HTTP Method / URL:** `GET /interview-sessions/{interviewSessionId}/questions/{questionId}`
- **Authentication:** Required; caller must own session and question must belong to path session.
- **Request Body:** None.
- **Response Body:** `200 OK` with `InterviewQuestion`.
- **Validation Rules:** Both path IDs are positive; mismatched/unowned resources are non-disclosing `404`.
- **Status Codes:** `200`, `401`, `404`, `429`, `500`.
- **Error Codes:** `UNAUTHENTICATED`, `NOT_FOUND`, `RATE_LIMITED`, `INTERNAL_ERROR`.
- **Pagination / Filtering / Sorting:** Not applicable.
- **Rate Limiting:** 120 requests per user per minute.

### ANS-01 — Submit answer

- **Purpose:** Create or replace the current approved answer for one active question.
- **HTTP Method / URL:** `PUT /interview-sessions/{interviewSessionId}/questions/{questionId}/answer`
- **Authentication:** Required; caller must own active session.
- **Request Body:** `AnswerRequest`: `answerText`, `inputMethod` (`TYPED` or `VOICE_TRANSCRIPT`).
- **Response Body:** `200 OK` with `CandidateAnswer`.
- **Validation Rules:** Path resources must match; session is `IN_PROGRESS`; answer text after trimming is 1–20,000 characters; only allowed input methods; raw audio, scores, and user IDs are rejected.
- **Status Codes:** `200`, `400`, `401`, `404`, `409`, `413`, `429`, `500`.
- **Error Codes:** `VALIDATION_FAILED`, `UNAUTHENTICATED`, `NOT_FOUND`, `CONFLICT`, `RATE_LIMITED`, `INTERNAL_ERROR`.
- **Pagination / Filtering / Sorting:** Not applicable.
- **Rate Limiting:** 60 requests per user per minute.

### ANS-02 — Get answer

- **Purpose:** Retrieve the caller’s saved answer for one owned question.
- **HTTP Method / URL:** `GET /interview-sessions/{interviewSessionId}/questions/{questionId}/answer`
- **Authentication:** Required; caller must own session.
- **Request Body:** None.
- **Response Body:** `200 OK` with `CandidateAnswer`.
- **Validation Rules:** Path resources must match and caller must own session; no answer returns `404` without revealing other-user state.
- **Status Codes:** `200`, `401`, `404`, `429`, `500`.
- **Error Codes:** `UNAUTHENTICATED`, `NOT_FOUND`, `RATE_LIMITED`, `INTERNAL_ERROR`.
- **Pagination / Filtering / Sorting:** Not applicable.
- **Rate Limiting:** 120 requests per user per minute.

## 8. AI Evaluation and Reports Modules

### AI-01 — Get feedback

- **Purpose:** Retrieve structured feedback or its current generation status.
- **HTTP Method / URL:** `GET /interview-sessions/{interviewSessionId}/feedback`
- **Authentication:** Required; caller must own session.
- **Request Body:** None.
- **Response Body:** `200 OK` with `Feedback`; `202 Accepted` may return status-only feedback while pending.
- **Validation Rules:** Session must be completed/feedback-eligible; provider model, prompt internals, and hidden diagnostic data are not exposed.
- **Status Codes:** `200`, `202`, `401`, `404`, `409`, `429`, `500`.
- **Error Codes:** `UNAUTHENTICATED`, `NOT_FOUND`, `OPERATION_PENDING`, `RATE_LIMITED`, `INTERNAL_ERROR`.
- **Pagination / Filtering / Sorting:** Not applicable.
- **Rate Limiting:** 60 requests per user per minute.

### AI-02 — Retry feedback generation

- **Purpose:** Retry a failed-retryable feedback operation.
- **HTTP Method / URL:** `POST /interview-sessions/{interviewSessionId}/feedback/retry`
- **Authentication:** Required; supports `Idempotency-Key`.
- **Request Body:** None.
- **Response Body:** `202 Accepted` with feedback operation status.
- **Validation Rules:** Session belongs to caller and feedback is `FAILED_RETRYABLE`; the endpoint cannot modify answers or force retry of available/final-failed feedback.
- **Status Codes:** `202`, `401`, `404`, `409`, `429`, `503`, `500`.
- **Error Codes:** `UNAUTHENTICATED`, `NOT_FOUND`, `CONFLICT`, `RATE_LIMITED`, `AI_PROVIDER_UNAVAILABLE`, `INTERNAL_ERROR`.
- **Pagination / Filtering / Sorting:** Not applicable.
- **Rate Limiting:** 3 requests per user per hour.

### REP-01 — Request report

- **Purpose:** Generate or reuse an export for completed owned feedback.
- **HTTP Method / URL:** `POST /interview-sessions/{interviewSessionId}/reports`
- **Authentication:** Required; supports `Idempotency-Key`.
- **Request Body:** `ReportRequest`: `format` (`PDF` or `HTML`).
- **Response Body:** `201 Created` or `202 Accepted` with `Report`.
- **Validation Rules:** Session belongs to caller and feedback is available; format must be supported; report content derives from server-owned data only.
- **Status Codes:** `201`, `202`, `400`, `401`, `404`, `409`, `429`, `500`.
- **Error Codes:** `VALIDATION_FAILED`, `UNAUTHENTICATED`, `NOT_FOUND`, `CONFLICT`, `RATE_LIMITED`, `INTERNAL_ERROR`.
- **Pagination / Filtering / Sorting:** Not applicable.
- **Rate Limiting:** 10 requests per user per hour.

### REP-02 — List reports

- **Purpose:** Retrieve report generation/export status for an owned session.
- **HTTP Method / URL:** `GET /interview-sessions/{interviewSessionId}/reports`
- **Authentication:** Required; caller must own session.
- **Request Body:** None.
- **Response Body:** `200 OK` with paged `Report[]`.
- **Validation Rules:** `status` and `format` use supported values; sort only `generatedAt`; reports are never exposed cross-user.
- **Status Codes:** `200`, `400`, `401`, `404`, `429`, `500`.
- **Error Codes:** `VALIDATION_FAILED`, `UNAUTHENTICATED`, `NOT_FOUND`, `RATE_LIMITED`, `INTERNAL_ERROR`.
- **Pagination / Filtering / Sorting:** Cursor; filters `status`, `format`; sort `generatedAt`.
- **Rate Limiting:** 60 requests per user per minute.

### REP-03 — Download report

- **Purpose:** Obtain a short-lived download URL or redirect for an available owned report.
- **HTTP Method / URL:** `GET /interview-sessions/{interviewSessionId}/reports/{reportId}/download`
- **Authentication:** Required; caller must own session and report.
- **Request Body:** None.
- **Response Body:** `302 Found` to an approved short-lived object URL, or `200 OK` with `{ "downloadUrl": "...", "expiresAt": "..." }`.
- **Validation Rules:** Report must be `AVAILABLE`, unexpired, and belong to the supplied session; URL must not expose durable credentials.
- **Status Codes:** `200`, `302`, `401`, `404`, `409`, `429`, `500`.
- **Error Codes:** `UNAUTHENTICATED`, `NOT_FOUND`, `OPERATION_PENDING`, `RATE_LIMITED`, `INTERNAL_ERROR`.
- **Pagination / Filtering / Sorting:** Not applicable.
- **Rate Limiting:** 30 requests per user per minute.

## 9. Analytics Module

### AN-01 — Get analytics overview

- **Purpose:** Retrieve caller-owned aggregate practice metrics.
- **HTTP Method / URL:** `GET /analytics/overview`
- **Authentication:** Required.
- **Request Body:** None.
- **Response Body:** `200 OK` with completion count, average/latest advisory score, streak, and focus themes where data is sufficient.
- **Validation Rules:** Data is derived only from completed owned interviews; no data returns a valid empty/zero-state, not an error.
- **Status Codes:** `200`, `401`, `429`, `500`.
- **Error Codes:** `UNAUTHENTICATED`, `RATE_LIMITED`, `INTERNAL_ERROR`.
- **Pagination / Filtering / Sorting:** Not applicable.
- **Rate Limiting:** 30 requests per user per minute.

### AN-02 — Get analytics trends

- **Purpose:** Retrieve time-series progress data for charts and accessible textual alternatives.
- **HTTP Method / URL:** `GET /analytics/trends`
- **Authentication:** Required.
- **Request Body:** None.
- **Response Body:** `200 OK` with ordered trend points.
- **Validation Rules:** `from`/`to` are ISO dates, `from <= to`, maximum range is 365 days for MVP; `groupBy` is `week` or `month`; sort is always ascending date.
- **Status Codes:** `200`, `400`, `401`, `429`, `500`.
- **Error Codes:** `VALIDATION_FAILED`, `UNAUTHENTICATED`, `RATE_LIMITED`, `INTERNAL_ERROR`.
- **Pagination / Filtering / Sorting:** Filter `from`, `to`, `groupBy`; no pagination; fixed ascending date order.
- **Rate Limiting:** 30 requests per user per minute.

## 10. Notifications Module

### NOTIF-01 — List notifications

- **Purpose:** Retrieve the caller’s in-app notification history.
- **HTTP Method / URL:** `GET /notifications`
- **Authentication:** Required.
- **Request Body:** None.
- **Response Body:** `200 OK` with paged `Notification[]`.
- **Validation Rules:** `status` and `type` are supported values; sort only `createdAt`; notification payload excludes sensitive answer content.
- **Status Codes:** `200`, `400`, `401`, `429`, `500`.
- **Error Codes:** `VALIDATION_FAILED`, `UNAUTHENTICATED`, `RATE_LIMITED`, `INTERNAL_ERROR`.
- **Pagination / Filtering / Sorting:** Cursor; filters `status`, `type`; sort `createdAt`.
- **Rate Limiting:** 60 requests per user per minute.

### NOTIF-02 — Mark notification read

- **Purpose:** Mark a caller-owned notification as read.
- **HTTP Method / URL:** `POST /notifications/{notificationId}/read`
- **Authentication:** Required; caller must own notification.
- **Request Body:** None.
- **Response Body:** `200 OK` with updated `Notification`.
- **Validation Rules:** Path ID is positive; repeat operation is idempotent; non-owned/missing notification returns non-disclosing `404`.
- **Status Codes:** `200`, `401`, `404`, `429`, `500`.
- **Error Codes:** `UNAUTHENTICATED`, `NOT_FOUND`, `RATE_LIMITED`, `INTERNAL_ERROR`.
- **Pagination / Filtering / Sorting:** Not applicable.
- **Rate Limiting:** 60 requests per user per minute.

## 11. Settings Module

### SET-01 — Get settings

- **Purpose:** Retrieve caller-owned preferences.
- **HTTP Method / URL:** `GET /settings`
- **Authentication:** Required.
- **Request Body:** None.
- **Response Body:** `200 OK` with `Settings`.
- **Validation Rules:** Settings are created with defaults if no row exists; only caller-owned values are returned.
- **Status Codes:** `200`, `401`, `429`, `500`.
- **Error Codes:** `UNAUTHENTICATED`, `RATE_LIMITED`, `INTERNAL_ERROR`.
- **Pagination / Filtering / Sorting:** Not applicable.
- **Rate Limiting:** 60 requests per user per minute.

### SET-02 — Update settings

- **Purpose:** Update allowed notification and experience preferences.
- **HTTP Method / URL:** `PATCH /settings`
- **Authentication:** Required.
- **Request Body:** `SettingsPatch`: optional `notificationsEnabled`, `feedbackReadyEmailEnabled`, `practiceRemindersEnabled`, `locale`, `timezone`.
- **Response Body:** `200 OK` with updated `Settings`.
- **Validation Rules:** Only whitelisted settings accepted; locale is `en` in MVP; timezone must be an IANA zone when supplied; optional notifications follow legal/consent policy.
- **Status Codes:** `200`, `400`, `401`, `429`, `500`.
- **Error Codes:** `VALIDATION_FAILED`, `UNAUTHENTICATED`, `RATE_LIMITED`, `INTERNAL_ERROR`.
- **Pagination / Filtering / Sorting:** Not applicable.
- **Rate Limiting:** 30 requests per user per minute.

## 12. OpenAPI 3.1 YAML Examples

The following is a representative, executable-style fragment. The final generated OpenAPI file will expand every endpoint listed in this document using the same schemas and security rules.

```yaml
openapi: 3.1.0
info:
  title: InterviewIQ AI API
  version: 1.0.0-draft
servers:
  - url: https://api.interviewiq.ai/api/v1
paths:
  /auth/register:
    post:
      summary: Register a candidate account
      operationId: register
      security: []
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/RegisterRequest'
      responses:
        '201':
          description: Account created
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/AuthResponse'
        '400': { $ref: '#/components/responses/ValidationError' }
        '409': { $ref: '#/components/responses/ConflictError' }
        '429': { $ref: '#/components/responses/RateLimitError' }
  /interview-sessions:
    get:
      summary: List caller-owned interview sessions
      operationId: listInterviewSessions
      parameters:
        - $ref: '#/components/parameters/Cursor'
        - $ref: '#/components/parameters/Limit'
        - name: status
          in: query
          schema: { type: string, enum: [CREATING, READY, IN_PROGRESS, COMPLETED, FEEDBACK_PENDING, FEEDBACK_AVAILABLE, FAILED_RETRYABLE, CANCELLED] }
      responses:
        '200':
          description: Paged sessions
          content:
            application/json:
              schema: { $ref: '#/components/schemas/InterviewSessionPage' }
    post:
      summary: Create an interview and begin question generation
      operationId: createInterviewSession
      parameters:
        - $ref: '#/components/parameters/IdempotencyKey'
      requestBody:
        required: true
        content:
          application/json:
            schema: { $ref: '#/components/schemas/CreateInterviewRequest' }
      responses:
        '201':
          description: Session created
          content:
            application/json:
              schema: { $ref: '#/components/schemas/InterviewSession' }
        '503': { $ref: '#/components/responses/AiProviderUnavailable' }
  /interview-sessions/{interviewSessionId}/questions/{questionId}/answer:
    put:
      summary: Save current answer for an interview question
      operationId: upsertCandidateAnswer
      parameters:
        - $ref: '#/components/parameters/InterviewSessionId'
        - $ref: '#/components/parameters/QuestionId'
      requestBody:
        required: true
        content:
          application/json:
            schema: { $ref: '#/components/schemas/AnswerRequest' }
      responses:
        '200':
          description: Answer saved
          content:
            application/json:
              schema: { $ref: '#/components/schemas/CandidateAnswer' }
components:
  securitySchemes:
    bearerAuth:
      type: http
      scheme: bearer
      bearerFormat: JWT
  parameters:
    Cursor: { name: cursor, in: query, schema: { type: string } }
    Limit: { name: limit, in: query, schema: { type: integer, default: 20, minimum: 1, maximum: 100 } }
    IdempotencyKey: { name: Idempotency-Key, in: header, required: false, schema: { type: string, format: uuid } }
    InterviewSessionId: { name: interviewSessionId, in: path, required: true, schema: { type: integer, minimum: 1 } }
    QuestionId: { name: questionId, in: path, required: true, schema: { type: integer, minimum: 1 } }
  schemas:
    RegisterRequest:
      type: object
      additionalProperties: false
      required: [email, password]
      properties:
        email: { type: string, format: email, maxLength: 254 }
        password: { type: string, format: password, minLength: 12, maxLength: 128 }
        displayName: { type: string, minLength: 1, maxLength: 120 }
    CreateInterviewRequest:
      type: object
      additionalProperties: false
      required: [companyId, jobRoleId, difficultyLevelId]
      properties:
        companyId: { type: integer, minimum: 1 }
        jobRoleId: { type: integer, minimum: 1 }
        difficultyLevelId: { type: integer, minimum: 1 }
        interviewTemplateId: { type: integer, minimum: 1 }
    AnswerRequest:
      type: object
      additionalProperties: false
      required: [answerText, inputMethod]
      properties:
        answerText: { type: string, minLength: 1, maxLength: 20000 }
        inputMethod: { type: string, enum: [TYPED, VOICE_TRANSCRIPT] }
    CandidateAnswer:
      type: object
      required: [id, questionId, answerText, inputMethod, submittedAt]
      properties:
        id: { type: integer }
        questionId: { type: integer }
        answerText: { type: string }
        inputMethod: { type: string, enum: [TYPED, VOICE_TRANSCRIPT] }
        submittedAt: { type: string, format: date-time }
    ErrorResponse:
      type: object
      required: [error]
      properties:
        error:
          type: object
          required: [code, message]
          properties:
            code: { type: string }
            message: { type: string }
            correlationId: { type: string, format: uuid }
  responses:
    ValidationError: { description: Invalid request, content: { application/json: { schema: { $ref: '#/components/schemas/ErrorResponse' } } } }
    ConflictError: { description: Conflicting state, content: { application/json: { schema: { $ref: '#/components/schemas/ErrorResponse' } } } }
    RateLimitError: { description: Rate limit exceeded, headers: { Retry-After: { schema: { type: integer } } }, content: { application/json: { schema: { $ref: '#/components/schemas/ErrorResponse' } } } }
    AiProviderUnavailable: { description: AI provider unavailable, content: { application/json: { schema: { $ref: '#/components/schemas/ErrorResponse' } } } }
security:
  - bearerAuth: []
```

## 13. Sample JSON Requests and Responses

### Register request and response

```json
POST /api/v1/auth/register
{
  "email": "aisha.khan@example.com",
  "password": "A-strong-password-2026",
  "displayName": "Aisha Khan"
}
```

```json
201 Created
{
  "user": {
    "id": 101,
    "email": "aisha.khan@example.com",
    "displayName": "Aisha Khan",
    "status": "ACTIVE",
    "emailVerified": false,
    "createdAt": "2026-07-28T10:30:00.000000Z",
    "updatedAt": "2026-07-28T10:30:00.000000Z"
  },
  "session": {
    "accessToken": "redacted-example-token",
    "expiresIn": 900
  }
}
```

### Create interview request and response

```json
POST /api/v1/interview-sessions
Authorization: Bearer <access-token>
Idempotency-Key: 83a981c6-5fc8-4a0e-9d18-9b2ff6e4e481
{
  "companyId": 1,
  "jobRoleId": 2,
  "difficultyLevelId": 2,
  "interviewTemplateId": 1
}
```

```json
201 Created
{
  "id": 501,
  "company": { "id": 1, "code": "GENERIC_TECH", "name": "Generic Technology Company" },
  "jobRole": { "id": 2, "code": "BACKEND_ENGINEER", "name": "Backend Engineer" },
  "difficultyLevel": { "id": 2, "code": "INTERMEDIATE", "displayName": "Intermediate" },
  "template": { "id": 1, "code": "GENERAL", "name": "General Interview" },
  "status": "READY",
  "questionCount": 5,
  "answeredCount": 0,
  "createdAt": "2026-07-28T10:35:00.000000Z",
  "startedAt": null,
  "completedAt": null
}
```

### Save voice transcript answer

```json
PUT /api/v1/interview-sessions/501/questions/9001/answer
Authorization: Bearer <access-token>
{
  "answerText": "I designed a service that reduced response time by caching frequently requested data.",
  "inputMethod": "VOICE_TRANSCRIPT"
}
```

```json
200 OK
{
  "id": 12001,
  "questionId": 9001,
  "answerText": "I designed a service that reduced response time by caching frequently requested data.",
  "inputMethod": "VOICE_TRANSCRIPT",
  "submittedAt": "2026-07-28T10:38:12.000000Z"
}
```

### Feedback pending and available responses

```json
202 Accepted
{
  "status": "PENDING",
  "interviewSessionId": 501,
  "message": "Your feedback is being prepared."
}
```

```json
200 OK
{
  "status": "AVAILABLE",
  "overallScore": 82.5,
  "overallAssessment": "Clear, structured answers with room to deepen trade-off discussion.",
  "strengths": ["Explains impact clearly", "Uses a concrete example"],
  "improvementAreas": ["State assumptions before solution details"],
  "recommendedActions": ["Practice explaining one design trade-off in each answer"],
  "questionFeedback": [
    {
      "questionId": 9001,
      "score": 82.0,
      "strengths": ["Specific example"],
      "improvements": ["Quantify the result where possible"]
    }
  ],
  "generatedAt": "2026-07-28T10:40:15.000000Z"
}
```

## 14. Contract Governance

The OpenAPI document generated from this contract is the integration source of truth. Changes require product, frontend, backend, QA, and security review when they affect authentication, data ownership, validation, lifecycle status, privacy, rate limits, or error behavior. Contract tests must verify authentication, ownership, validation, pagination/filter/sort allowlists, idempotency, and representative provider-failure responses before release.

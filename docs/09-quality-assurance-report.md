# InterviewIQ AI — Quality Assurance Report

**Date:** 2026-11-02  
**Scope:** MVP regression, authorization, lifecycle, AI-boundary, analytics, report export, and local MySQL/Flyway verification.

## Summary

The application is suitable for continued staging validation. Core authenticated flows, deterministic AI test behavior, ownership enforcement, PDF generation, and MySQL/Flyway startup were verified. No live Gemini calls were made.

## Coverage Added

- Malformed JWT is rejected with `401`.
- Invalid interview transitions reject answer submission before start and completion before all answers are saved.
- A user cannot retrieve another user’s interview, feedback, or PDF report (`404` non-disclosure).
- Analytics returns a user-scoped zero state for another user with no completed sessions.
- History status filtering and pagination limit are exercised.
- PDF download returns `application/pdf` with non-empty binary output.

## Existing Coverage Retained

- Registration validation, duplicate email, valid and invalid login, protected endpoint access.
- Interview creation, question generation through the deterministic provider, answer submission, completion, feedback, and history.
- Gemini structured response parsing, malformed response rejection, and duplicate-question rejection.
- Question-context differentiation for company, role, difficulty, and fallback generation.

## Security Review

- BCrypt hashes passwords; password hashes are not included in response DTOs.
- JWT secret enforces a minimum 32-character key and tokens include expiry/signature validation.
- Invalid tokens are ignored by the filter and protected endpoints return `401`.
- Ownership is server-enforced through `findByIdAndUserId` for interview, feedback, and PDF access.
- CORS uses a configured origin, not a wildcard; production origin is environment supplied.
- Secrets are externalized and `.gitignore` excludes environment files, private keys, certificates, and keystores.

## Database and Migration Review

- Docker MySQL 8.4 verified on local host port 3307.
- Flyway migrations V1 and V2 validate and apply successfully; schema is at version 2.
- JPA mappings were aligned to the existing schema without migration changes: small integer catalog/order fields and `DECIMAL(5,2)` score fields.
- Flyway emits a non-blocking warning that the installed Flyway release has not formally tested MySQL 8.4. Upgrade Flyway before production release when a compatible version is approved.

## Remaining Defects and Deployment Blockers

1. No application-level rate limiter is implemented despite rate limits specified by the draft API contract. Add a bounded single-instance limiter before public deployment.
2. Expired-token behavior is covered by JWT parsing implementation but lacks a dedicated automated expiry test.
3. Gemini HTTP timeout and provider-failure behavior is unit-tested at the parsing/error-boundary level, but no mocked `RestClient` transport test currently asserts retry/timeout behavior.
4. Current analytics uses the persisted overall score for technical, communication, and confidence summaries because those distinct evaluator values are not stored separately.
5. PDF output verifies content type and non-empty bytes. Visual regression testing with long multi-page answers remains recommended.
6. No real Gemini connectivity test was run; production credentials and quota must be validated only in a protected staging environment.

## Verification Results

| Check | Result |
| --- | --- |
| Focused backend integration suite | PASS — 4 tests |
| Existing parser/fallback tests | Previously passing; included in full verification target |
| Docker MySQL 8.4 | PASS |
| Flyway V1/V2 | PASS |
| Development-profile API health | PASS |
| OpenAPI endpoint | PASS |

## Recommended Next Actions

1. Add a configurable local rate limiter for authentication and AI-triggering endpoints.
2. Add JWT-expiration and mocked Gemini transport/retry tests.
3. Run `mvn verify`, frontend lint/test/build, and a browser smoke test in CI after merging these changes.
4. Upgrade Flyway to a release formally supporting MySQL 8.4, then repeat the Docker database verification.

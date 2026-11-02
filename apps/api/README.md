# InterviewIQ AI API

Spring Boot backend foundation for InterviewIQ AI.

Sprint 1 establishes project configuration, MySQL/Flyway integration points, actuator health checks, OpenAPI documentation, structured logging, and architectural package boundaries. Authentication, authorization behavior, user workflows, interview workflows, AI integration, and business logic are intentionally deferred.

## Prerequisites

- Java 21
- Maven 3.9+
- MySQL 8.0+ for `dev` and `prod` profiles

## Configuration

Use `.env.example` as the variable-name reference and configure those variables through your shell, IDE run configuration, or runtime platform. The file is not loaded automatically by Spring Boot. The application uses the `dev` profile by default; use the `test` profile only for lightweight infrastructure startup checks.

For local MySQL development, start the repository-root Compose environment and set `INTERVIEWIQ_DB_URL`, `INTERVIEWIQ_DB_USERNAME`, and `INTERVIEWIQ_DB_PASSWORD` from its documented local-only configuration. Do not reuse these local credentials in production. The project targets Java 21; this workstation currently uses JDK 22 for local verification with Maven compiling using `--release 21`. Use JDK 21 in CI and production for exact runtime parity.

## Useful endpoints

- Health: `GET /actuator/health`
- OpenAPI JSON: `GET /v3/api-docs`
- Swagger UI: `GET /swagger-ui/index.html`

## Database migrations

The initial Flyway migration, `V1__initial_schema.sql`, is in `src/main/resources/db/migration` and is derived from the approved repository-level `database/schema.sql`. Future schema changes must be added as immutable, versioned migrations.

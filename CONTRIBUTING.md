# Contributing to InterviewIQ AI

## Before You Start

Read the relevant documents in `docs/`. Contributions must preserve the approved modular-monolith architecture, MySQL data design, REST API contract, UI design system, security baseline, and MVP scope.

## Workflow

1. Open or select an approved backlog item.
2. Create a focused branch using the `codex/` prefix unless another branch convention is agreed.
3. Keep each pull request focused, documented, tested, and free of unrelated formatting changes.
4. Update specifications, API contracts, migrations, or operational documentation whenever a change affects them.
5. Request review only after CI passes and acceptance criteria are demonstrably met.

## Engineering Standards

- Never commit secrets, credentials, local environment files, or production data.
- Treat authorization, validation, accessibility, and error handling as part of every feature.
- Follow clean architecture, SOLID, DRY, and KISS principles.
- Use migrations for database changes; do not make undocumented production schema changes.
- Add or update automated tests appropriate to the change.

## Pull Requests

Describe the user story or issue, implementation intent, verification performed, risks, and any documentation changes. Use the pull-request template and keep the scope reviewable.

## Reporting Issues

Use the provided issue templates. For vulnerabilities, follow [SECURITY.md](SECURITY.md) instead of opening a public issue.


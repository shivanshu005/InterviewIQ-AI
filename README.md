# InterviewIQ AI

InterviewIQ AI is a planned AI-powered mock interview SaaS platform. Candidates will be able to configure role-specific practice interviews, answer by voice or text, receive structured AI feedback, track progress, and download interview reports.

This repository is currently in **Sprint 0**. It contains the production monorepo structure and planning artifacts only; application projects, dependencies, and business logic have intentionally not been created yet.

## Architecture

The MVP is designed as a modular monolith:

- A React web application consumes a versioned REST API.
- A Spring Boot API owns authentication, authorization, interview lifecycle, persistence, reporting, and AI-provider integration.
- MySQL is the transactional system of record, evolved through versioned migrations.
- Gemini is called only from the backend. Browser Web Speech APIs provide optional voice transcription with a complete typed-answer fallback.

See [System Architecture](docs/05-system-architecture.md), [Database Design](docs/06-database-design.md), and [API Contracts](docs/07-api-contracts.md) for the approved design baseline.

## Tech Stack

| Area | Technologies |
| --- | --- |
| Web | React 19, Vite, TypeScript, Tailwind CSS, shadcn/ui, TanStack Query, React Hook Form, Zod, Framer Motion, Axios |
| API | Java 21, Spring Boot 3.5, Maven, Spring Security, Spring Data JPA, Validation, Flyway, Lombok, MapStruct, OpenAPI, Actuator |
| Data | MySQL, Testcontainers |
| Delivery | Docker, GitHub Actions, Vercel, Railway |

## Folder Structure

```text
InterviewIQ-AI/
├── apps/
│   ├── web/                 # Future React/Vite application
│   └── api/                 # Future Spring Boot/Maven application
├── packages/
│   ├── ui/                  # Future shared UI package
│   ├── config/              # Future shared configuration package
│   ├── types/               # Future shared TypeScript contracts
│   └── utils/               # Future shared utilities
├── database/                # Schema reference and reference seed data
├── docs/                    # Product, architecture, API, and UI specifications
├── deployment/              # Future infrastructure/deployment configuration
├── scripts/                 # Future safe developer/automation scripts
├── .github/                 # CI workflows, issue templates, PR template
└── tests/                   # Future cross-application test assets
```

## Getting Started

Implementation setup is intentionally pending Sprint 1. No dependencies are required or installed for Sprint 0.

When project scaffolding is approved, this section will document prerequisites, environment configuration, local database startup, web/API commands, tests, and migration workflows.

## Roadmap

The project has completed product planning and architecture definition. The next delivery phase is Sprint 1: secure application foundations and project scaffolding.

The approved roadmap and supporting specifications are in [docs](docs/).

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) before opening an issue or pull request. All changes must align with the approved architecture, database design, API contracts, and UI design system.

## License

This project is licensed under the [MIT License](LICENSE).


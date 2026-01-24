# Skills Index

Catalog of all available skills organized by category.

## Quick Reference

| Category | Skills |
|----------|--------|
| Frontend | react-patterns, react-native, accessibility-patterns, performance-optimization |
| Backend | supabase, api-design, database-optimization, error-handling |
| Infrastructure | aws-deployment, gcp-patterns, docker-patterns, ci-cd-pipelines, monitoring-observability |
| WordPress | wordpress, wordpress-elementor, wordpress-rocketnet, woocommerce-elementor, html-to-elementor |
| Content | copywriting, ux-writing, brand-voice, content-strategy, documentation-writing |
| Client | client-communication, client-onboarding, client-deliverable, pricing-justification |
| Mobile | react-native, expo-deployment |
| Quality | testing-strategies, security-patterns, security-audit, mvp-readiness |
| Workflow | git-workflows, github-patterns, skill-generator, skill-maintenance |
| Database | supabase, supabase-migration-cleanup, database-optimization |

---

## Frontend Development

### react-patterns
React development patterns, hooks, state management, and component architecture.
**Use when**: Building React applications, creating components, implementing hooks, or optimizing performance. Covers React 18+ features.

### react-native
React Native mobile development patterns, Expo workflows, and cross-platform UI.
**Use when**: Building mobile apps, working with React Native components, handling native modules, or debugging mobile issues.

### typescript-patterns
TypeScript best practices, type patterns, and strict mode compliance.
**Use when**: Working with TypeScript, defining types, or solving type errors.

### accessibility-patterns
Accessibility patterns for WCAG 2.1 compliance, ARIA, and keyboard navigation.
**Use when**: Implementing accessible components, auditing for a11y issues, adding screen reader support, or ensuring keyboard accessibility.

### performance-optimization
Performance optimization patterns for web applications.
**Use when**: Optimizing load times, bundle sizes, or runtime performance.

---

## Backend & Database

### supabase
Supabase database operations, RLS policies, Edge Functions, and migrations.
**Use when**: Working with Supabase, PostgreSQL queries, authentication, real-time features, or backend logic.

### supabase-migration-cleanup
Generate cleanup migrations that consolidate or remove problematic migrations.
**Use when**: Migration errors, duplicate object errors, or need to consolidate migrations.

### api-design
REST API design patterns, versioning, and documentation.
**Use when**: Designing APIs, implementing endpoints, or documenting APIs.

### database-optimization
Database optimization techniques for PostgreSQL and general SQL.
**Use when**: Optimizing queries, designing indexes, or debugging performance.

### error-handling
Error handling patterns for frontend and backend applications.
**Use when**: Implementing error handling, creating error boundaries, or designing error responses.

---

## Infrastructure & DevOps

### aws-deployment
AWS deployment workflows including ECS, ECR, Lambda, and CloudFormation.
**Use when**: Deploying to AWS, containerizing applications, or setting up infrastructure.

### gcp-patterns
GCP infrastructure patterns for Cloud Run, Cloud Functions, and Firebase.
**Use when**: Deploying to Google Cloud Platform, setting up serverless functions, configuring Firebase projects, or managing GCP infrastructure.

### docker-patterns
Docker and containerization patterns for development and production.
**Use when**: Containerizing applications, optimizing images, or debugging containers.

### ci-cd-pipelines
CI/CD pipeline patterns for GitHub Actions and deployment automation.
**Use when**: Setting up pipelines, automating deployments, or debugging CI issues.

### monitoring-observability
Monitoring and observability patterns for web applications.
**Use when**: Setting up Sentry error tracking, LogRocket session replay, configuring analytics, or implementing logging infrastructure.

### expo-deployment
Expo and EAS deployment patterns for React Native apps.
**Use when**: Building with EAS Build, submitting to app stores, configuring OTA updates, or managing app credentials.

---

## WordPress & Elementor

### wordpress
WordPress development for themes, plugins, and Gutenberg blocks.
**Use when**: Working with WordPress sites, creating themes/plugins, or building custom blocks.

### wordpress-elementor
Elementor and Elementor Pro development patterns for WordPress sites.
**Use when**: Building pages with Elementor, creating custom widgets, extending Elementor functionality, or troubleshooting Elementor issues.

### wordpress-rocketnet
Rocket.net managed WordPress hosting workflows, deployments, and configurations.
**Use when**: Deploying to Rocket.net, setting up staging, managing caches, or configuring Rocket.net-specific features.

### woocommerce-elementor
WooCommerce development with Elementor page builder integration.
**Use when**: Building e-commerce features, customizing product pages, checkout flows, or integrating WooCommerce with Elementor templates.

### html-to-elementor
Convert HTML/Tailwind/CSS prototypes into Elementor Pro build specifications.
**Use when**: Translating web designs into Elementor implementation plans.

---

## Content & Copywriting

### copywriting
Marketing copywriting patterns for landing pages, ads, emails, and conversion content.
**Use when**: Writing persuasive copy, sales pages, ad campaigns, email sequences, or any content designed to drive action.

### ux-writing
UX writing patterns for microcopy, interface text, error messages, and user flows.
**Use when**: Writing button text, form labels, error messages, onboarding flows, empty states, tooltips, or any interface copy.

### brand-voice
Brand voice development and tone-of-voice guidelines.
**Use when**: Creating voice guidelines from scratch, auditing existing voice, defining tone variations, or ensuring copy consistency across touchpoints.

### content-strategy
Content strategy frameworks for planning, creating, and organizing content.
**Use when**: Developing content plans, blog strategies, content audits, editorial calendars, or any systematic content approach.

### documentation-writing
Core documentation writing patterns and best practices.
**Use when**: Creating any documentation, choosing formats, structuring content, or establishing documentation standards for a project.

---

## Client & Business

### client-communication
Patterns for client communication, project updates, and documentation.
**Use when**: Preparing client deliverables, writing updates, or documenting decisions.

### client-onboarding
Client onboarding patterns for discovery, scoping, and project setup.
**Use when**: Starting new client engagements, running discovery sessions, creating scope documents, or setting up project infrastructure.

### client-deliverable
Generate client-facing deliverables summarizing work completed.
**Use when**: Wrapping up client engagements or summarizing completed work.

### pricing-justification
Generate pricing justification with market research and value analysis.
**Use when**: Defending project value or preparing pricing rationale.

---

## Quality & Security

### testing-strategies
Testing strategies for frontend, backend, and E2E testing.
**Use when**: Writing tests, setting up test infrastructure, or debugging test failures.

### security-patterns
Security patterns and best practices for web applications.
**Use when**: Implementing authentication, authorization, or securing APIs.

### security-audit
Security audit for web applications (Supabase, Firebase, custom backends).
**Use when**: Auditing application security posture.

### mvp-readiness
Assess any codebase for production readiness with multi-agent analysis.
**Use when**: Evaluating if a project is ready for launch.

---

## Workflow & Tools

### git-workflows
Git workflows, branching strategies, and collaboration patterns.
**Use when**: Managing branches, resolving conflicts, or setting up workflows.

### github-patterns
Token-efficient GitHub workflows, PR patterns, and repository management.
**Use when**: Working with GitHub via MCP, optimizing API usage, or automating GitHub workflows.

### skill-generator
Create new Claude Code skills with proper structure and YAML frontmatter.
**Use when**: Creating a new skill, documenting reusable knowledge, or saving solutions for future projects.

### skill-maintenance
Maintain skills index and verify skill integrity.
**Use when**: Adding new skills, auditing existing skills, or checking for orphan references between agents and skills.

---

## Usage

### Invoking Skills

Skills are automatically discovered based on context. You can also explicitly invoke them:

```
/skill-name
```

### Skill Structure

Each skill contains:
- `SKILL.md` - Main skill file with instructions
- `references/` - Optional supporting documentation

### Creating New Skills

Use the `skill-generator` skill:

```
/skill-generator
```

Or create manually following the template in `skill-generator/SKILL.md`.

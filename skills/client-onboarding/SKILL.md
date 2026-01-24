---
name: client-onboarding
description: |
  Client onboarding patterns for discovery, scoping, and project setup.
  Use when starting new client engagements, running discovery sessions,
  creating scope documents, or setting up project infrastructure.
  Covers questionnaires, proposals, and kickoff processes.
---

# Client Onboarding

Systematic approach to onboarding new clients for digital projects.

## Onboarding Phases

```
Discovery → Scoping → Proposal → Kickoff → Setup
   │           │          │          │        │
   ▼           ▼          ▼          ▼        ▼
 Needs    Requirements  Pricing   Alignment  Tools
```

## Discovery Process

### Initial Questionnaire

```markdown
## Business Context
1. What is your company/product?
2. Who are your target customers?
3. What problem do you solve for them?
4. Who are your main competitors?

## Project Goals
5. What do you want to build?
6. Why now? What's driving this project?
7. What does success look like?
8. What's your timeline?

## Current State
9. What exists today? (links to current site/app)
10. What's working well?
11. What's not working?
12. What tools/platforms are you using?

## Constraints
13. What's your budget range?
14. Who are the decision makers?
15. Any technical requirements or preferences?
16. Any regulatory/compliance needs?
```

### Discovery Call Agenda

1. **Introductions** (5 min)
   - Background and roles
   - How you found us

2. **Business Understanding** (15 min)
   - Walk through questionnaire answers
   - Probe deeper on key points

3. **Project Deep Dive** (20 min)
   - Specific requirements
   - User journeys/flows
   - Integrations needed

4. **Constraints & Expectations** (10 min)
   - Timeline pressures
   - Budget alignment
   - Decision process

5. **Next Steps** (5 min)
   - Proposal timeline
   - Additional info needed

### Discovery Outputs

- [ ] Meeting notes with key insights
- [ ] User personas (if discussed)
- [ ] High-level requirements list
- [ ] Identified risks and dependencies
- [ ] Follow-up questions

## Scoping Documents

### Scope of Work Template

```markdown
# Scope of Work: [Project Name]

## Project Overview
[2-3 sentence summary of what we're building]

## Objectives
1. [Primary objective]
2. [Secondary objective]
3. [Tertiary objective]

## Deliverables

### Phase 1: [Name] (Weeks 1-X)
- [ ] Deliverable 1
- [ ] Deliverable 2
- [ ] Deliverable 3

### Phase 2: [Name] (Weeks X-Y)
- [ ] Deliverable 4
- [ ] Deliverable 5

## Out of Scope
- Item 1 (explicitly excluded)
- Item 2
- Item 3

## Assumptions
- Client will provide X by [date]
- Existing Y system is compatible with Z
- Team has access to [tools/accounts]

## Dependencies
- External API availability
- Third-party approval/access
- Content/assets from client

## Timeline
| Phase | Duration | Start | End |
|-------|----------|-------|-----|
| Phase 1 | X weeks | Date | Date |
| Phase 2 | Y weeks | Date | Date |
| Buffer | 1 week | Date | Date |

## Team
- [Name]: Role
- [Name]: Role

## Communication
- Weekly status updates on [day]
- Slack channel for daily questions
- Milestone reviews at phase completion
```

### Requirements Format

```markdown
## Feature: [Name]

**User Story**
As a [user type], I want to [action] so that [benefit].

**Acceptance Criteria**
- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

**Technical Notes**
- Integration with X required
- Must support Y browsers

**Priority**: High/Medium/Low
**Estimate**: [days/hours]
```

## Proposal Structure

```markdown
# Proposal: [Project Name]
**Prepared for:** [Client Name]
**Date:** [Date]
**Valid for:** 30 days

## Executive Summary
[1 paragraph: problem + solution + value]

## Understanding
[Show you understand their situation and goals]

## Proposed Solution
[What you'll build and why this approach]

## Deliverables
[Detailed list matching their requirements]

## Timeline
[Visual timeline or table]

## Investment
[Pricing breakdown]

## Why Us
[Relevant experience, approach, differentiators]

## Next Steps
1. Review and discuss
2. Sign agreement
3. Kickoff call
4. Begin work

## Terms
[Payment schedule, cancellation, IP rights]
```

## Kickoff Process

### Kickoff Meeting Agenda

1. **Introductions** (10 min)
   - Team members and roles
   - Communication preferences

2. **Project Review** (15 min)
   - Confirm scope and objectives
   - Walk through timeline
   - Review deliverables

3. **Working Process** (15 min)
   - Communication cadence
   - Tools we'll use
   - Review/approval process

4. **Access & Assets** (10 min)
   - Required credentials
   - Brand assets needed
   - Content requirements

5. **Questions & Concerns** (10 min)
   - Open discussion
   - Risk acknowledgment

### Post-Kickoff Checklist

```markdown
## Immediate (Day 1)
- [ ] Send meeting notes
- [ ] Create project channels (Slack/Teams)
- [ ] Set up shared drive/folder
- [ ] Send access request list

## Week 1
- [ ] Receive all credentials
- [ ] Complete environment setup
- [ ] Begin discovery/design sprint
- [ ] Schedule first status update

## Ongoing
- [ ] Weekly status emails
- [ ] Milestone reviews
- [ ] Risk log updates
```

## Project Setup Checklist

### Development Environment

```markdown
## Repository Setup
- [ ] Create GitHub repo
- [ ] Set up branch protection
- [ ] Configure CI/CD pipeline
- [ ] Add team members

## Infrastructure
- [ ] Create staging environment
- [ ] Set up domain/DNS (if applicable)
- [ ] Configure secrets management
- [ ] Set up error tracking (Sentry)

## Communication
- [ ] Slack/Teams channel
- [ ] Shared document folder
- [ ] Project management tool (Linear, Asana)
- [ ] Meeting cadence established

## Client Access
- [ ] Staging environment access
- [ ] Project board access
- [ ] Document folder access
```

### Tool Recommendations by Project Type

| Project Type | PM Tool | Design | Dev | Hosting |
|--------------|---------|--------|-----|---------|
| Web App | Linear | Figma | GitHub | Vercel/AWS |
| Mobile App | Linear | Figma | GitHub | EAS/AWS |
| WordPress | Asana | Figma | GitHub | Rocket.net |
| E-commerce | Asana | Figma | GitHub | Shopify/WooCommerce |

## Communication Templates

### Weekly Status Update

```markdown
## Week X Status Update

### Completed This Week
- Item 1
- Item 2

### In Progress
- Item 3 (expected completion: [date])
- Item 4

### Blocked/Needs Input
- Issue 1: Need [X] from [person]

### Next Week
- Planned item 1
- Planned item 2

### Timeline Status
🟢 On track / 🟡 At risk / 🔴 Behind
```

### Milestone Review Request

```markdown
## Milestone Review: [Name]

We've completed [milestone] and it's ready for your review.

**Review Link:** [URL]
**Review Deadline:** [Date]

### What's Included
- Feature 1
- Feature 2
- Feature 3

### How to Review
1. Log in at [URL]
2. Test [specific flows]
3. Provide feedback via [method]

### Feedback Format
Please provide feedback as:
- ✅ Approved as-is
- 🔧 Minor changes (list specifics)
- ⚠️ Significant changes (let's discuss)
```

## Red Flags to Watch

### During Discovery
- Can't articulate success metrics
- Unrealistic timeline expectations
- Budget doesn't match scope
- Decision maker unavailable
- Previous vendor relationships ended badly

### During Onboarding
- Delays providing access/credentials
- Scope creep before project starts
- Poor communication responsiveness
- Changing requirements mid-scope

### Mitigation Strategies
- Document everything in writing
- Get sign-off on scope before starting
- Define change request process upfront
- Set clear boundaries early

## References

- `references/discovery-templates.md` - Detailed questionnaires and call guides
- `references/scope-documents.md` - Full SOW templates and examples

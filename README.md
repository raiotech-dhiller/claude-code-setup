# Claude Code Multi-Agent Setup

A comprehensive Claude Code configuration featuring multi-agent orchestration, specialized skills, and automated workflows for fullstack development, WordPress/Elementor sites, and copywriting/content work.

## Overview

This setup extends Claude Code with:

- **7 Specialist Agents** coordinated by an orchestrator
- **15+ Skills** with detailed reference documentation
- **Custom Commands** for common workflows
- **Deployment Scripts** for WordPress/Rocket.net
- **Git-based Version Control** for configuration management

## Quick Start

### Fresh Install
```bash
git clone git@github.com:YOUR_USERNAME/claude-code-setup.git ~/.claude
```

### Existing Setup
```bash
cd ~/.claude
git remote add origin git@github.com:YOUR_USERNAME/claude-code-setup.git
git pull origin main
```

---

## Quick Reference

### All Commands at a Glance

| Category | Command | Purpose |
|----------|---------|---------|
| **WordPress** | `/project:wp-bootstrap [name]` | Scaffold new WordPress project |
| | `/project:wp-deploy staging` | Deploy to Rocket.net staging |
| | `/project:wp-deploy production` | Deploy to Rocket.net production |
| | `/project:wp-sync staging files` | Pull files from staging |
| | `/project:wp-sync staging db` | Pull database from staging |
| | `/project:elementor-create widget [name]` | Create custom Elementor widget |
| | `/project:elementor-create dynamic-tag [name]` | Create custom dynamic tag |
| **Copy & Content** | `/project:copy-brief [type]` | Create structured copy brief |
| | `/project:voice-develop [brand]` | Develop brand voice guidelines |
| | `/project:copy-review [type]` | Review and improve copy |
| | `/project:ux-audit [scope]` | Audit interface copy |
| **Documentation** | `/project:init-docs` | Initialize docs structure |
| | `/project:update-docs` | Update docs after changes |
| **Setup** | `/setup:init` | Initialize Git version control |
| | `/setup:save [message]` | Commit current state |
| | `/setup:backup [tag]` | Create tagged backup |
| | `/setup:restore [ref]` | Rollback to previous state |
| | `/setup:push` | Push to GitHub |
| | `/setup:pull` | Pull from GitHub |

### Agent Quick Reference

| Need | Invoke |
|------|--------|
| Coordinate complex multi-part task | `orchestrator` |
| React/React Native frontend work | `react-specialist` or `react-native-specialist` |
| Supabase backend, auth, database | `supabase-specialist` |
| AWS infrastructure, serverless | `aws-specialist` |
| WordPress/Elementor site building | `wordpress-website-specialist` |
| Marketing copy, landing pages, emails | `copy-specialist` |
| UX writing, microcopy, error messages | `copy-specialist` |
| Brand voice development | `copy-specialist` |
| Technical or user documentation | `docs-specialist` |
| Code review, security audit | `code-reviewer` |

### Copywriting Quick Reference

| Need | Formula/Approach |
|------|------------------|
| **Headline** | [Benefit] + [Timeframe] or [Outcome] without [Obstacle] |
| **CTA Button** | Action verb + specific outcome (e.g., "Start my free trial") |
| **Body Copy** | PAS (Problem → Agitate → Solve) or AIDA |
| **Email Subject** | Curiosity, benefit, or personal angle; 30-50 chars |
| **Value Prop** | [Product] helps [audience] [achieve outcome] so they can [benefit] |

**Tone by Context:**
| Context | Tone |
|---------|------|
| Marketing | Energetic, benefit-focused |
| Error messages | Calm, helpful, never blame |
| Success states | Warm, celebratory (not over the top) |
| Support | Empathetic, solution-focused |
| Legal | Clear, professional |

### UX Writing Quick Reference

| Element | Pattern |
|---------|---------|
| **Button** | Action verb + object (e.g., "Save changes", "Send message") |
| **Error** | [What happened] + [How to fix] |
| **Empty State** | [What goes here] + [Why empty] + [How to add] |
| **Form Label** | Short noun (1-3 words), no colons |
| **Helper Text** | Format requirements or why we're asking |
| **Success** | Confirmation + what happens next |
| **Loading** | [Action]ing... (e.g., "Saving...") |

**Words to Use:**
```
Action: Start, Try, Get, Find, Create, Save, Share
Connection: So, Because, And, But, If, When
```

**Words to Avoid:**
```
Submit, Execute, Initiate, Implement, Utilize, Leverage
Therefore, Thus, However, Consequently, Aforementioned
```

### WordPress/Elementor Quick Reference

| Task | Approach |
|------|----------|
| **New site** | `/project:wp-bootstrap [name]` → configure `.env` → `wp-env start` |
| **Deploy** | `/project:wp-deploy staging` → test → `/project:wp-deploy production` |
| **Custom widget** | `/project:elementor-create widget [name]` |
| **Page layout** | Use containers (flexbox/grid), not sections/columns |
| **Styles** | Use Global Colors/Fonts in Site Settings |
| **Templates** | Create reusable templates in Theme Builder |
| **Performance** | Minimize widgets, optimize images, leverage Rocket.net cache |

**Elementor Responsive Breakpoints:**
| Device | Width |
|--------|-------|
| Desktop | 1025px+ |
| Tablet | 768-1024px |
| Mobile | <768px |

**Cache Clear Sequence:**
1. Elementor > Tools > Regenerate CSS
2. Rocket.net Dashboard > Cache > Purge All
3. Browser hard refresh

### Brand Voice Quick Reference

**Voice Attributes (pick 3-5):**
```
Friendly, Warm, Conversational, Playful, Witty, Casual, Human
Professional, Authoritative, Expert, Trustworthy, Reliable, Sophisticated
Bold, Direct, Confident, Innovative, Empowering, Approachable
```

**Voice Statement Template:**
```
[Brand] is [attribute 1], [attribute 2], and [attribute 3].
We talk to customers like [relationship analogy].
We always [do thing]. We never [avoid thing].
```

**Tone Spectrum:**
```
Serious ←――――――――――――――――→ Playful

Errors:     ●――――――――――――――――――――
Support:    ―――●―――――――――――――――――
Product UI: ――――――――●――――――――――――
Marketing:  ―――――――――――――●―――――――
Social:     ――――――――――――――――●――――
```

### Documentation Quick Reference

| Doc Type | Location | Purpose |
|----------|----------|---------|
| Getting Started | `docs/user/getting-started.md` | First-time user setup |
| Feature Guides | `docs/user/features/` | How to use features |
| How-To | `docs/user/how-to/` | Task-based guides |
| API Reference | `docs/technical/api/` | Endpoint documentation |
| Architecture | `docs/technical/architecture/` | System design |
| ADRs | `docs/technical/decisions/` | Architecture decisions |

**When to Update Docs:**
| Change | Update |
|--------|--------|
| New user-facing feature | User guide |
| API change | API docs |
| Database change | Schema docs |
| Architecture decision | ADR |
| Breaking change | Changelog + migration guide |

### Setup Management Quick Reference

```bash
# Initialize (first time only)
~/.claude/scripts/setup-manage.sh init

# Daily workflow
~/.claude/scripts/setup-manage.sh save "Description of changes"

# Before experiments
~/.claude/scripts/setup-manage.sh backup pre-experiment-name

# If experiment fails
~/.claude/scripts/setup-manage.sh restore pre-experiment-name

# Sync with GitHub
~/.claude/scripts/setup-manage.sh push
~/.claude/scripts/setup-manage.sh pull
```

**Git Commands (if not using script):**
| Task | Command |
|------|---------|
| Save changes | `git add . && git commit -m "message"` |
| Create backup | `git tag -a v1.x-name -m "description"` |
| View history | `git log --oneline` |
| View tags | `git tag -l` |
| Undo uncommitted | `git checkout -- .` |
| Rollback to tag | `git reset --hard tag-name` |

---

## What's Included

### Agents

| Agent | Purpose |
|-------|---------|
| `orchestrator` | Coordinates multi-agent tasks, manages context, delegates to specialists |
| `react-specialist` | React, React Native, TypeScript, frontend development |
| `react-native-specialist` | Mobile app development with React Native |
| `supabase-specialist` | Supabase backend, auth, database, edge functions |
| `aws-specialist` | AWS infrastructure, serverless, DevOps |
| `wordpress-website-specialist` | Elementor sites, Rocket.net hosting, WooCommerce |
| `copy-specialist` | Marketing copy, UX writing, brand voice, content strategy |
| `docs-specialist` | Technical and user documentation |
| `code-reviewer` | Code quality, security, performance reviews |
| `knowledge-curator` | Maintains project knowledge and learnings |

### Skills

#### Development
- `react-patterns` - React best practices and patterns
- `react-native-patterns` - Mobile development patterns
- `supabase` - Supabase integration patterns
- `aws` - AWS service patterns
- `typescript-patterns` - TypeScript best practices
- `testing-strategies` - Testing approaches

#### WordPress
- `wordpress-elementor` - Elementor development, custom widgets, theme builder
- `wordpress-rocketnet` - Rocket.net deployment, local dev, performance
- `woocommerce-elementor` - WooCommerce + Elementor integration

#### Copy & Content
- `copywriting` - Landing pages, emails, ads, headlines
- `ux-writing` - Microcopy, errors, forms, onboarding, empty states
- `brand-voice` - Voice development, tone guidelines
- `content-strategy` - Content planning, pillars, editorial calendars

#### Documentation
- `documentation-writing` - User docs, technical docs, API docs

### Commands

#### Project Management
- `/project:init` - Initialize new project with templates
- `/project:status` - Check project state and context

#### WordPress
- `/project:wp-bootstrap` - Scaffold new WordPress project
- `/project:wp-deploy` - Deploy to Rocket.net (staging/production)
- `/project:wp-sync` - Sync files/database from Rocket.net
- `/project:elementor-create` - Scaffold Elementor widgets/dynamic tags

#### Copy & Content
- `/project:copy-brief` - Create structured copy brief
- `/project:voice-develop` - Develop brand voice guidelines
- `/project:copy-review` - Review and improve existing copy
- `/project:ux-audit` - Audit interface copy

#### Documentation
- `/project:init-docs` - Initialize documentation structure
- `/project:update-docs` - Update documentation after changes

#### Setup Management
- `/setup:init` - Initialize Git version control
- `/setup:save` - Commit current configuration
- `/setup:backup` - Create tagged backup point
- `/setup:restore` - Rollback to previous state

---

## Directory Structure

```
~/.claude/
├── agents/
│   ├── orchestrator.md
│   ├── react-specialist.md
│   ├── react-native-specialist.md
│   ├── supabase-specialist.md
│   ├── aws-specialist.md
│   ├── wordpress-website-specialist.md
│   ├── copy-specialist.md
│   ├── docs-specialist.md
│   ├── code-reviewer.md
│   └── knowledge-curator.md
│
├── skills/
│   ├── copywriting/
│   │   ├── SKILL.md
│   │   └── references/
│   │       ├── landing-page-copy.md
│   │       ├── email-copywriting.md
│   │       ├── ad-copywriting.md
│   │       └── headline-formulas.md
│   ├── ux-writing/
│   │   ├── SKILL.md
│   │   └── references/
│   │       ├── error-messages.md
│   │       ├── onboarding-copy.md
│   │       ├── form-copy.md
│   │       └── empty-states.md
│   ├── brand-voice/
│   │   ├── SKILL.md
│   │   └── references/
│   │       └── voice-workshop.md
│   ├── content-strategy/
│   │   └── SKILL.md
│   ├── wordpress-elementor/
│   │   ├── SKILL.md
│   │   └── references/
│   │       ├── elementor-widgets.md
│   │       ├── elementor-dynamic-tags.md
│   │       ├── elementor-theme-builder.md
│   │       └── essential-addons.md
│   ├── wordpress-rocketnet/
│   │   ├── SKILL.md
│   │   └── references/
│   │       ├── rocketnet-deployment.md
│   │       ├── local-development.md
│   │       └── rocketnet-performance.md
│   ├── woocommerce-elementor/
│   │   └── SKILL.md
│   └── documentation-writing/
│       ├── SKILL.md
│       └── references/
│
├── commands/
│   ├── wp-bootstrap.md
│   ├── wp-deploy.md
│   ├── wp-sync.md
│   ├── elementor-create.md
│   ├── copy-brief.md
│   ├── voice-develop.md
│   ├── copy-review.md
│   ├── ux-audit.md
│   ├── init-docs.md
│   ├── update-docs.md
│   └── setup-manage.md
│
├── scripts/
│   ├── wp-deploy.sh
│   └── setup-manage.sh
│
├── hooks/
│   └── post-wp-deploy.sh
│
├── .gitignore
└── README.md
```

---

## Workflows

### Multi-Agent Orchestration

For complex tasks, the orchestrator coordinates specialists:

```
User Request
    │
    ▼
Orchestrator
    │
    ├─► react-specialist (frontend)
    ├─► supabase-specialist (backend)
    ├─► copy-specialist (content)
    └─► docs-specialist (documentation)
    │
    ▼
Coordinated Output
```

### WordPress Development

```
/project:wp-bootstrap client-site
    │
    ▼
Local Development (wp-env)
    │
    ▼
/project:wp-deploy staging
    │
    ▼
Test on Rocket.net Staging
    │
    ▼
/project:wp-deploy production
```

### Copy & Content

```
/project:voice-develop brand-name
    │
    ▼
Brand Voice Guidelines
    │
    ▼
/project:copy-brief landing
    │
    ▼
Copy Creation
    │
    ▼
/project:copy-review landing
```

---

## Customization

### Adding a New Agent

Create `~/.claude/agents/new-specialist.md`:

```markdown
---
name: new-specialist
description: |
  Description of what this agent does.
  PROACTIVELY invoke for relevant tasks.
model: sonnet
tools: Read, Write, Edit, Bash, Glob, Grep
skills: relevant-skill
color: blue
---

# New Specialist Agent

[Agent instructions and expertise]
```

### Adding a New Skill

Create `~/.claude/skills/new-skill/SKILL.md`:

```markdown
---
name: new-skill
description: |
  Description of what this skill covers.
---

# Skill Name

## Reference Loading
| Topic | File | Load When |
|-------|------|-----------|
| Topic | `references/topic.md` | When doing X |

[Skill content]
```

### Adding a New Command

Create `~/.claude/commands/new-command.md`:

```markdown
# Command Name

Description of what this command does.

## Usage
\`\`\`
/project:command-name [args]
\`\`\`

## Workflow
[Steps the command follows]

## Output
[What it produces]
```

---

## Tech Stack Support

### Primary Stack
- React / React Native
- TypeScript
- Supabase
- AWS / GCP

### WordPress Stack
- Elementor / Elementor Pro
- Essential Addons for Elementor
- WooCommerce
- RankMath Pro
- LeadConnector / WP Fusion
- WP Mail SMTP
- Smush

### Hosting
- Rocket.net (WordPress)
- AWS (Applications)
- Vercel / Netlify (Frontend)

---

## Contributing

1. Create a branch: `git checkout -b feature/new-addition`
2. Make changes
3. Test locally with Claude Code
4. Commit: `git commit -m "feat: Added new feature"`
5. Push and create PR

## Version History

Use `git tag -l` to see backup points, or check [Releases](../../releases).

## License

Private configuration - modify as needed for your use.

---

*Built for [Raiotech](https://raiotech.com) digital solutions agency.*

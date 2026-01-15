# Copy Brief Command

Create a structured brief for any copywriting project.

## Usage
```
/project:copy-brief [type]
```

**Types:**
- `landing` - Landing page copy brief
- `email` - Email sequence brief
- `ux` - UX copy audit/brief
- `brand` - Brand voice development brief
- `ad` - Ad campaign brief
- `blog` - Blog post/content brief

## Workflow

When invoked, copy-specialist will gather information through questions:

### Core Questions (All Types)
1. **Goal**: What should this copy achieve?
2. **Audience**: Who is reading this?
3. **Context**: Where does this appear?
4. **Voice**: What's the brand's voice? (Or should we develop it?)
5. **Constraints**: Any limitations (length, format, requirements)?

### Type-Specific Questions

#### Landing Page
- What's the offer/product?
- What's the primary CTA?
- What objections need addressing?
- What proof points exist?

#### Email
- What's the sequence goal?
- How many emails?
- What's the current relationship with recipients?
- What actions should they take?

#### UX
- What flow/feature?
- What user states exist?
- Any existing copy to audit?
- Technical constraints?

#### Brand Voice
- Does any voice documentation exist?
- Who are brand stakeholders?
- Brand examples they admire?
- Brands they want to avoid sounding like?

#### Ad Campaign
- Platform(s)?
- Budget level (affects variation needs)?
- Funnel stage targeting?
- Any existing creative/copy?

#### Blog/Content
- Topic/angle?
- Target keywords (if SEO)?
- Content pillar this belongs to?
- Related content to link?

## Output

After gathering information, copy-specialist produces:

```markdown
# Copy Brief: [Project Name]

## Overview
**Project**: [Type of copy]
**Goal**: [What it should achieve]
**Deadline**: [If applicable]

## Audience
**Who**: [Description]
**Stage**: [Awareness/Consideration/Decision]
**Mindset**: [What they're thinking/feeling]

## Voice & Tone
**Voice**: [Brand attributes]
**Tone for this piece**: [Specific tone]
**Reference**: [Link to voice guidelines or notes]

## Key Messages
1. [Primary message/benefit]
2. [Secondary message]
3. [Supporting point]

## Proof Points
- [Statistic, testimonial, or evidence]
- [Another proof point]

## Constraints
- [Length, format, technical requirements]

## Deliverables
- [ ] [Specific deliverable]
- [ ] [Another deliverable]

## Reference Materials
- [Links to relevant docs, competitors, inspiration]

---
*Brief created: [Date]*
```

## Integration

Copy briefs can be:
- Saved to project `.claude/briefs/` for reference
- Used as input for copy generation
- Shared with clients for approval before writing

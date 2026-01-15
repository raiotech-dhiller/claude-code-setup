# Copy Review Command

Review and improve existing copy against best practices or brand voice.

## Usage
```
/project:copy-review [type] [optional: voice-guidelines-path]
```

**Types:**
- `landing` - Review landing page copy
- `email` - Review email copy
- `ux` - Review UX/interface copy
- `ad` - Review ad copy
- `general` - General copy review

## What It Reviews

### Clarity
- Is the message clear?
- Is it easy to understand?
- Are there confusing phrases?

### Effectiveness
- Does it serve its goal?
- Is it benefit-focused?
- Are CTAs clear and compelling?

### Voice Consistency
- Does it match brand voice (if guidelines provided)?
- Is tone appropriate for context?
- Are there off-brand phrases?

### Technical
- Grammar and spelling
- Punctuation consistency
- Formatting issues

### Best Practices
- Active voice usage
- Sentence/paragraph length
- Scanability
- Jargon avoidance

## Output Format

```markdown
# Copy Review: [Page/Asset Name]

## Summary
**Overall Assessment:** [Good/Needs Work/Major Issues]
**Voice Match:** [If guidelines provided: Strong/Moderate/Weak]

## Critical Issues (Must Fix)
1. **[Issue]**
   - Location: [Where in copy]
   - Problem: [What's wrong]
   - Suggestion: [How to fix]

## Recommendations (Should Fix)
1. **[Issue]**
   - Location: [Where]
   - Current: "[Current copy]"
   - Suggested: "[Improved copy]"

## Minor Suggestions (Consider)
1. [Suggestion]

## What's Working Well
- [Positive observation]
- [Another strength]

## Revised Copy (if requested)
[Full revised version with changes highlighted]
```

## Review Checklist

### Clarity
- [ ] Main message clear within 5 seconds?
- [ ] No jargon without explanation?
- [ ] One idea per paragraph?
- [ ] Specific over vague?

### Effectiveness
- [ ] Benefit-focused (not feature-focused)?
- [ ] Reader-centric (you > we)?
- [ ] Clear call-to-action?
- [ ] Social proof where appropriate?

### Voice
- [ ] Matches brand attributes?
- [ ] Tone right for context?
- [ ] Consistent throughout?

### Technical
- [ ] Grammar correct?
- [ ] Spelling checked?
- [ ] Punctuation consistent?
- [ ] Formatting clean?

### By Type

**Landing Pages:**
- [ ] Headline compelling?
- [ ] Above-fold value clear?
- [ ] Objections addressed?
- [ ] Multiple CTAs consistent?

**Emails:**
- [ ] Subject line compelling?
- [ ] Preview text optimized?
- [ ] Opening hook strong?
- [ ] CTA clear and singular?

**UX Copy:**
- [ ] Labels clear?
- [ ] Errors helpful?
- [ ] Success states confirmed?
- [ ] Button text actionable?

**Ads:**
- [ ] Within character limits?
- [ ] Hook in first line?
- [ ] CTA matches goal?
- [ ] Platform best practices followed?

## Integration

Can be used with:
- Uploaded copy documents
- URLs to review (if accessible)
- Code files containing copy strings
- Figma/design file copy (manually provided)

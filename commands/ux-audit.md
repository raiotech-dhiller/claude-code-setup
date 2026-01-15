# UX Copy Audit Command

Comprehensive audit of interface copy across a product or feature.

## Usage
```
/project:ux-audit [scope]
```

**Scope:**
- `full` - Audit entire product/site
- `flow:[name]` - Audit specific user flow (e.g., `flow:signup`)
- `feature:[name]` - Audit specific feature
- `page:[name]` - Audit specific page/screen

## Input Methods

### 1. File-Based
Provide copy strings file:
```json
{
  "login.title": "Sign in to your account",
  "login.email_label": "Email",
  "login.password_label": "Password",
  "login.submit": "Sign in",
  "login.error.invalid": "Invalid email or password"
}
```

### 2. Screenshot/Visual
Describe or provide screenshots of screens to audit.

### 3. URL
Provide URL to walk through and audit (if accessible).

### 4. Component List
List screens/components to audit manually.

## Audit Dimensions

### 1. Clarity
- Is it immediately understandable?
- Does it avoid jargon?
- Is it specific enough?

### 2. Consistency
- Same terms for same things?
- Consistent capitalization?
- Consistent button patterns?

### 3. Helpfulness
- Do errors explain what to do?
- Is help text actually helpful?
- Are empty states actionable?

### 4. Tone
- Appropriate for context?
- Consistent with brand?
- Never blaming user?

### 5. Accessibility
- Screen reader friendly?
- Clear without context?
- Not relying on color alone?

## Output Format

```markdown
# UX Copy Audit: [Product/Feature]

## Executive Summary
**Scope:** [What was audited]
**Overall Grade:** [A-F]
**Priority Issues:** [Count]
**Total Recommendations:** [Count]

## Scores by Dimension
| Dimension | Score | Notes |
|-----------|-------|-------|
| Clarity | [A-F] | [Brief note] |
| Consistency | [A-F] | [Brief note] |
| Helpfulness | [A-F] | [Brief note] |
| Tone | [A-F] | [Brief note] |
| Accessibility | [A-F] | [Brief note] |

## Critical Issues (Fix Immediately)

### Issue 1: [Description]
**Location:** [Screen/component]
**Current:** "[Current copy]"
**Problem:** [What's wrong]
**Recommended:** "[Better copy]"
**Impact:** [Why it matters]

## High Priority (Fix Soon)
[Same format...]

## Medium Priority (Improve)
[Same format...]

## Low Priority (Nice to Have)
[Same format...]

## Consistency Report

### Terminology Inconsistencies
| Concept | Variations Found | Recommendation |
|---------|------------------|----------------|
| [e.g., Account] | "Account", "Profile", "Settings" | Use "Account" |

### Capitalization Issues
| Pattern | Found | Should Be |
|---------|-------|-----------|
| [e.g., Button text] | "Sign In", "Sign in" | "Sign in" |

### Punctuation Issues
| Pattern | Found | Should Be |
|---------|-------|-----------|
| [e.g., Error messages] | Some with periods, some without | All without |

## Copy Deck (Recommended)

### [Screen/Flow Name]
| Element | Current | Recommended |
|---------|---------|-------------|
| Page title | [Current] | [Recommended] |
| Button | [Current] | [Recommended] |
| Error | [Current] | [Recommended] |

## Patterns to Standardize

### Error Messages
```
Standard format: [What went wrong]. [How to fix it].
Example: "That email is already registered. Sign in or use a different email."
```

### Success Messages
```
Standard format: [Confirmation]!
Example: "Changes saved!"
```

### Empty States
```
Standard format: 
[What would be here]
[Why it's empty or how to add content]
[CTA if applicable]
```

## Next Steps
1. [ ] Fix critical issues
2. [ ] Create copy style guide for UX
3. [ ] Standardize patterns
4. [ ] Review changes before deploy
```

## Deliverables

1. **Audit Report** - Full findings document
2. **Copy Deck** - Spreadsheet/table of all copy with recommendations
3. **Style Guide Suggestions** - Patterns to standardize

## Integration

After audit, copy-specialist can:
- Generate updated copy strings file
- Create UX copy guidelines
- Review implementation of fixes

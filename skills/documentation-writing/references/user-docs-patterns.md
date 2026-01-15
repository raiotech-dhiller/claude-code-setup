# User Documentation Patterns

## Audience Definition

### Characteristics
- Non-technical users
- Goal-oriented (want to accomplish something)
- Limited patience for reading
- May skim for relevant sections
- Various skill levels with the product

### Writing For Users
- Avoid jargon and technical terms
- When technical terms necessary, define them
- Use the same terminology as the UI
- Focus on outcomes, not mechanisms

## User Guide Structure

### Getting Started Guide
```markdown
# Getting Started with [Product]

Welcome! This guide will help you [main outcome] in about [time estimate].

## What You'll Need
- [Prerequisite 1]
- [Prerequisite 2]

## Create Your Account

1. Go to [URL or location]
2. Click **Sign Up**
3. Enter your [specific fields]
4. Click **Create Account**

You'll receive a confirmation email within a few minutes.

## Your First [Action]

Now let's [main first task]:

1. From your dashboard, click **[Button Name]**
2. [Next step with specific details]
...

## What's Next?
- [Link to next logical guide]
- [Link to related feature]
```

### Feature Guide
```markdown
# [Feature Name]

[One sentence: what this feature does and why you'd use it]

## Overview
[2-3 sentences expanding on the feature's purpose]

## How It Works

### [Main Capability]
1. Navigate to **[Location in UI]**
2. Click **[Specific button/link]**
3. [Continue with numbered steps]

### [Secondary Capability]
...

## Examples

### Example: [Common Use Case]
[Walk through a realistic scenario]

## Tips
- [Practical tip 1]
- [Practical tip 2]

## Limitations
- [What the feature doesn't do]
- [Known constraints]

## Related Features
- [Link to complementary feature]
```

### How-To Guide
```markdown
# How to [Accomplish Specific Task]

This guide shows you how to [outcome].

**Time needed**: [estimate]
**Difficulty**: [Beginner/Intermediate/Advanced]

## Before You Begin
- [Prerequisite]
- [Required permissions or setup]

## Steps

### 1. [First Major Action]
[Detailed instruction]

> **Tip**: [Helpful context]

### 2. [Second Major Action]
[Detailed instruction]

### 3. [Continue as needed]

## Verify It Worked
[How to confirm success]

## Troubleshooting

### [Common Issue]
**Cause**: [Why this happens]
**Solution**: [How to fix]

## Related How-Tos
- [How to related task]
```

### User Flow Documentation
```markdown
# [Flow Name] User Flow

## Overview
[Describe the complete journey from start to finish]

## Prerequisites
- [Account type needed]
- [Required setup]

## The Flow

### Step 1: [Starting Point]
**Where**: [UI location]
**What happens**: [Description]
**User action**: [What they do]

### Step 2: [Next Stage]
...

## Decision Points
At [stage], users may choose to:
- **Option A**: [Path and outcome]
- **Option B**: [Path and outcome]

## Success State
[How users know they've completed the flow]

## Common Variations
- [Variation 1: Description]
- [Variation 2: Description]
```

## Language Guidelines

### Action Verbs (Use These)
- Click, Tap, Select
- Enter, Type
- Choose, Pick
- Open, Close
- Save, Submit, Confirm
- Navigate, Go to
- Review, Check

### Avoid These Phrases
| Instead of | Use |
|------------|-----|
| "Simply" | (just remove it) |
| "Just" | (just remove it) |
| "Obviously" | (remove - not obvious to everyone) |
| "Easy" | (remove - subjective) |
| "Utilize" | "Use" |
| "In order to" | "To" |
| "Please" | (remove - direct is better) |

### UI Element References
```markdown
<!-- Be specific about UI elements -->
✓ Click the **Save** button
✓ Select **Settings** from the menu
✓ Enter your email in the **Email** field

✗ Click the button
✗ Select from the dropdown
✗ Enter your information
```

## Visual Guidelines

### When to Use Screenshots
- New or complex UI that benefits from visual reference
- Multi-step processes where location matters
- Features with non-obvious locations

### When NOT to Use Screenshots
- Simple, text-based interactions
- Frequently changing UI
- Mobile documentation (varies by device)

### Screenshot Best Practices
- Crop to relevant area
- Add callouts for specific elements
- Use consistent dimensions
- Update when UI changes
- Provide alt text for accessibility

## Error Message Documentation

### Pattern
```markdown
### Error: [Exact Error Message]

**What it means**: [Plain language explanation]

**Why it happens**:
- [Reason 1]
- [Reason 2]

**How to fix it**:
1. [Step to resolve]
2. [Additional steps if needed]

**Still seeing this error?** [Contact support link or escalation path]
```

## FAQ Structure

```markdown
# Frequently Asked Questions

## Getting Started
<details>
<summary>How do I create an account?</summary>

[Answer with link to detailed guide if lengthy]

</details>

## [Feature Category]
<details>
<summary>[Question as user would ask it?]</summary>

[Concise answer]

</details>
```

## Accessibility Considerations

- Use descriptive link text
- Provide alt text for images
- Ensure color isn't the only indicator
- Use proper heading hierarchy
- Keep language simple (aim for 8th grade reading level)

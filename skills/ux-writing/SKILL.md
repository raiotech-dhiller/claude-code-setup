---
name: ux-writing
description: |
  UX writing patterns for microcopy, interface text, error messages, and user flows.
  Use when writing button text, form labels, error messages, onboarding flows,
  empty states, tooltips, or any interface copy.
---

# UX Writing

## Reference Loading
| Topic | File | Load When |
|-------|------|-----------|
| Error Messages | `references/error-messages.md` | Writing error states |
| Onboarding | `references/onboarding-copy.md` | Writing first-time user flows |
| Forms | `references/form-copy.md` | Writing form labels and validation |
| Empty States | `references/empty-states.md` | Writing zero-data screens |

## Core Principles

### Clarity Above All
```
❌ An error has occurred during the authentication process
✓ Wrong password. Try again or reset it.

❌ Your request has been submitted for processing
✓ Got it! We'll email you within 24 hours.
```

### Concise But Complete
```
❌ Click here to proceed to the next step
✓ Continue

❌ Save
✓ Save changes (when context helps)
```

### Helpful Over Clever
```
❌ Oops! Something went kaboom! 💥
✓ Something went wrong. Try refreshing the page.

❌ You're all caught up! Nothing to see here, friend!
✓ No new notifications
```

### Human, Not Robotic
```
❌ Error: Invalid input in field_email
✓ That email doesn't look right. Check for typos?

❌ Operation completed successfully
✓ Done!
```

## Voice & Tone Framework

### Voice (Consistent)
- Clear
- Helpful
- Respectful
- Confident

### Tone (Adapts to Context)
| Context | Tone | Example |
|---------|------|---------|
| Success | Warm, celebratory | "You're all set!" |
| Error | Calm, helpful | "That didn't work. Try again?" |
| Warning | Direct, clear | "This will delete your account." |
| Neutral | Matter-of-fact | "3 items in cart" |
| Onboarding | Encouraging | "Great start! Just 2 more steps." |

## Button Copy

### Action Verbs
```
✓ Save changes
✓ Send message
✓ Create account
✓ Add to cart
✓ Start free trial

❌ Submit
❌ OK
❌ Click here
❌ Yes
```

### Specific > Generic
```
✓ Save draft
✓ Publish post
✓ Delete account
✓ Export as PDF

❌ Save
❌ Continue
❌ Delete
❌ Export
```

### Button Pairs
```
Primary | Secondary
--------|----------
Save changes | Discard
Delete | Keep
Confirm purchase | Cancel
Send | Save as draft
```

### Destructive Actions
```
Button: Delete project
Confirmation: "Delete 'Project Name'? This can't be undone."
Actions: [Cancel] [Delete project]
```

## Labels & Form Copy

### Input Labels
```
✓ Email
✓ Password (8+ characters)
✓ Company name (optional)

❌ Enter your email address:
❌ Password*
❌ Company name (this field is not required)
```

### Placeholder Text
```
✓ name@company.com (example format)
✓ Search projects...
✓ Write a message

❌ Enter email here (redundant with label)
❌ Type here (unhelpful)
```

### Helper Text
```
When to use:
- Format requirements
- Why we're asking
- What happens with this info

Examples:
"We'll send a confirmation to this address"
"8+ characters with a number"
"Used for your public profile"
```

## Error Messages

### Formula
```
[What happened] + [Why/What went wrong] + [How to fix it]
```

### Examples
```
❌ Error 422
✓ That email is already registered. Sign in or use a different email.

❌ Invalid input
✓ Please enter a valid phone number (e.g., 555-123-4567)

❌ Request failed
✓ Couldn't save. Check your connection and try again.
```

### Error Tone
```
Don't blame:
❌ You entered an invalid email
✓ That email doesn't look right

Be specific:
❌ Something went wrong
✓ Couldn't upload file—it's too large (max 10MB)

Offer a path forward:
❌ Error: Connection timeout
✓ Connection lost. Check your internet and try again.
```

## Success Messages

### Confirmation Copy
```
✓ Changes saved
✓ Message sent!
✓ Account created — check your email
✓ Payment complete. Receipt on its way.
```

### Appropriate Enthusiasm
```
Low stakes: "Saved" (matter-of-fact)
Medium stakes: "Message sent!" (light celebration)
High stakes: "Congratulations! Your application is submitted." (celebratory)
```

## Empty States

### Components
1. What this area is for
2. Why it's empty
3. How to fill it

### Examples
```
No projects yet
Create your first project to get started.
[Create project]

No messages
When you receive messages, they'll appear here.

No results for "xyz"
Try a different search term or check your spelling.
```

## Loading & Progress

### Loading States
```
✓ Loading projects...
✓ Saving changes...
✓ Searching...

❌ Please wait...
❌ Loading, please wait...
```

### Progress Indicators
```
Step 1 of 3: Basic info
Step 2 of 3: Preferences
Step 3 of 3: Confirmation

"Uploading... 3 of 10 files"
"Processing your request (usually takes 2-3 minutes)"
```

## Tooltips & Help Text

### When to Use
- Explain unfamiliar terms
- Provide additional context
- Show keyboard shortcuts
- Clarify icon meanings

### Writing Tips
```
✓ Brief (1-2 sentences max)
✓ Answers "what is this?" or "why?"
✓ Actionable when possible

Examples:
"Archive projects you're done with. You can restore them later."
"Your display name appears on your public profile."
"Keyboard shortcut: ⌘K"
```

## Notifications

### In-App Notifications
```
Structure: [What happened] + [Relevant detail]

Examples:
"Sarah commented on your post"
"Project 'Website Redesign' was shared with you"
"Your export is ready to download"
```

### Push Notifications
```
Keep under 50 characters when possible
Front-load the important info
Make action clear

Examples:
"New comment from Sarah on 'Project X'"
"Your report is ready"
"Meeting starts in 15 minutes"
```

## Permissions & Access

### Asking for Permissions
```
Why we need it:
"Allow notifications to get updates on your orders."
"Allow location to find stores near you."

Clear options:
[Allow] [Not now]
```

### Access Denied Messages
```
"You don't have access to this project. Contact the owner to request access."
"This action requires admin permissions."
```

## Confirmation Dialogs

### Structure
```
Headline: [Action being confirmed]
Body: [Consequence or context]
Actions: [Cancel] [Confirm action]
```

### Examples
```
Delete this project?
All files and data in "Website Redesign" will be permanently deleted.
[Cancel] [Delete project]

Discard unsaved changes?
You have unsaved changes that will be lost.
[Keep editing] [Discard]

Log out of all devices?
You'll need to sign in again on each device.
[Cancel] [Log out everywhere]
```

## Microcopy Checklist

- [ ] Is it clear what the user should do?
- [ ] Is it as short as possible while still being clear?
- [ ] Does the tone match the context?
- [ ] Does it use familiar words?
- [ ] Does it tell them what happens next?
- [ ] Would a first-time user understand it?
- [ ] Does it avoid jargon and technical terms?
- [ ] Does it treat the user respectfully?

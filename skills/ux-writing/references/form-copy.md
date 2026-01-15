# Form Copy

## Form Anatomy

```
┌─────────────────────────────────────────┐
│ Form Title                              │
│ Optional description                    │
├─────────────────────────────────────────┤
│                                         │
│ Label                                   │
│ ┌─────────────────────────────────────┐ │
│ │ Placeholder                         │ │
│ └─────────────────────────────────────┘ │
│ Helper text                             │
│                                         │
│ Label *                                 │
│ ┌─────────────────────────────────────┐ │
│ │ Input                               │ │
│ └─────────────────────────────────────┘ │
│ ⚠️ Error message                        │
│                                         │
│            [Secondary] [Primary CTA]    │
│                                         │
│ Footer text (privacy, terms, etc.)      │
└─────────────────────────────────────────┘
```

## Labels

### Best Practices
```
✓ Short (1-3 words)
✓ Clear (no jargon)
✓ Noun or noun phrase

✓ Email
✓ Full name
✓ Company name

❌ Please enter your email address
❌ Your email
❌ E-mail Address:
```

### Label Patterns
| Field Type | Good Label |
|------------|------------|
| Email | Email |
| Password | Password |
| Name | Full name / First name / Last name |
| Phone | Phone number |
| Address | Address line 1, City, ZIP code |
| Company | Company name |
| Date | Date of birth / Start date |

### Optional vs Required
```
Option 1: Mark optional fields
Company name (optional)

Option 2: Mark required fields
Email *
* Required

Recommendation: Mark the less common one.
(If most are required, mark optional; if most are optional, mark required)
```

## Placeholder Text

### When to Use
- Show format examples
- Indicate expected input
- NOT as a replacement for labels

### Good Placeholders
```
Email: name@company.com
Phone: (555) 123-4567
Date: MM/DD/YYYY
Search: Search projects...
URL: https://
```

### Bad Placeholders
```
❌ Enter your email (redundant with label)
❌ Type here (unhelpful)
❌ Email * (using as label)
❌ This field is for your email address (too long)
```

## Helper Text

### When to Use
- Explain format requirements
- Clarify why you're asking
- Set expectations for what happens
- Provide examples

### Placement
Below the input field, visible before interaction.

### Examples
```
Password
[        ]
8+ characters with at least one number

Company website
[        ]
We'll use this to personalize your experience

Email
[        ]
We'll send order updates here
```

## Error Messages

### Placement
Directly below the relevant field, in red/error color.

### Formula
```
[What's wrong] + [How to fix it]
```

### By Field Type
```
Email:
❌ Invalid email
✓ Enter a valid email (e.g., name@company.com)

Password:
❌ Password too short
✓ Password must be at least 8 characters

Required field:
❌ Required
✓ Enter your [field name]

Phone:
❌ Invalid
✓ Enter a 10-digit phone number

Date:
❌ Invalid date
✓ Enter a date in MM/DD/YYYY format
```

### Real-Time vs Submit Validation
```
Real-time (on blur):
- Format validation
- Length requirements
- Duplicate checking

On submit:
- Required field checking
- Cross-field validation
- Server-side validation
```

## Button Copy

### Primary Actions
```
✓ Sign up
✓ Create account
✓ Save changes
✓ Send message
✓ Submit request
✓ Continue to payment

❌ Submit
❌ OK
❌ Next
```

### Secondary Actions
```
✓ Cancel
✓ Go back
✓ Save draft
✓ Clear form
```

### Destructive Actions
```
✓ Delete account
✓ Remove from team
✓ Cancel subscription
```

### Button Pairs
```
Save changes / Discard changes
Continue / Go back
Submit / Cancel
Delete / Keep
```

## Form Headers & Descriptions

### Titles
```
Create your account
Contact us
Request a demo
Complete your profile
Update your settings
```

### Descriptions
```
"Sign up in 30 seconds. No credit card required."
"Fill out this form and we'll be in touch within 24 hours."
"Tell us a bit about yourself to personalize your experience."
```

## Multi-Step Forms

### Step Indicators
```
Step 1 of 3: Account details
Step 2 of 3: Preferences
Step 3 of 3: Confirmation

━━━━━━━━━━ ○ ○ ○ 33%
```

### Navigation
```
[Back] [Continue]
[Previous step] [Next: Preferences]
[Save and exit] [Continue]
```

### Step Titles
```
Step 1: Basic information
Step 2: Customize your experience
Step 3: Invite your team
Step 4: Review and submit
```

## Success States

### Inline Success
```
✓ Changes saved
✓ Email verified
✓ Password updated
```

### Full-Page Success
```
Thank you!
We've received your request and will be in touch within 24 hours.
[Return to homepage]

---

Account created!
Check your email to verify your address.
[Resend email] [Continue to dashboard]
```

## Form Microcopy Patterns

### Auto-Save
```
"Saving..." → "Changes saved"
"Draft auto-saved at 2:34 PM"
```

### Character Counts
```
Bio (500 characters max)
[                    ] 127/500

Message
[                    ] 43/280
```

### Password Requirements
```
Password must:
✓ Be at least 8 characters
✗ Include a number
✗ Include an uppercase letter
```

### Field Formatting
```
Phone: (555) 123-4567
Date: January 15, 2025
Currency: $1,234.56
```

## Accessibility Copy

### Screen Reader Labels
```
<label for="email">Email address</label>
<input id="email" aria-describedby="email-hint">
<span id="email-hint">Example: name@company.com</span>
```

### Error Announcements
```
aria-live="polite" for non-critical errors
aria-live="assertive" for critical errors

"Error: Email is required"
"3 errors in form. First error: Name is required."
```

## Form Footer Copy

### Privacy/Terms
```
"By creating an account, you agree to our Terms of Service and Privacy Policy."
"We'll never share your information. See our Privacy Policy."
```

### Already Have Account
```
"Already have an account? Sign in"
"New here? Create an account"
```

### Help
```
"Need help? Contact support"
"Having trouble? Reset your password"
```

## Form Checklist

- [ ] Labels are clear and concise?
- [ ] Helper text explains requirements?
- [ ] Error messages are specific and helpful?
- [ ] Button copy describes the action?
- [ ] Required/optional fields are clear?
- [ ] Success state confirms the action?
- [ ] Privacy/terms are linked (if applicable)?
- [ ] Accessible to screen readers?

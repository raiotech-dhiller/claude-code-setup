# Error Message Writing

## Error Message Framework

### The 3-Part Formula
```
[What happened] + [Why] + [What to do]

Example:
"Couldn't upload photo. Files must be under 5MB. Try a smaller image."
```

### Minimum Viable Error
At minimum, every error should tell users:
1. Something went wrong
2. What to do about it

## Error Categories

### Validation Errors
User input doesn't meet requirements.

```
Field: Email
❌ Invalid email
✓ Enter a valid email address (e.g., name@company.com)

Field: Password
❌ Password too short
✓ Password must be at least 8 characters

Field: Phone
❌ Invalid format
✓ Enter a 10-digit phone number

Field: Required field
❌ This field is required
✓ Enter your [field name]
```

### Connection/System Errors
Something failed on the technical side.

```
❌ Error 500
✓ Something went wrong on our end. Try again in a few minutes.

❌ Network error
✓ Check your internet connection and try again.

❌ Request timeout
✓ This is taking longer than usual. Try again?
```

### Permission Errors
User doesn't have access.

```
❌ Access denied
✓ You don't have permission to view this. Contact your admin if you need access.

❌ Unauthorized
✓ Please sign in to continue.

❌ Session expired
✓ Your session expired. Sign in again to continue.
```

### Not Found Errors
Resource doesn't exist.

```
❌ 404 Not Found
✓ Page not found. It may have been moved or deleted.

❌ Resource not found
✓ This [project/file/item] no longer exists.
```

### Conflict Errors
Action can't be completed due to state.

```
❌ Conflict error
✓ Someone else is editing this document. Refresh to see their changes.

❌ Already exists
✓ An account with this email already exists. Sign in or use a different email.
```

## Tone Guidelines

### Don't Blame the User
```
❌ You entered an invalid password
✓ Wrong password. Try again or reset it.

❌ You don't have permission
✓ You need permission to view this.

❌ You made an error
✓ Something doesn't look right.
```

### Be Calm, Not Alarming
```
❌ CRITICAL ERROR: OPERATION FAILED!
✓ That didn't work. Let's try again.

❌ Fatal error occurred
✓ Something went wrong. We're looking into it.
```

### Skip the Jargon
```
❌ SQLException: duplicate key value
✓ This name is already taken. Try a different one.

❌ SSL_HANDSHAKE_FAILED
✓ Couldn't establish a secure connection. Check your network settings.

❌ CORS policy blocked
✓ Something went wrong. Try refreshing the page.
```

### Match Severity to Message
```
Low severity (recoverable):
"Couldn't save. Try again?"

Medium severity (needs action):
"Your subscription expired. Renew to keep your data."

High severity (serious):
"Your account will be permanently deleted in 7 days."
```

## Error Message Templates

### Form Validation
```
[Field name] is required
[Field name] must be [requirement]
Enter a valid [field name]
[Field name] must be between [min] and [max] [unit]
[Field name] can only contain [allowed characters]
```

### Authentication
```
Incorrect email or password. Try again or reset your password.
Your password has expired. Create a new one to continue.
Your account is locked. Contact support to unlock it.
Too many attempts. Try again in [time].
```

### File/Upload Errors
```
Couldn't upload [filename]. Try again.
[Filename] is too large. Maximum size is [X]MB.
[Filename] isn't a supported format. Use [formats].
Couldn't upload [X] files. [List failures].
```

### Payment Errors
```
Your card was declined. Check your card details or try a different card.
Your card has expired. Update your payment method.
Couldn't process payment. Try again or contact your bank.
```

### Connection Errors
```
Can't connect. Check your internet and try again.
The server isn't responding. Try again in a few minutes.
Connection lost. Reconnecting...
```

## Inline vs. Modal Errors

### Inline Errors (Field-Level)
Best for: Form validation, specific input issues
```
[Input field]
↓
"Enter a valid email address"
```

### Toast/Banner Errors
Best for: System errors, non-blocking issues
```
┌─────────────────────────────────────┐
│ ⚠️ Couldn't save. Try again.  [Retry] │
└─────────────────────────────────────┘
```

### Modal Errors
Best for: Critical errors, actions required before continuing
```
┌─────────────────────────────────────┐
│ Session Expired                      │
│                                      │
│ Your session has expired. Sign in    │
│ again to continue.                   │
│                                      │
│              [Sign in]               │
└─────────────────────────────────────┘
```

## Error Prevention Copy

### Confirmation Before Destructive Actions
```
Before:
[Delete project] (single click, no warning)

After:
[Delete project] →

"Delete 'Project Name'?
This will permanently delete all files and data.
This action can't be undone.

[Cancel] [Delete project]"
```

### Warning States
```
"You have unsaved changes"
"This email is already in use"
"You're about to remove all team members"
"This will affect 23 users"
```

### Constraints Shown Upfront
```
Password (8+ characters, 1 number)
File upload (Max 10MB, .jpg .png .pdf)
Username (letters and numbers only)
```

## Error Recovery Patterns

### Retry Option
```
"Couldn't save your changes. [Try again]"
"Upload failed. [Retry] or [Cancel]"
```

### Alternative Path
```
"Card declined. [Try a different card] or [Contact support]"
"Can't sign in? [Reset password] or [Contact support]"
```

### Undo Option
```
"Project deleted. [Undo]" (time-limited)
"Message archived. [Undo]"
```

### Help/Support Link
```
"Something went wrong. [Get help]"
"If this keeps happening, [contact support]."
```

## Testing Errors

### Checklist
- [ ] Is it clear what went wrong?
- [ ] Does it tell users what to do?
- [ ] Is it free of technical jargon?
- [ ] Is the tone appropriate (not blaming, not alarming)?
- [ ] Is there a recovery path?
- [ ] Does it appear at the right time/place?
- [ ] Is it accessible (screen readers, color contrast)?

# Empty States

## What Are Empty States?

Screens or components with no content to display yet. They're opportunities to guide, educate, and encourage users.

## Empty State Types

### First-Time / No Data Yet
User hasn't created anything in this area.
```
No projects yet
Create your first project to get started.
[Create project]
```

### No Results
Search or filter returned nothing.
```
No results for "xyz"
Try a different search term or adjust your filters.
[Clear filters]
```

### Cleared / Completed
User has addressed all items.
```
All caught up!
You've completed all your tasks for today.
```

### Error State
Content couldn't be loaded.
```
Couldn't load messages
Check your connection and try again.
[Retry]
```

### Permissions
User doesn't have access.
```
You don't have access to this project
Contact the owner to request access.
```

## Empty State Anatomy

```
┌─────────────────────────────────────────┐
│                                         │
│            [Illustration]               │
│              (optional)                 │
│                                         │
│         Primary Message                 │
│     Secondary explanation text          │
│                                         │
│            [Primary CTA]                │
│          Secondary action               │
│                                         │
└─────────────────────────────────────────┘
```

## Writing Framework

### 3-Part Structure
1. **What** - What this area is for / what's missing
2. **Why** - Why it's empty / what happened
3. **How** - How to add content / what to do next

### Formula
```
[Headline: State + Optional context]
[Body: Brief explanation]
[CTA: Clear action]
```

## First-Time Empty States

### Encouraging Tone
```
No projects yet
Projects help you organize your work. Create one to get started.
[Create your first project]

---

Your inbox is empty
When you receive messages, they'll appear here.
[Learn how messaging works]
```

### Educational Tone
```
No reports yet
Reports show your team's progress over time.
Once you complete a few tasks, you'll see insights here.

---

No integrations connected
Connect your tools to bring everything into one place.
[Browse integrations]
```

### With Value Proposition
```
No team members yet
Invite your team to collaborate on projects together.
[Invite team members]

Why invite your team?
• Real-time collaboration
• Shared visibility
• Faster feedback
```

## No Results States

### Search
```
No results for "[search term]"
Try:
• Checking for typos
• Using fewer or different keywords
• Removing filters
[Clear search]

---

No projects match your search
We couldn't find any projects with "[term]".
[Clear search] [Browse all projects]
```

### Filtered Views
```
No tasks match these filters
Adjust or clear your filters to see more tasks.
[Clear filters]

---

No items in this category
This category is empty. View all items or try another category.
[View all] [Browse categories]
```

### With Suggestions
```
No results for "projet" (possible typo)
Did you mean "project"?
[Search for "project"]

---

No results for "Q4 report"
Try searching for:
• "quarterly report"
• "Q4 2024"
• "reports"
```

## Completed/Cleared States

### Celebratory
```
🎉 All done!
You've completed all your tasks. Nice work!
[Add a new task]

---

Inbox zero!
You've responded to all your messages.
```

### Informational
```
No notifications
You're all caught up. New notifications will appear here.

---

No pending approvals
When items need your approval, they'll show up here.
```

### With Next Step
```
No upcoming meetings
Your calendar is clear for today.
[Schedule a meeting]

---

All tasks complete
Looking for something to do?
[View completed tasks] [Create new task]
```

## Error Empty States

### Connection Issues
```
Couldn't load your projects
Check your internet connection and try again.
[Retry] [Go offline]

---

Something went wrong
We're having trouble loading this page.
[Try again] [Contact support]
```

### Content Not Found
```
This project doesn't exist
It may have been deleted or you might not have access.
[Go to projects]

---

Page not found
We can't find what you're looking for.
[Go home] [Contact support]
```

## Permission Empty States

### No Access
```
You don't have access to this project
Contact [Owner Name] to request access.
[Request access]

---

This content is private
You need to be a team member to view this.
[Request to join]
```

### Upgrade Required
```
Unlock reports with Pro
Upgrade to see insights about your team's performance.
[Upgrade to Pro] [Learn more]
```

## Component-Level Empty States

### Tables
```
┌─────────────────────────────────────────┐
│ Name       │ Status    │ Date          │
├─────────────────────────────────────────┤
│                                         │
│         No data to display              │
│                                         │
└─────────────────────────────────────────┘
```

### Lists
```
Notifications
─────────────
No notifications yet
When something needs your attention, it'll show up here.
```

### Cards/Grids
```
Your projects

┌─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─┐
│                                       │
│    + Create your first project        │
│                                       │
└─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─┘
```

### Dashboards/Charts
```
Activity this week

    No activity yet
    
    Complete tasks to see
    your activity here.
```

## Empty State Copy Patterns

### By Feature Area
| Area | Empty State Message |
|------|---------------------|
| Inbox | No messages yet. Start a conversation? |
| Tasks | No tasks. Add one to get started. |
| Calendar | Nothing scheduled today. |
| Files | No files uploaded yet. |
| Team | No team members. Invite someone? |
| Comments | No comments yet. Start the discussion. |
| Favorites | No favorites. Star items to find them here. |
| Recent | No recent activity. |
| Search | No results found. Try different keywords. |

## Empty State Checklist

- [ ] Is it clear what this area is for?
- [ ] Does it explain why it's empty?
- [ ] Is there a clear action to take?
- [ ] Is the tone appropriate (not too cute, not too dry)?
- [ ] Does the CTA match the user's likely goal?
- [ ] Is an illustration/icon needed or distracting?
- [ ] Does it degrade gracefully on small screens?

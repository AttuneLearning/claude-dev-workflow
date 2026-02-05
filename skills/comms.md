---
name: comms
description: Manage inter-team communication, issues, and coordination
argument-hint: "[check|send|issue|status|move|archive]"
---

# Dev Communication Skill

Manage inter-team communication, issues, and coordination.

## Usage

```
/comms [action] [options]
```

## Actions

Based on the user's request or argument, perform one of these actions:

---

### 1. CHECK (default if no action specified)

Check inbox, pending issues, and team status.

**Trigger:** `/comms`, `/comms check`, "check messages", "any updates?"

**Steps:**
1. Read `dev_communication/coordination/{team}-team-status.md`
2. List files in `dev_communication/messaging/{other-team}-to-{team}/` (inbox)
3. List files in `dev_communication/issues/{team}/queue/`
4. List files in `dev_communication/issues/{team}/active/`
5. Check `dev_communication/coordination/dependencies.md` for blockers

**Output format:**
```
## Comms Status

### Inbox ({other-team}-to-{team}/)
- [filename] - [first line/subject]
- (or "No pending messages")

### Issue Queue ({team}/queue/)
- [ISS-xxx] - [title]
- (or "No pending issues")

### Active Issues ({team}/active/)
- [ISS-xxx] - [title] - [status]
- (or "No active issues")

### Blockers
- [any from dependencies.md]
- (or "No blockers")
```

---

### 2. SEND

Send a message to the other team.

**Trigger:** `/comms send`, "send message to {team}", "notify {team} team"

**Steps:**
1. Ask for message type: Request or Response
2. Ask for priority: Critical, High, Medium, Low
3. Ask for subject
4. Ask for content (or let user provide)
5. Use template from `dev_communication/messaging/templates/`
6. Generate filename: `YYYY-MM-DD_{team}_{subject_slug}.md`
7. Save to `dev_communication/messaging/{team}-to-{other-team}/`
8. Confirm sent

**If responding to a message:**
1. Ask which message this responds to
2. Use response template
3. Include `In-Response-To:` field
4. Optionally move original + response to `archive/`

---

### 3. ISSUE

Create a new issue.

**Trigger:** `/comms issue`, "create issue", "new {team} issue"

**Steps:**
1. Read `dev_communication/issues/index.md` to get next issue number
2. Ask for: title, priority, description, requirements
3. Use template from `dev_communication/issues/templates/issue-template.md`
4. Generate filename: `{TEAM}-ISS-{NNN}_{title_slug}.md`
5. Save to `dev_communication/issues/{team}/queue/`
6. Update issue number in `dev_communication/issues/index.md`
7. Confirm created

**For cross-team issues:**
1. Also create in other team's queue if their work needed
2. Link with `Related:` field
3. Update `dev_communication/coordination/dependencies.md`
4. Send notification message

---

### 4. STATUS

Update team status.

**Trigger:** `/comms status`, "update status", "set focus"

**Steps:**
1. Read current `dev_communication/coordination/{team}-team-status.md`
2. Ask what to update:
   - Current focus
   - Active issues
   - Blockers
   - Notes
3. Update the file with new information
4. Update timestamp and "Updated By"
5. Confirm updated

---

### 5. MOVE

Move an issue through lifecycle.

**Trigger:** `/comms move ISS-xxx`, "move issue to active", "complete ISS-xxx"

**Steps:**
1. Find the issue file
2. Ask target status: queue, active, completed
3. Move file to appropriate folder
4. Update status field in the issue
5. If completing:
   - Ask for completion notes
   - Update completion section
   - If cross-team, ask if response message needed
6. Confirm moved

---

### 6. ARCHIVE

Archive completed message threads.

**Trigger:** `/comms archive`, "archive messages"

**Steps:**
1. List messages in outbox and inbox
2. Ask which thread to archive (or auto-detect completed)
3. Create folder: `archive/YYYY-MM-DD_{thread_subject}/`
4. Move related messages to archive folder
5. Confirm archived

---

## File Locations

```
dev_communication/
├── messaging/
│   ├── api-to-ui/      # API outbox / UI inbox
│   ├── ui-to-api/      # UI outbox / API inbox
│   ├── archive/
│   └── templates/
├── issues/
│   ├── api/{queue,active,completed}/
│   ├── ui/{queue,active,completed}/
│   └── templates/
└── coordination/
    ├── api-team-status.md
    ├── ui-team-status.md
    └── dependencies.md
```

## Team Context

Determine team from project context (check CLAUDE.md or project name):
- API project: team=api, other-team=ui
- UI project: team=ui, other-team=api

## Auto-Suggestions

After completing work, suggest:
- "This affects {other-team} team. Send a notification? (`/comms send`)"
- "Issue complete. Move to completed? (`/comms move`)"
- "New requirement discovered. Create issue? (`/comms issue`)"

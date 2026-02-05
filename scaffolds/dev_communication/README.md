# Dev Communication Hub

Inter-team communication and coordination hub.

## Structure

```
dev_communication/
├── messaging/           # Cross-team messages
│   ├── api-to-ui/       # API team outbox
│   ├── ui-to-api/       # UI team outbox (API inbox)
│   ├── archive/         # Completed threads
│   └── templates/       # Message templates
├── issues/              # Issue tracking
│   ├── api/             # API team issues
│   │   ├── queue/       # Not started
│   │   ├── active/      # In progress
│   │   └── completed/   # Done
│   ├── ui/              # UI team issues
│   │   ├── queue/
│   │   ├── active/
│   │   └── completed/
│   └── templates/
├── architecture/        # ADRs and decisions
│   ├── decisions/       # ADR files
│   ├── suggestions/     # Pending suggestions
│   ├── gaps/            # Known gaps
│   └── templates/
├── coordination/        # Team status and dependencies
├── guidance/            # Development guidelines
├── specs/               # Feature specifications
└── plans/               # Planning documents
```

## Skills

- `/comms` - Check inbox, send messages, manage issues
- `/adr` - Manage architecture decisions

## Setup

This directory should be shared between API and UI projects via symlink:

```bash
# In UI project
ln -s ../cadencelms_api/dev_communication dev_communication
```

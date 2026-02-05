# Claude Dev Workflow - Setup Guide

Complete guide to setting up the Claude Code development workflow in a new project.

## Quick Start

```bash
# 1. Add submodule to your project
git submodule add https://github.com/yourusername/claude-dev-workflow.git .claude-workflow

# 2. Run setup script (or follow manual steps below)
./.claude-workflow/setup.sh
```

## Manual Setup

### Step 1: Add the Submodule

```bash
cd your-project
git submodule add https://github.com/yourusername/claude-dev-workflow.git .claude-workflow
```

### Step 2: Create Project Directories

#### Option A: Shared dev_communication (recommended for multi-project)

If you have multiple projects (e.g., API + UI) that share communication:

```bash
# In your first project (e.g., API)
cp -r .claude-workflow/scaffolds/dev_communication ./dev_communication

# In your second project (e.g., UI)
ln -s ../first-project/dev_communication ./dev_communication
```

#### Option B: Project-specific dev_communication

```bash
cp -r .claude-workflow/scaffolds/dev_communication ./dev_communication
```

#### Memory Vault (always project-specific)

```bash
cp -r .claude-workflow/scaffolds/memory ./memory
```

### Step 3: Set Up Skills

Create symlinks from your project's `.claude/commands/` to the submodule skills:

```bash
mkdir -p .claude/commands

# Core skills
ln -sf ../../.claude-workflow/skills/comms.md .claude/commands/comms.md
ln -sf ../../.claude-workflow/skills/adr.md .claude/commands/adr.md
ln -sf ../../.claude-workflow/skills/memory.md .claude/commands/memory.md
ln -sf ../../.claude-workflow/skills/recall.md .claude/commands/recall.md

# Workflow skills
ln -sf ../../.claude-workflow/skills/context.skill.md .claude/commands/context.md
ln -sf ../../.claude-workflow/skills/reflect.skill.md .claude/commands/reflect.md
ln -sf ../../.claude-workflow/skills/refine.skill.md .claude/commands/refine.md
```

### Step 4: Configure Permissions

Update `.claude/settings.json`:

```json
{
  "permissions": {
    "additionalDirectories": [
      "../claude-dev-workflow"
    ]
  }
}
```

### Step 5: Update CLAUDE.md

Add to your project's `CLAUDE.md`:

```markdown
## Development Workflow

**Submodule:** `.claude-workflow/`

### Skills Available
- `/comms` - Inter-team communication
- `/adr` - Architecture decisions
- `/memory` - Memory vault management
- `/recall` - Quick context loading
- `/context` - Pre-implementation context
- `/reflect` - Post-implementation reflection
- `/refine` - Pattern refinement

### Directories
- `dev_communication/` - Inter-team hub
- `memory/` - Extended memory vault
```

### Step 6: Initialize Content

#### Set Up Team Status

Edit `dev_communication/coordination/{team}-team-status.md`:
- Set your team name
- Add current focus
- List any active issues

#### Create Initial Context

Create `memory/context/project-overview.md`:
```markdown
---
title: Project Overview
created: YYYY-MM-DD
tags: [context, overview]
---

# Project Overview

## What is this project?
{Description}

## Key Technologies
{List}

## Architecture
{Brief overview}
```

Create `memory/context/tech-stack.md`:
```markdown
---
title: Tech Stack
created: YYYY-MM-DD
tags: [context, tech]
---

# Tech Stack

## Backend
- {Technology}: {Version}

## Frontend
- {Technology}: {Version}

## Database
- {Technology}

## Infrastructure
- {Services}
```

## Directory Structure After Setup

```
your-project/
├── .claude/
│   ├── commands/           # Symlinks to skills
│   │   ├── comms.md -> ../../.claude-workflow/skills/comms.md
│   │   ├── adr.md -> ...
│   │   └── ...
│   └── settings.json
├── .claude-workflow/       # Git submodule
│   ├── skills/
│   ├── patterns/
│   ├── indexes/
│   ├── hooks/
│   ├── templates/
│   └── scaffolds/
├── dev_communication/      # Copied from scaffold (or symlinked)
│   ├── messaging/
│   ├── issues/
│   ├── architecture/
│   └── coordination/
├── memory/                 # Copied from scaffold
│   ├── context/
│   ├── entities/
│   ├── patterns/
│   └── sessions/
└── CLAUDE.md
```

## Multi-Project Setup

For projects that share communication (e.g., API + UI):

```
parent-directory/
├── api-project/
│   ├── .claude-workflow/     # Submodule
│   ├── dev_communication/    # Original copy
│   └── memory/               # API-specific
├── ui-project/
│   ├── .claude-workflow/     # Submodule
│   ├── dev_communication -> ../api-project/dev_communication
│   └── memory/               # UI-specific
└── claude-dev-workflow/      # Can also be standalone for development
```

## Updating the Submodule

```bash
# Pull latest changes
cd .claude-workflow
git pull origin master
cd ..
git add .claude-workflow
git commit -m "Update claude-dev-workflow submodule"
```

## Customization

### Project-Specific Patterns

Add patterns specific to your project in `.claude-workflow/patterns/active/`:
- They'll be available to all projects using the submodule
- Or keep project-specific patterns in `memory/patterns/`

### Team Configuration

Edit skill behavior by modifying the symlinked skills or creating project-specific overrides in `.claude/commands/`.

## Troubleshooting

### Skills not found
- Check symlinks exist: `ls -la .claude/commands/`
- Verify submodule initialized: `git submodule status`

### Permission denied on submodule
- Check `.claude/settings.json` includes `additionalDirectories`

### Submodule empty after clone
```bash
git submodule init
git submodule update
```

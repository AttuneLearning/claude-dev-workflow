---
name: develop
description: Mandatory development lifecycle - processes issues with full verification
argument-hint: "[issue-id|all|quick <file>|team <issue-id>|team all]"
---

# Development Lifecycle Skill

Enforces the mandatory development lifecycle per ADR-DEV-002.

## Usage

```
/develop                    # Process next issue in queue
/develop API-ISS-022        # Process specific issue
/develop all                # Process all issues in queue
/develop quick <file>       # Quick mode for trivial changes
/develop team <issue-id>    # Process with agent team (parallel)
```

## Team Detection

- Path contains `/cadencelms_ui/` → `team=ui`
- Path contains `/cadencelms_api/` → `team=api`
- Inbox: `dev_communication/messaging/*-to-{team}/`
- Outbox: `dev_communication/messaging/{team}-to-*/`
- Issues: `dev_communication/issues/{team}/`

---

## Phase 0: Message Polling & Unblocking

**Run BEFORE and BETWEEN issues.** Poll inbox for new messages, match responses to blocked issues.

**Steps:**
1. List files in inbox directory, track last-activity timestamp
2. For each message: check if RESPONSE type (`In-Response-To:` field)
3. Match responses to BLOCKED issues in `issues/{team}/active/`
4. If match: update issue status BLOCKED → IN PROGRESS, reset timer
5. Report: new messages, unblocked issues, still-blocked issues

**Termination:** Issue completed | 20 min inactivity | All issues done | User interrupt

---

## Phase 1: Context Loading

1. Check `/comms` for relevant messages (done in Phase 0)
2. Load relevant patterns from `memory/patterns/`
3. Identify applicable ADRs:
   - New endpoint → ADR-API-001, ADR-DEV-001
   - Auth changes → ADR-AUTH-001
   - Any change → ADR-DEV-001 (testing)
4. Read and extract issue acceptance criteria

---

## Phase 2: Implementation

1. Create plan if complex (break into subtasks, identify files)
2. Write code following patterns and ADRs
3. Update TypeScript types as needed

### Team Mode (Phase 2T)

When invoked with `team` keyword, Phase 2 uses parallel agent execution.

**Config:** `.claude-workflow/team-configs/agent-team-roles.json`

1. Lead creates task plan with dependencies, assigns file ownership (no overlaps)
2. Spawn teammates (Sonnet 4.5, max 3): Implementer, Tester, Researcher (optional)
3. Enable delegate mode — lead coordinates only
4. Mid-dev review at: 50% tasks done, teammate blocked 2+ times, or 30 min elapsed
5. Lead reviews, shuts down teammates, proceeds to Phase 3

**Fallback:** If teammate blocked 3+ times by hooks, lead takes over.

---

## Phase 3: Verification (MANDATORY - BLOCKING)

**Cannot proceed without ALL checks passing.**

```bash
npx tsc --noEmit                    # 0 errors required
npx jest tests/unit/{changed}       # Unit tests
npm run test:integration             # Integration tests
```

On failure: fix immediately, re-run. Do not proceed.

---

## Phase 4: Documentation

1. Update `/memory` if new pattern discovered
2. `/adr suggest` if architectural decision made
3. `/comms send` if cross-team impact
4. Update issue with implementation notes
5. If agent team used: write `## Team Review` in session file, promote effective configs to `memory/team-configs/`

---

## Phase 5: Completion

1. Verify ALL acceptance criteria met
2. Move issue: `/comms move {issue_id} completed`
3. Store session summary: `memory/sessions/{date}-{issue-slug}.md`

---

## Quick Mode

For trivial changes (typos, comments, single-line fixes):

**Skips:** Integration tests, memory update, ADR suggestion
**Still requires:** Type check (must pass), unit tests (if test file exists)

---

## Error Handling

| Error | Action |
|-------|--------|
| Type error | Fix immediately, do not proceed |
| Test failure | Fix code or test, re-run |
| Regression | Investigate root cause, add regression test |

## Test Requirements by Change Type

| Change Type | Required Tests |
|-------------|----------------|
| Bug fix | Regression test proving fix |
| New endpoint | Integration test |
| New feature | Integration + happy path |
| Refactor | Existing tests must pass |

## References

- **ADR:** `dev_communication/architecture/decisions/ADR-DEV-002-DEVELOPMENT-LIFECYCLE.md`
- **Testing:** `dev_communication/architecture/decisions/ADR-DEV-001-TESTING-STRATEGY.md`
- **Agent Teams:** `.claude-workflow/team-configs/agent-team-roles.json`
- **Learned Configs:** `memory/team-configs/`

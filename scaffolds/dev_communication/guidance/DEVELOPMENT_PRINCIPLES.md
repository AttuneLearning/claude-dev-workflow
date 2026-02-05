# Development Principles

Core principles that guide all development work.

## 1. Ideal Design First (I1)

Unless otherwise specified, always design for the ideal API/route structure.

- No backward compatibility layers unless explicitly requested
- No deprecated fields or legacy fallbacks
- Clean over compatible
- Update callers rather than adding compatibility layers

## 2. Contract First (CF1)

All development is contract-first.

- Define the API contract/interface before implementation
- Both UI and API teams develop against agreed contracts
- No implementation begins without a documented contract
- Post contracts to `dev_communication/messaging/` for cross-team agreement

## 3. Naming Conventions (N1)

Use specific, non-colliding names.

- Check for existing names before creating new components/files
- Use specific prefixes when concepts could collide
- Search codebase before naming: `grep -r "ComponentName" src/`

## 4. Golden Rule

Never invent API values.

- Always verify endpoint paths exist before using them
- Always verify field names exist before using them
- Always verify permission strings exist before using them
- When uncertain, ask or check contracts

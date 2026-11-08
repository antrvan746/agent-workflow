---
name: wf-review-backend
description: Backend, API and data review checklist. Use when a task touches APIs, services, databases or background jobs, or when reviewing backend code.
---

# Backend checklist

Mark each item Pass / Fail (with file:line) / n/a. **[B]** = blocker.

## API contract
- [B] Input validated at the boundary (schema); structured errors with correct status codes (400/401/403/404/409/422/500).
- Consistent responses (field names, time format, pagination); changes do not break existing clients (or are versioned).
- New/changed endpoints have contract tests (status, response shape, validation errors) and updated OpenAPI/API docs if the project has them.
- Idempotency for retryable operations (payments, webhooks).

## Data
- [B] Migrations are re-runnable/reversible, lose no data, add indexes for new queries.
- Transactions cover the right scope; no races on concurrent updates (locks / optimistic versioning).
- No N+1 queries; list queries are always bounded/paginated.

## Reliability
- [B] Errors are not swallowed: logged with context, without secrets or PII.
- Timeouts and bounded retries for outbound calls; behavior defined when dependencies are slow or down.
- Config via environment with safe defaults; fail fast when required config is missing.

## Tests
- Main path + main failures (bad input, unauthorized, not found, conflict).
- Integration tests against a real (or equivalent) database for important queries.

Also apply `wf-review-security`.

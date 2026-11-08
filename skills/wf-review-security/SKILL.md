---
name: wf-review-security
description: Security review checklist. Use when a task touches authentication, authorization, user input, secrets, file upload or new dependencies, or when reviewing risky changes.
---

# Security checklist

Every failed item is a **blocker** unless the accepted risk is written down with a reason.

## Input and output
- All external input is validated (type, length, format) on the server, not only on the client.
- No string concatenation into SQL/shell/HTML: parameterized queries, escaping, no `eval` or raw HTML injection with user data.
- Regexes built from user input are escaped (avoid ReDoS / syntax errors).
- Uploads: size limits, type checks, never served back from an executable path.

## Authentication and authorization
- Every endpoint checks permissions server-side (never trust client IDs/roles); resource ownership checked (IDOR).
- Sessions/tokens expire; cookies `HttpOnly`/`Secure`/`SameSite`; CSRF protection with cookie auth.
- Passwords hashed with a slow algorithm (bcrypt/argon2); no home-made crypto.

## Secrets and data
- No secrets in the repo; use environment variables; `.env` is ignored.
- No tokens, passwords or PII in logs; error messages do not leak stack traces or internals to clients.
- No sensitive data in URLs/query strings.

## Dependencies and configuration
- New dependencies are popular, maintained, version-pinned; run `npm audit` (or equivalent) and report the result.
- Basic security headers (CSP, HSTS, X-Content-Type-Options) for web apps with a backend.
- CORS open only to required origins.

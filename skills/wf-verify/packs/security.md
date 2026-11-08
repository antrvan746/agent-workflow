# Pack: security
Checks are `must` by default: a failure is a blocker unless the accepted risk is written down with a reason and the
user's ✅ (wf-verify step 4).
Stack-specific commands in `Verify` are examples; use the project's equivalent.

### SEC-INPUT [must]
When: code reads external input (HTTP, CLI args, files, queues, env from users)
Claim: input is validated (type, length, format) on the trusted side, not only on the client.
Verify: test with invalid, oversized and malformed input → rejected with a clear error.
Evidence: test names

### SEC-INJECTION [must]
When: input reaches SQL, shell, HTML, templates, eval or regexes
Claim: no string concatenation into interpreters; parameterized queries, escaping, regexes built from input are escaped.
Verify: test with metacharacters (`' OR 1=1 --`, `; rm`, `<script>`, `.*(`) → treated as data.
Evidence: test names or grep of the call sites

### SEC-UPLOAD [must]
When: file upload or user-supplied paths
Claim: size limits, type checks, no path traversal, never served from an executable location.
Verify: upload oversized / wrong-type / `../` file → rejected.
Evidence: test names

### SEC-AUTHZ [must]
When: endpoints, handlers or jobs acting on user-owned resources
Claim: permissions and ownership are checked server-side; client-sent IDs or roles are never trusted (IDOR).
Verify: call as user B on user A's resource → 403/404; call unauthenticated → 401.
Evidence: test names

### SEC-SESSION [must]
When: authentication, sessions, tokens, cookies or passwords change
Claim: tokens expire; cookies `HttpOnly`/`Secure`/`SameSite`; CSRF protection with cookie auth; passwords hashed with a
slow algorithm; no home-made crypto.
Verify: inspect config + a test for expiry/CSRF.
Evidence: config `file:line`, test names

### SEC-SECRETS [must]
When: config, logging, error handling or new credentials
Claim: no secrets in the repo (`.env` is git-ignored); no tokens, passwords or PII in logs, URLs, query strings or
client-facing errors.
Verify: grep the diff for keys/tokens; `git check-ignore .env`; trigger an error → response has no stack trace or internals.
Evidence: grep result, response sample

### SEC-DEPS [must]
When: a dependency is added or upgraded
Claim: maintained, version-pinned, no known high/critical vulnerabilities.
Verify: the ecosystem's audit (`npm audit`, `pip-audit`, `cargo audit`…).
Evidence: audit output

### SEC-WEB-CONFIG [should]
When: a web app with a backend changes headers, CORS or hosting config
Claim: basic security headers (CSP, HSTS, X-Content-Type-Options); CORS limited to required origins.
Verify: inspect response headers of a running instance.
Evidence: headers

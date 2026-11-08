# Pack: backend
APIs, services, databases, background jobs. Stack-specific commands in `Verify` are examples.
Apply the `security` pack too when input, auth or data exposure is touched.

### BE-VALIDATION [must]
When: endpoints or handlers are added or changed
Claim: input is validated at the boundary with a schema; errors are structured with correct status codes
(400/401/403/404/409/422/500).
Verify: contract tests for bad input, unauthorized, not found, conflict.
Evidence: test names

### BE-CONTRACT [should]
When: response shapes, fields or endpoints change
Claim: consistent naming, time format and pagination; existing clients keep working (or the change is versioned);
API docs/OpenAPI updated if the project has them.
Verify: contract tests on status + response shape; diff of the API docs.
Evidence: test names, docs diff

### BE-IDEMPOTENT [should]
When: retryable operations (payments, webhooks, queue consumers)
Claim: repeating the same request has the effect of one.
Verify: send the same request/event twice → one side effect.
Evidence: test name

### BE-MIGRATION [must]
When: schema or data migrations
Claim: re-runnable/reversible, no data loss, indexes for new queries.
Verify: migrate up → down → up on a copy with data.
Evidence: command output

### BE-CONCURRENCY [should]
When: concurrent updates to the same rows or resources
Claim: transactions cover the right scope; no lost updates (locks or optimistic versioning).
Verify: parallel-update test.
Evidence: test name

### BE-QUERIES [should]
When: new or changed queries, list endpoints
Claim: no N+1; lists are bounded/paginated.
Verify: query log or count in a test with several rows.
Evidence: query count

### BE-ERRORS [must]
When: error handling or outbound calls change
Claim: errors are not swallowed; logged with context and without secrets/PII.
Verify: trigger a failure → logged once with context; client gets a structured error.
Evidence: log sample, test name

### BE-RESILIENCE [should]
When: calls to other services or slow dependencies
Claim: timeouts and bounded retries; defined behavior when the dependency is slow or down.
Verify: test with the dependency stubbed to fail/time out.
Evidence: test name

### BE-CONFIG [should]
When: new configuration
Claim: config via environment with safe defaults; fail fast when required config is missing.
Verify: start without the variable → clear startup error.
Evidence: output

### BE-INTEGRATION [should]
When: important queries or persistence logic
Claim: tested against a real (or equivalent) database, not only mocks.
Verify: integration test run.
Evidence: command output

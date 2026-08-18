# Evidence and maintenance index

Use this file to refresh the skill without turning a transient machine snapshot into permanent guidance.

## Stable primary sources

### Exa

- <https://exa.ai/docs/reference/exa-mcp>
- <https://exa.ai/docs/reference/search>
- <https://github.com/exa-labs/exa-mcp-server>

### Firecrawl

- <https://docs.firecrawl.dev/mcp-server>
- <https://docs.firecrawl.dev/mcp-server/tools>
- <https://docs.firecrawl.dev/ai-onboarding>
- <https://github.com/firecrawl/firecrawl-mcp-server>

## Refresh procedure

1. Run `scripts/doctor.sh` and keep its redacted output only as working evidence.
2. Inspect the current agent tool registry. Registration, authentication, exposure, and health are separate checks.
3. Use each healthy provider to find its own official documentation and repository.
4. Cross-fetch the Exa documentation with Firecrawl and the Firecrawl documentation with Exa when both are healthy.
5. Compare the live tool schemas with the provider references. Update routing, auth, freshness, and side-effect boundaries rather than copying the entire schema.
6. Run small read-only smoke calls for discovery and known-page retrieval.
7. Run `scripts/check.sh --runtime` and inspect the diff for secrets before committing.

Do not commit raw result payloads, dynamic scrape or run IDs, account metadata, headers, tokens, cookies, private URLs, or fixed statements about one machine's current health. Store durable official URLs and procedures; generate volatile status at runtime.

## Evidence record

For material research claims, working notes should capture:

```text
provider: exa | firecrawl | native-if-exposed
tool: exact runtime tool name
query_or_url: redacted when private
filters: domains, dates, freshness, result/page bounds
canonical_url: source page, not result wrapper
retrieved_at: ISO 8601 with timezone
result: success | partial | failed
limitations: cache, truncation, auth, quota, disagreement
```

The final answer should cite canonical URLs and relevant retrieval dates. Tool names and failure notes are useful when they explain confidence or limitations; avoid dumping internal traces.

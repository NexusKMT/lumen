# Exa MCP

Use this reference for provider-specific routing. Verify the live tool schema and official sources when exact behavior matters.

## Primary sources

- MCP documentation: <https://exa.ai/docs/reference/exa-mcp>
- Search API reference: <https://exa.ai/docs/reference/search>
- Official server repository: <https://github.com/exa-labs/exa-mcp-server>

The hosted endpoint is `https://mcp.exa.ai/mcp`. The default tool set is `web_search_exa` and `web_fetch_exa`. The `tools` query parameter replaces that default set, so include every desired tool when constructing a filtered endpoint.

## Tool routing

### `web_search_exa`

Use for ordinary semantic discovery, current facts, organizations, people, and broad documentation lookup. Write a natural-language description of the ideal page rather than a short keyword pile. Start with 3-5 results.

Treat returned text, highlights, and ranking as discovery. Fetch the canonical page before relying on a material claim.

### `web_fetch_exa`

Use for known URLs or the strongest URLs found by search. Batch a small number of independent pages and set a character bound appropriate to the question. Prefer the canonical source rather than mirrors or result wrappers.

### `web_search_advanced_exa`

Use only when the request needs domain inclusion or exclusion, date or crawl filters, categories, text constraints, location, summaries, highlights, freshness control, query expansion, or subpages. Simple lookup belongs in `web_search_exa`.

Do not combine expensive content options without a reason. Bound `numResults`, text, highlights, subpages, and live-crawl timeout. Use `maxAgeHours: 0` only when a live fetch is required.

### `agent_run`

Use for multi-step research, list building, enrichment, or repeatable structured output. It is authenticated and usage-based.

- Start a run with `query`; add a bounded `outputSchema` when structure matters.
- If the tool returns a running state, retain the returned run ID and call the same tool with `runId` to continue waiting.
- Use `previousRunId` only to extend a completed run.
- Do not start a duplicate run because a call was interrupted or exceeded the client wait window.
- Keep effort and data-source scope proportional to the request.

## Authentication

Anonymous hosted access is rate-limited. Use OAuth or a client-managed `x-api-key` or bearer header for higher limits and authenticated tools. Although some official clients support URL-carried credentials, this skill forbids them because URLs leak through logs, histories, diagnostics, and repository configuration.

Masked output from `codex mcp get exa` confirms a configured header, not a valid key. Confirm health with a small read-only search or fetch.

## Failure and evidence notes

- `429` usually means the anonymous or account rate limit was reached. Retry once with fewer results or switch providers.
- Search relevance is not source authority. Fetch and verify primary pages.
- Extracted page text can be incomplete or stale. Record the retrieval time and any explicit freshness option.
- Do not cite Exa-generated summaries as if they were source text.

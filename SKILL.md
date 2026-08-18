---
name: lumen
description: Discover, retrieve, verify, and cite current web evidence through available retrieval tools such as Exa and Firecrawl. Use for web research, documentation lookup, current-fact verification, URL, page, or file extraction, developer-source search, literature research, site discovery or crawling, provider selection, retrieval-stack diagnosis, and maintenance. Inventory runtime registration, authentication, exposed tools, and call health instead of trusting a dated snapshot.
---

# Lumen

Use the smallest available tool that can produce inspectable source evidence. Treat bundled provider notes as routing guidance, not proof of current installation or service health.

## Establish runtime truth

Distinguish four states before diagnosing or describing the search stack:

1. **Registered**: `codex mcp list` or `codex mcp get NAME` shows a configured server.
2. **Authenticated**: the connection has an accepted OAuth session or secret header. A masked header proves configuration, not validity.
3. **Exposed**: the current agent tool registry includes the expected tool name and schema.
4. **Healthy**: a bounded, read-only call succeeds now.

One state does not imply the next. Run `scripts/doctor.sh` for a redacted registration snapshot when setup, auth, missing tools, or provider availability matters. Inspect the current tool schema before calling it; server capabilities change faster than this skill.

Read the relevant provider reference before use:

- `references/exa.md` for Exa search, fetch, advanced search, and Agent.
- `references/firecrawl.md` for Firecrawl search, scrape, parse, developer, research, map, crawl, Agent, interact, and monitor boundaries.
- `references/evidence-index.md` when refreshing or auditing this skill.

## Route the task

| Need | Preferred tool | Reason |
| --- | --- | --- |
| General semantic discovery or current web lookup | Exa `web_search_exa` | Fast, concise discovery from a natural-language description of the ideal page |
| Known URL, clean readable text | Exa `web_fetch_exa` | Batches bounded reads of known pages |
| Domain, date, category, freshness, highlight, or subpage filters | Exa `web_search_advanced_exa` | Explicit search controls |
| Multi-step research, enrichment, or schema-bound list building | Exa `agent_run` | Retained run state and structured output; authenticated and usage-based |
| General web, news, image, or category search | Firecrawl `firecrawl_search` | Search with source filters and optional extraction |
| One known web page or schema-shaped fields | Firecrawl `firecrawl_scrape` | JavaScript rendering and focused markdown, JSON, screenshot, or other formats |
| Programming question over docs, issues, pull requests, or repositories | Firecrawl `firecrawl_developer_search` | Dedicated developer index |
| Local file or hosted upload reference | Firecrawl `firecrawl_parse` | File parsing rather than URL scraping |
| Discover URLs under one site | Firecrawl `firecrawl_map` | Enumerates URLs without retrieving every page |
| Retrieve a bounded site section | Firecrawl `firecrawl_crawl` | Multi-page collection; always set strict limits |
| Papers, citation expansion, passages, or indexed GitHub research | Firecrawl `firecrawl_research_*` | Dedicated research indexes, distinct from ordinary web search |
| Complex multi-source research | Firecrawl `firecrawl_agent` plus status | Asynchronous research with explicit scope and cost |
| Browser interaction or recurring monitors | Firecrawl interact/monitor tools | Potentially state-changing; require explicit user authorization |

Use a native web-search tool for an independent cross-check only when it is actually exposed in the current registry. Never assume its presence.

## Produce evidence

1. Translate the request into a precise query and identify the likely primary authority.
2. Search to discover candidates; do not treat rankings, snippets, summaries, or generated highlights as proof.
3. Fetch or scrape the best canonical primary pages. Prefer official documentation, standards, repositories, filings, or direct statements.
4. Cross-check material claims with an independent provider or a second primary source. Independence matters more than repeating the same result through two wrappers.
5. Record the provider, tool, query or URL, important filters, freshness or cache choice, canonical URL, and retrieval time in working notes.
6. Cite the source page URL, not a search-result wrapper. State provider failures, stale-cache risk, truncation, or unresolved disagreement.

## Bound calls

- Read the live schema and send only supported fields.
- Start with 3-5 search results and one or two page reads. Expand only when coverage is inadequate.
- Set explicit character, page, crawl, subpage, result, and parallelism limits.
- Prefer Firecrawl schema-shaped JSON for targeted fields; request full markdown only when the task needs the page narrative.
- Use live-fetch options only when freshness is material. Do not pay the latency and quota cost by default.
- Parallelize independent searches or reads. Preserve run IDs for asynchronous or retained Agent calls instead of starting duplicates.
- Never place credentials, private URLs, personal data, proprietary text, cookies, or session material in a search query.

## Handle failures

| Signal | Interpretation | Response |
| --- | --- | --- |
| Missing tool | Not exposed in this session | Refresh inventory, inspect server configuration, then restart the client if configuration changed |
| Schema or invalid-argument error | Client assumptions are stale | Re-read the live tool schema and retry once with the smallest valid request |
| `401` or `403` | Authentication or authorization failure | Stop retries; report which auth layer failed without printing credentials |
| `402` | Balance, plan, or quota unavailable | Mark the provider unavailable and route to another healthy provider |
| `429` | Rate limit | Respect retry guidance; retry once with smaller bounds or switch providers |
| Timeout or oversized response | Scope is too broad or service is slow | Reduce results, content size, pages, depth, or subpages before one retry |
| `5xx` or transport error | Possibly transient | Retry once with bounded backoff, then degrade explicitly |

Do not silently convert a failed retrieval into an unsupported answer.

## Respect auth and side effects

Use configured OAuth or client-managed headers. Never put a real key in a URL, repository, note, example, or chat response. Never ask the user to paste a token into a search query.

Search, fetch, scrape, parse, and map are informational when used on supplied public sources. Crawl and Agent calls can consume meaningful quota; justify and bound them. Interact can click, type, navigate, or submit. Monitor and feedback tools write provider state. Call any state-changing surface only when the user explicitly authorizes that specific external effect.

Do not modify MCP registration or authentication while performing ordinary research. A setup, repair, rotation, or maintenance request may authorize configuration changes; inspect the exact target, redact output, verify file permissions, and test with a bounded read-only call.

## Maintain the skill

Run `scripts/check.sh` after edits. Run `scripts/check.sh --runtime` when the local Codex installation is available. Use `scripts/bootstrap.sh` to install or fast-forward this private repository without silently replacing a non-Git skill directory.

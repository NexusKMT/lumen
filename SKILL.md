---
name: lumen
description: Discover, retrieve, verify, and cite current web evidence through the retrieval capabilities exposed by the host agent. Use for web research, documentation lookup, current-fact verification, URL or file extraction, developer-source search, literature research, site discovery or crawling, provider selection, retrieval-stack diagnosis, and maintenance.
---

# Lumen

Use the smallest available capability that can produce inspectable source evidence. The workflow in this file is portable; provider references are routing guidance, not proof of current installation or service health.

The portable contract is this file and its `references/` documents. Hosts configure MCP servers through their own native settings.

This skill requires an MCP-capable host with at least one configured retrieval capability. The host manages provider authentication and tool registration.

## Scope and boundaries

Use Lumen for research and retrieval over public or user-supplied sources. It does not replace the host's MCP configuration, authentication, authorization, browser-session management, or provider billing controls.

Before using a state-changing capability such as interaction, monitor management, or feedback submission, obtain explicit authorization for that external effect. Ordinary search, fetch, scrape, parse, and map operations are informational when used on supplied public sources.

## Establish runtime truth

Distinguish these states before diagnosing or describing the retrieval stack:

1. **Registered**: the host agent's MCP inventory shows a configured server.
2. **Authenticated**: the connection has an accepted OAuth session or secret header. A masked header proves configuration, not validity.
3. **Exposed**: the current tool registry includes the required capability and its live schema.
4. **Healthy**: a bounded, read-only call succeeds now.

One state does not imply the next. Inspect the host agent's live inventory and current schema before calling a capability. Do not assume a client command, provider default name, namespace, transport, or argument shape is exposed unchanged by every host.

Read the relevant provider reference before use:

- `references/exa.md` for Exa search, fetch, advanced search, and Agent routing.
- `references/firecrawl.md` for Firecrawl search, scrape, parse, developer, research, map, crawl, Agent, interact, and monitor boundaries.
- `references/evidence-index.md` when refreshing or auditing this skill.

## Resolve capabilities

Map the user's need to a capability exposed by the current host, then resolve the live tool name and schema. Provider-specific names below are examples; they are not universal identifiers.

| Need | Capability to resolve | Reference |
| --- | --- | --- |
| General semantic discovery or current web lookup | semantic web search | Exa or Firecrawl |
| Known URL and readable source text | page retrieval or scrape | Exa or Firecrawl |
| Domain, date, category, freshness, highlight, or subpage filters | advanced search | Exa |
| Multi-step research or structured list building | retained or asynchronous research | Exa or Firecrawl |
| Programming questions over docs, issues, or repositories | developer-source search | Firecrawl |
| Local file or hosted upload reference | file parsing | Firecrawl |
| URLs under one site | site mapping | Firecrawl |
| A bounded section of a site | bounded crawling | Firecrawl |
| Browser interaction or recurring monitors | stateful interaction or monitoring | Firecrawl |

Use a native web-search capability for an independent cross-check only when the current registry exposes one. If no suitable capability is exposed, report the missing capability instead of pretending that a provider is available.

## Evidence workflow

1. Translate the request into a precise question and identify the likely primary authority.
2. Use search for discovery. Do not treat rankings, snippets, generated highlights, or provider summaries as proof.
3. Retrieve or scrape the strongest canonical primary pages. Prefer official documentation, standards, repositories, filings, or direct statements.
4. Cross-check material claims with an independent provider or a second primary source when practical. Independence matters more than repeating the same result through two wrappers.
5. Record the provider, resolved tool name, query or URL, important filters, freshness choice, canonical URL, and retrieval time in working notes.
6. Cite the source page URL, not a search-result wrapper. State provider failures, stale-cache risk, truncation, or unresolved disagreement.

## Bound calls

- Read the live schema and send only supported fields.
- Start with 3-5 search results and one or two page reads. Expand only when coverage is inadequate.
- Set explicit character, page, crawl, subpage, result, and parallelism limits.
- Prefer schema-shaped JSON for targeted fields; request full markdown only when the task needs the page narrative.
- Use live-fetch options only when freshness is material. Do not pay the latency and quota cost by default.
- Preserve IDs for asynchronous or retained research calls instead of starting duplicates.
- Never place credentials, private URLs, personal data, proprietary text, cookies, or session material in a search query.

## Handle failures

| Signal | Interpretation | Response |
| --- | --- | --- |
| Missing capability | Not exposed in this session | Refresh the inventory, inspect host configuration, then report the gap if it remains |
| Schema or invalid-argument error | Client assumptions are stale | Re-read the live schema and retry once with the smallest valid request |
| `401` or `403` | Authentication or authorization failure | Stop retries; report the failed auth layer without printing credentials |
| `402` | Balance, plan, or quota unavailable | Mark the provider unavailable and route to another healthy capability |
| `429` | Rate limit | Respect retry guidance; retry once with smaller bounds or switch providers |
| Timeout or oversized response | Scope is too broad or service is slow | Reduce results, content size, pages, depth, or subpages before one retry |
| `5xx` or transport error | Possibly transient | Retry once with bounded backoff, then degrade explicitly |

Do not silently convert a failed retrieval into an unsupported answer.

## Respect auth and side effects

Use configured OAuth or host-managed headers. Never put a real key in a URL, repository, note, example, or chat response. Never ask the user to paste a token into a search query.

Search, fetch, scrape, parse, and map are informational when used on supplied public sources. Crawls and retained research calls can consume meaningful quota; justify and bound them. Interaction, monitor, and feedback capabilities can change external state and require explicit authorization.

Do not modify MCP registration or authentication while performing ordinary research. A setup, repair, rotation, or maintenance request may authorize configuration changes; inspect the exact target, redact output, verify file permissions, and test with a bounded read-only call.

## Maintain the skill

When updating this repository, compare provider references with current official documentation, run the external Agent Skills validator when available, and inspect the diff for stale provider references, credentials, and unsupported tool assumptions. Install a fresh copy by cloning this repository into the skills directory documented by the host agent.

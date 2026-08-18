# Firecrawl MCP

Use this reference for provider-specific routing. Verify the live tool schema and official sources when exact behavior matters.

## Primary sources

- MCP setup: <https://docs.firecrawl.dev/mcp-server>
- MCP tool guide: <https://docs.firecrawl.dev/mcp-server/tools>
- Agent onboarding: <https://docs.firecrawl.dev/ai-onboarding>
- Official server repository: <https://github.com/firecrawl/firecrawl-mcp-server>

The full hosted endpoint is `https://mcp.firecrawl.dev/v2/mcp`. The optional search-only endpoint is `https://mcp.firecrawl.dev/v2/mcp-search`; it has a separate authentication identity and exposes a fixed read-only search/research surface.

## Authentication boundary

The full endpoint exposes Search, Scrape, and Parse with keyless daily limits. OAuth or an `Authorization: Bearer` API key unlocks the account's available tool surface and higher limits. Configure secrets in the client or secret manager, never in the MCP URL or repository.

Registration and a masked header are not proof of working authentication. Confirm with a bounded read-only call.

## Tool routing

### Discovery and retrieval

- `firecrawl_search`: Open-ended web, news, image, GitHub, research-site, or developer-category discovery. Use source and domain filters when the authority is known.
- `firecrawl_scrape`: One known web URL. Prefer schema-shaped JSON for defined fields and markdown for full-page reading. Call it once per known URL.
- `firecrawl_map`: Enumerate URLs under a site without retrieving all page contents.
- `firecrawl_crawl`: Collect a bounded site section. Set strict page, depth, and path constraints because responses and quota use can grow quickly.
- `firecrawl_parse`: Parse a local file or hosted upload reference. Do not send both input forms in one call.

### Specialized search

- `firecrawl_developer_search`: Programming questions over documentation, repository READMEs, issues, and merged pull requests.
- `firecrawl_research_search_papers`: Search paper metadata and abstracts.
- `firecrawl_research_inspect_paper`: Resolve canonical metadata for a known paper identifier.
- `firecrawl_research_related_papers`: Expand through citations or similarity from bounded seed IDs.
- `firecrawl_research_read_paper`: Retrieve passages relevant to a question from an indexed paper.
- `firecrawl_research_search_github`: Search the dedicated public GitHub research index.

Ordinary `firecrawl_search` with a research category filters web pages from research-affiliated sites. It is not the same as the paper index.

### Long-running and stateful tools

- `firecrawl_agent`: Start complex multi-source research; retain its ID and poll with `firecrawl_agent_status`.
- `firecrawl_interact`: Operate a live page. Clicking, typing, navigation, and submission can change external state. Require explicit user authorization.
- Monitor create, update, delete, and run tools write recurring provider state. Require explicit authorization.
- Feedback tools submit provider-side records. Require explicit authorization.

## Formats and freshness

Use JSON with a bounded schema when only defined fields are needed. Use markdown when the page narrative or exact surrounding context matters. Screenshots, branding, HTML, audio, and other formats have higher cost or payload size; request them only for a stated need.

Search can attach scraped content, but that path may reuse a fixed cache window and ignore scrape freshness controls. When freshness matters, search for the URL first and then call `firecrawl_scrape` with the live-fetch option supported by the current schema, commonly `maxAge: 0`.

Set PII redaction when returned content may contain personal data. Do not claim zero-data-retention behavior unless the authenticated account and current tool schema explicitly support it.

## Failure and evidence notes

- `401` or `403`: stop and fix auth; do not retry with the same request.
- `402`: plan, balance, or quota is unavailable; switch providers and report it.
- `429`: retry once with smaller scope or respect provider retry guidance.
- Large crawl or markdown results: reduce depth, pages, formats, or content and retry once.
- A successful scrape can be cached or incomplete. Record freshness settings and inspect the canonical page metadata.
- Search ranking and structured extraction are not proof. Validate material fields against source content.

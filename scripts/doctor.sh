#!/usr/bin/env bash
set -euo pipefail

redact() {
  sed -E \
    -e 's/(Authorization|x-api-key|api[-_]?key|token)([[:space:]]*[:=][[:space:]]*)[^[:space:]]+/\1\2<redacted>/g' \
    -e 's/(Bearer[[:space:]]+)[A-Za-z0-9._~+\/-]{20,}/\1<redacted>/g' \
    -e 's/([?&](exaApiKey|apiKey|api_key|token)=)[^&[:space:]]+/\1<redacted>/g'
}

printf 'Lumen runtime doctor\n'
printf 'checked_at: %s\n' "$(date -u '+%Y-%m-%dT%H:%M:%SZ')"

if ! command -v codex >/dev/null 2>&1; then
  printf 'codex: missing\n' >&2
  exit 1
fi

if mcp_list="$(codex mcp list 2>&1)"; then
  printf '\n[registered servers]\n%s\n' "$mcp_list" | redact
else
  printf '\n[registered servers: command failed]\n%s\n' "$mcp_list" | redact
fi

for provider in exa firecrawl; do
  printf '\n[%s]\n' "$provider"
  if provider_info="$(codex mcp get "$provider" 2>&1)"; then
    printf '%s\n' "$provider_info" | redact
  else
    printf 'status: unavailable\n%s\n' "$provider_info" | redact
  fi
done

printf '\nInterpretation: registration, authentication, exposed tools, and successful calls are separate checks.\n'

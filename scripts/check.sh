#!/usr/bin/env bash
set -euo pipefail

script_dir="$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
skill_root="$(CDPATH= cd -- "$script_dir/.." && pwd)"
runtime=0
failures=0
check_tmp="$(mktemp -d -t search-mcps-check)"
dropped_provider='ji''na'
cleanup() {
  if [[ -n "$check_tmp" && -d "$check_tmp" ]]; then
    rm -rf "$check_tmp"
  fi
}
trap cleanup EXIT HUP INT TERM

if [[ "${1:-}" == "--runtime" ]]; then
  runtime=1
elif [[ $# -gt 0 ]]; then
  printf 'usage: %s [--runtime]\n' "$0" >&2
  exit 2
fi

require_file() {
  if [[ ! -f "$skill_root/$1" ]]; then
    printf 'missing: %s\n' "$1" >&2
    failures=$((failures + 1))
  fi
}

require_file SKILL.md
require_file agents/openai.yaml
require_file references/exa.md
require_file references/firecrawl.md
require_file references/evidence-index.md
require_file scripts/doctor.sh
require_file scripts/bootstrap.sh

if [[ -f "$skill_root/SKILL.md" ]]; then
  if ! sed -n '1p' "$skill_root/SKILL.md" | grep -qx -- '---'; then
    printf 'SKILL.md: missing YAML frontmatter start\n' >&2
    failures=$((failures + 1))
  fi
  if ! rg -q '^name:[[:space:]]+search-mcps[[:space:]]*$' "$skill_root/SKILL.md"; then
    printf 'SKILL.md: invalid name\n' >&2
    failures=$((failures + 1))
  fi
  if ! rg -q '^description:[[:space:]]+[^[:space:]].*$' "$skill_root/SKILL.md"; then
    printf 'SKILL.md: missing description\n' >&2
    failures=$((failures + 1))
  fi
fi

if rg -n -i "$dropped_provider" "$skill_root" --glob '!.git/**' >"$check_tmp/provider" 2>/dev/null; then
  printf 'forbidden provider reference found:\n' >&2
  sed -n '1,20p' "$check_tmp/provider" >&2
  failures=$((failures + 1))
fi

if rg -n -i \
  '(gh[pousr]_[A-Za-z0-9_]{20,}|sk-[A-Za-z0-9_-]{20,}|fc-[A-Za-z0-9_-]{20,}|[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}|x-api-key["[:space:]=:]+[A-Za-z0-9_-]{20,}|Authorization["[:space:]=:]+Bearer[[:space:]]+[A-Za-z0-9._~+/-]{20,})' \
  "$skill_root" --glob '!.git/**' --glob '!scripts/check.sh' >"$check_tmp/secrets" 2>/dev/null; then
  printf 'possible credential found:\n' >&2
  sed -n '1,20p' "$check_tmp/secrets" >&2
  failures=$((failures + 1))
fi

if command -v bash >/dev/null 2>&1; then
  for script in "$skill_root/scripts/doctor.sh" "$skill_root/scripts/bootstrap.sh" "$skill_root/scripts/check.sh"; do
    if [[ -f "$script" ]] && ! bash -n "$script"; then
      printf 'shell syntax error: %s\n' "$script" >&2
      failures=$((failures + 1))
    fi
  done
fi

codex_root="${CODEX_HOME:-$HOME/.codex}"
validator="$codex_root/skills/.system/skill-creator/scripts/quick_validate.py"
if [[ -f "$validator" ]] && command -v python3 >/dev/null 2>&1; then
  if ! python3 "$validator" "$skill_root"; then
    failures=$((failures + 1))
  fi
else
  printf 'warning: skill-creator quick_validate.py is unavailable; local checks still ran\n'
fi

if [[ "$runtime" -eq 1 ]]; then
  if ! "$skill_root/scripts/doctor.sh"; then
    failures=$((failures + 1))
  fi
fi

if [[ "$failures" -gt 0 ]]; then
  printf 'check: failed (%d issue(s))\n' "$failures" >&2
  exit 1
fi

printf 'check: passed\n'

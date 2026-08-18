#!/usr/bin/env bash
set -euo pipefail

script_dir="$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source_root="$(CDPATH= cd -- "$script_dir/.." && pwd)"
repo_slug="${SEARCH_MCPS_REPO:-NexusKMT/search-mcps}"
repo_url="${SEARCH_MCPS_URL:-https://github.com/${repo_slug}.git}"
codex_root="${CODEX_HOME:-$HOME/.codex}"
destination="${1:-$codex_root/skills/search-mcps}"

if [[ "$destination" == "$source_root" ]]; then
  "$source_root/scripts/check.sh"
  printf 'bootstrap: source is already the requested destination\n'
  exit 0
fi

if [[ -e "$destination" ]]; then
  if [[ ! -d "$destination/.git" ]]; then
    printf 'refusing to replace non-Git destination: %s\n' "$destination" >&2
    exit 1
  fi

  remote_url="$(git -C "$destination" remote get-url origin 2>/dev/null || true)"
  case "$remote_url" in
    *github.com/${repo_slug}.git|*github.com/${repo_slug}) ;;
    *)
      printf 'refusing to update unexpected Git remote: %s\n' "${remote_url:-<none>}" >&2
      exit 1
      ;;
  esac

  if ! git -C "$destination" diff --quiet || ! git -C "$destination" diff --cached --quiet; then
    printf 'refusing to update a dirty destination: %s\n' "$destination" >&2
    exit 1
  fi

  git -C "$destination" pull --ff-only
  "$destination/scripts/check.sh"
  printf 'bootstrap: updated %s\n' "$destination"
  exit 0
fi

destination_parent="$(dirname -- "$destination")"
mkdir -p "$destination_parent"
stage_root=""
cleanup() {
  if [[ -n "$stage_root" && -d "$stage_root" ]]; then
    rm -rf "$stage_root"
  fi
}
trap cleanup EXIT HUP INT TERM

# The staging directory is created beside the destination so a successful first install
# can be moved onto the same volume without depending on /tmp or a cross-volume rename.
stage_root="$(mktemp -d "${destination_parent}/.search-mcps.XXXXXXXX")"
clone_target="$stage_root/search-mcps"

if command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
  gh repo clone "$repo_slug" "$clone_target" -- --depth 1
else
  git clone --depth 1 "$repo_url" "$clone_target"
fi

"$clone_target/scripts/check.sh"
mv "$clone_target" "$destination"
stage_root=""
printf 'bootstrap: installed %s\n' "$destination"

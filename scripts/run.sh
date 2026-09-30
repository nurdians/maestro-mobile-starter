#!/usr/bin/env bash
# Usage: scripts/run.sh [path] [tags]
#   path  default: flows/$PLATFORM
#   tags  optional, comma-separated (e.g. smoke)
# Device selection via .env or environment: PLATFORM=android|ios, DEVICE_ID=<id>
# Examples:
#   scripts/run.sh
#   scripts/run.sh flows/android smoke
#   PLATFORM=ios scripts/run.sh
set -euo pipefail
cd "$(dirname "$0")/.."

# Shell env takes precedence over .env
_P="${PLATFORM:-}"; _D="${DEVICE_ID:-}"
if [ -f .env ]; then set -a; source .env; set +a; fi
[ -n "$_P" ] && PLATFORM="$_P"
[ -n "$_D" ] && DEVICE_ID="$_D"
PLATFORM="${PLATFORM:-}"
DEVICE_ID="${DEVICE_ID:-}"

TARGET="${1:-}"
TAGS="${2:-}"

if [ -z "$TARGET" ]; then
  if [ -z "$PLATFORM" ]; then
    echo "Set PLATFORM=android|ios (in .env or environment) or pass a flow path." >&2
    exit 1
  fi
  TARGET="flows/$PLATFORM"
fi

# Global CLI options (must come before `test`)
GLOBAL_ARGS=()
if [ -n "$DEVICE_ID" ]; then
  GLOBAL_ARGS+=(--device "$DEVICE_ID")
elif [ -n "$PLATFORM" ]; then
  GLOBAL_ARGS+=(--platform "$PLATFORM")
fi

mkdir -p reports
TEST_ARGS=(--format junit --output reports/report.xml --debug-output reports/debug)
if [ -n "$TAGS" ]; then TEST_ARGS+=(--include-tags "$TAGS"); fi

maestro ${GLOBAL_ARGS[@]+"${GLOBAL_ARGS[@]}"} test "${TEST_ARGS[@]}" \
  -e APP_USER="${APP_USER:-}" \
  -e APP_PASSWORD="${APP_PASSWORD:-}" \
  "$TARGET"

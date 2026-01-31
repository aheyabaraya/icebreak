#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

resolve_flutter() {
  if command -v flutter >/dev/null 2>&1; then
    command -v flutter
    return
  fi

  local local_flutter="$REPO_ROOT/tooling/flutter/bin/flutter"
  if [ -x "$local_flutter" ]; then
    echo "$local_flutter"
    return
  fi

  echo "flutter not found. Install Flutter and add to PATH (or place it at $local_flutter)." >&2
  exit 1
}

FLUTTER_BIN="$(resolve_flutter)"
TS="$(date +%Y%m%d_%H%M)"
LOG_PATH="${REPO_ROOT}/docs/logs/install_${TS}.md"

mkdir -p "$(dirname "$LOG_PATH")"
{
  echo "# Bootstrap Log ${TS}"
  echo
  echo "- Timestamp: $(date -Iseconds)"
  echo "- Repo: ${REPO_ROOT}"
  echo "- Flutter: ${FLUTTER_BIN}"
  echo
} >"$LOG_PATH"

run_logged() {
  local title="$1"; shift
  {
    echo "## ${title}"
    echo '```text'
    "$@" 2>&1
    echo '```'
    echo
  } | tee -a "$LOG_PATH"
}

run_logged "flutter --version" "$FLUTTER_BIN" --version
run_logged "flutter doctor -v" "$FLUTTER_BIN" doctor -v

pushd "$REPO_ROOT/apps/mobile" >/dev/null
run_logged "flutter pub get" "$FLUTTER_BIN" pub get
run_logged "flutter pub deps --style=compact" "$FLUTTER_BIN" pub deps --style=compact
run_logged "flutter analyze" "$FLUTTER_BIN" analyze
popd >/dev/null

echo "Wrote log: $LOG_PATH"

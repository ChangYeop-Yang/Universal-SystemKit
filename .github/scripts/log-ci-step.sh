#!/usr/bin/env bash
set -euo pipefail

step_name=$1
log_name=$2
shift 2

log_dir="$RUNNER_TEMP/systemkit-logs"
log_file="$log_dir/$log_name"
mkdir -p "$log_dir"

SECONDS=0
{
  printf 'Step: %s\n' "$step_name"
  printf 'Started (UTC): %s\n' "$(date -u '+%Y-%m-%d %H:%M:%S')"
  printf 'Commit: %s\n' "$GITHUB_SHA"
  printf 'Command:'
  printf ' %q' "$@"
  printf '\n\n'
} | tee "$log_file"

status=0
"$@" 2>&1 | tee -a "$log_file" || status=$?

result=Passed
if (( status != 0 )); then
  result=Failed
fi

{
  printf '\nResult: %s\n' "$result"
  printf 'Exit code: %s\n' "$status"
  printf 'Finished (UTC): %s\n' "$(date -u '+%Y-%m-%d %H:%M:%S')"
  printf 'Duration: %s seconds\n' "$SECONDS"
  printf 'Log file: %s\n' "$log_name"
} | tee -a "$log_file"

if (( status != 0 )); then
  error=$(awk 'tolower($0) ~ /(^|[[:space:]])error:/ {print; exit}' "$log_file")
  error=${error//%/%25}
  error=${error//$'\r'/%0D}
  printf '::error::%s failed with exit code %s. %s See %s for details.\n' \
    "$step_name" "$status" "${error:-No error message was found.}" "$log_name"
fi

exit "$status"

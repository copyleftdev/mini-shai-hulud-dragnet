#!/usr/bin/env bash
# Verify all JSONL files parse and report record counts
set -euo pipefail
cd "$(dirname "$0")/../data"
for f in *.jsonl; do
  count=$(wc -l < "$f")
  jq -c . "$f" >/dev/null
  printf "%-32s %5d records  ✓\n" "$f" "$count"
done

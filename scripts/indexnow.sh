#!/usr/bin/env bash
# Re-submit URLs to IndexNow (Bing/Yandex/Naver/Seznam fan-out)
# Usage:
#   bash scripts/indexnow.sh                     # submit default URL list
#   bash scripts/indexnow.sh /docs/ /data/...    # submit specific paths

set -euo pipefail
cd "$(dirname "$0")/.."

KEY=$(cat .indexnow-key | tr -d '\n\r ')
HOST="copyleftdev.github.io"
BASE="https://${HOST}/mini-shai-hulud-dragnet"

if [ "$#" -eq 0 ]; then
  PATHS=(
    "/" "/docs/"
    "/llms.txt" "/llms-full.txt" "/sitemap.xml" "/robots.txt"
    "/DOSSIER.md" "/methodology.md"
    "/data/iocs.jsonl" "/data/victims.jsonl" "/data/dropboxes.jsonl"
    "/data/timeline.jsonl" "/data/actor.jsonl" "/data/affiliations.jsonl"
    "/data/archetypes.jsonl" "/data/researcher_trackers.jsonl" "/data/SCHEMA.md"
  )
else
  PATHS=("$@")
fi

URLS=$(printf '"%s",' "${PATHS[@]/#/${BASE}}" | sed 's/,$//')
PAYLOAD="{\"host\":\"${HOST}\",\"key\":\"${KEY}\",\"keyLocation\":\"${BASE}/${KEY}.txt\",\"urlList\":[${URLS}]}"

echo "Submitting ${#PATHS[@]} URLs to IndexNow"
for endpoint in "https://api.indexnow.org/indexnow" "https://www.bing.com/indexnow" "https://yandex.com/indexnow"; do
  http=$(curl -s -o /tmp/_indexnow.out -w "%{http_code}" \
    -X POST "$endpoint" \
    -H "Content-Type: application/json; charset=utf-8" \
    -H "User-Agent: copyleftdev-dragnet/1.0" \
    --data "$PAYLOAD")
  printf "  %-30s HTTP %s\n" "$endpoint" "$http"
done

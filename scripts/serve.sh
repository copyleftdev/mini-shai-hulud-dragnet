#!/usr/bin/env bash
# Serve the dashboard locally (data/ paths are relative)
cd "$(dirname "$0")/.."
python3 -m http.server 8080 --bind 127.0.0.1

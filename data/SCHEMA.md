# Data schema

All files in this directory are newline-delimited JSON (JSONL). One record per line. UTF-8.

Common fields across record types:
- `type` (string, required): record discriminator. Values: `ioc`, `victim`, `dropbox`, `event`, `actor`, `campaign`, `infra`, `archetype`, `affiliation`, `tracker`.
- `campaign` (string, optional): campaign tag, e.g. `mini-shai-hulud`, `checkmarx-kics-vsx-2026-04`.
- `actor` (string, optional): threat actor tag, e.g. `TeamPCP`.

## iocs.jsonl

Indicators of compromise, one per record.

| Field | Type | Notes |
|---|---|---|
| `kind` | string | `package`, `domain`, `ipv4`, `url`, `sha256`, `crypto_key`, `crypto_salt`, `github_account`, `string`, `regex`, `file_path`, `author_email`, `git_branch`, `runtime` |
| `value` (or `name` for packages) | string | The IOC itself |
| `version` | string | (packages only) |
| `registry` | string | (packages only) — `npm`, `docker`, `vscode` |
| `role` | string | What the IOC is for (e.g. `loader`, `payload`, `c2_exfil`, `persistence`, `dropbox_description_marker`) |
| `source` | string | Attribution source, e.g. `stepsecurity`, `kraven-security`, `harekrishnarai` |

## victims.jsonl

One record per compromised account. Personal-victim accounts are anonymized (no `login`, `email`, `name` fields). Corporate / infrastructure compromises are disclosed by org.

| Field | Type | Notes |
|---|---|---|
| `account_class` | string | `infrastructure_bot`, `corporate_org_account`, `corporate_user_account`, `personal_account` |
| `org_disclosed` | string | Disclosed company/org or null |
| `country_disclosed` | string | Disclosed country or null |
| `industry_disclosed` | string | Industry classification or null |
| `archetype` | string | One of `A:CI-BURST`, `B:DEV-WKSTN`, `C:SINGLE-CI`, `D:LONG-TAIL`, `E:MIXED`, `SINGLE` |
| `dropbox_count` | int | Number of dropbox repos owned |
| `first_drop_utc` / `last_drop_utc` | string | ISO 8601 UTC |
| `span_seconds` | int | Seconds between first and last drop |
| `burst_repos_per_min` | float | Bursting cadence |
| `total_payload_kb` | int | Aggregate payload size |
| `account_age_years` | int | At time of compromise |

## dropboxes.jsonl

One record per dropbox repo.

| Field | Type | Notes |
|---|---|---|
| `repo` | string | `owner/name` |
| `url` | string | Direct GitHub URL |
| `owner` | string | GitHub login (the compromised account) |
| `created_at` / `pushed_at` | string | ISO 8601 UTC |
| `size_kb` | int | Repo size in KB (proxy for stolen-credential payload size) |

## timeline.jsonl

Chronological events.

| Field | Type | Notes |
|---|---|---|
| `ts_utc` | string | ISO 8601 UTC |
| `kind` | string | `infrastructure`, `persistence`, `trojan_publish`, `public_attribution`, `propagation_observed`, `sap_infrastructure_compromise`, `dragnet_close` |
| `detail` | string | Event description |
| `source` | string | Attribution source |

## actor.jsonl

Mixed records: `actor`, `campaign`, `infra` types describing TeamPCP and its operations.

## affiliations.jsonl

Disclosed corporate affiliations of compromised accounts. `ir_priority` is `P0`–`P3`.

## archetypes.jsonl

Taxonomy of victim machine archetypes with thresholds and interpretations.

## researcher_trackers.jsonl

Third-party trackers / blogs / IOC feeds tracking this campaign.

## aggregations/

Pre-computed JSON arrays for the dashboard:
- `per_minute.json`, `per_hour.json` — propagation curves
- `cumulative.json` — cumulative dropbox count by timestamp
- `by_archetype.json` — per-archetype rollup
- `scatter.json` — per-victim points for the burst × payload scatter
- `ioc_kinds.json` — IOC count by kind

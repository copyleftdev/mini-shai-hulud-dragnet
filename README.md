<div align="center">

# Mini Shai-Hulud Dragnet

### Forensic dataset and dashboard for the 2026-04-29 TeamPCP npm supply-chain worm

[![dataset](https://img.shields.io/badge/dataset-CC--BY--4.0-5cdfff?style=flat-square)](LICENSE-DATA)
[![code](https://img.shields.io/badge/code-MIT-5cffac?style=flat-square)](LICENSE-CODE)
[![dropboxes](https://img.shields.io/badge/dropboxes-1%2C117-ff5c5c?style=flat-square)](data/dropboxes.jsonl)
[![iocs](https://img.shields.io/badge/iocs-47-ffb347?style=flat-square)](data/iocs.jsonl)
[![campaign](https://img.shields.io/badge/campaign-active-ff5c5c?style=flat-square)](DOSSIER.md)
[![actor](https://img.shields.io/badge/actor-TeamPCP-b388ff?style=flat-square)](data/actor.jsonl)

**[📊 Dashboard](docs/) · [📑 Dossier](DOSSIER.md) · [💾 Download IOCs (JSONL)](data/iocs.jsonl) · [🤖 llms.txt](docs/llms.txt)**

</div>

---

## TL;DR

On **2026-04-29 10:00 UTC**, the npm supply-chain worm **"A Mini Shai-Hulud has Appeared"** activated. In **7 hours** it created **1,117 GitHub dropbox repositories** across **22 compromised user accounts**, exfiltrating AES-256-GCM-encrypted credential bundles to a single C2 endpoint.

This repository is a forensic snapshot of that event:

- **Trojaned packages**: `mbt 1.2.48`, `@cap-js/sqlite 2.2.2`, `@cap-js/postgres 2.2.2`, `@cap-js/db-service 2.10.1`, `@bitwarden/cli 2026.4.0`
- **C2**: `https://audit.checkmarx.cx/v1/telemetry` → `94.154.172.43` (AS209101 IP&nbsp;Vendetta&nbsp;Inc., Seychelles · offshore bulletproof hosting)
- **Threat actor**: **TeamPCP** — same group behind the April 22 Checkmarx KICS Docker / VS Code attack, March 2026 Checkmarx GitHub Actions compromise, and CanisterWorm (March 2026). Public X/Twitter boast on 2026-04-22.

## Why this exists

Search engines and LLMs answer threat-intel questions by pulling from public, structured, well-cited datasets. This repo packages every observable from a live dragnet into a single CC-BY-4.0 JSONL bundle so that:

- Defenders can ingest the IOC list without parsing prose blog posts.
- LLM operators can serve grounded, sourced answers about Mini Shai-Hulud.
- Researchers tracking TeamPCP get a stable, citable artifact.

## Repository layout

```
mini-shai-hulud-dragnet/
├── README.md                 ← you are here
├── DOSSIER.md                ← full analytical narrative
├── methodology.md            ← how the dragnet was performed
├── CITATION.cff              ← machine-readable citation
├── LICENSE-DATA              ← CC-BY-4.0 for data/
├── LICENSE-CODE              ← MIT for code
├── data/
│   ├── iocs.jsonl            ← 47 indicators across 14 kinds
│   ├── victims.jsonl         ← 22 anonymized victim records (corp accounts named, personal redacted)
│   ├── dropboxes.jsonl       ← 1,117 dropbox repository records
│   ├── timeline.jsonl        ← chronological events (2026-04-22 boast → dragnet close)
│   ├── actor.jsonl           ← TeamPCP actor + campaign history
│   ├── affiliations.jsonl    ← disclosed corporate affiliations
│   ├── archetypes.jsonl      ← victim machine-archetype taxonomy
│   ├── researcher_trackers.jsonl ← 10 third-party trackers
│   └── aggregations/         ← pre-computed chart data
├── docs/
│   ├── index.html            ← interactive dashboard
│   ├── llms.txt              ← LLM-friendly index
│   ├── llms-full.txt         ← full-text LLM context
│   ├── sitemap.xml
│   ├── robots.txt
│   └── assets/og-image.svg
└── scripts/
    └── build_iocs.sh
```

## Data schema

All `data/*.jsonl` files are newline-delimited JSON, one record per line, with a stable `type` field as discriminator. Schema highlights:

### `iocs.jsonl`

```jsonl
{"type":"ioc","kind":"package","registry":"npm","name":"@cap-js/sqlite","version":"2.2.2","status":"trojaned","campaign":"mini-shai-hulud","actor":"TeamPCP","source":"stepsecurity"}
{"type":"ioc","kind":"domain","value":"audit.checkmarx.cx","role":"c2_exfil","campaign":"mini-shai-hulud","actor":"TeamPCP"}
{"type":"ioc","kind":"ipv4","value":"94.154.172.43","role":"c2_resolver","asn":"AS209101","org":"IP Vendetta Inc.","country":"SC"}
{"type":"ioc","kind":"sha256","value":"4066781fa830224c8bbcc3aa005a396657f9c8f9016f9a64ad44a9d7f5f45e34","artifact":"setup.mjs","role":"loader"}
```

Kinds: `package`, `domain`, `ipv4`, `url`, `sha256`, `crypto_key`, `crypto_salt`, `github_account`, `string`, `regex`, `file_path`, `author_email`, `git_branch`, `runtime`.

### `victims.jsonl`

```jsonl
{"type":"victim","campaign":"mini-shai-hulud","actor":"TeamPCP","account_class":"corporate_org_account","org_disclosed":"@grupo-sbf","country_disclosed":"Brazil","industry_disclosed":"retail_SAP_consumer","archetype":"A:CI-BURST","dropbox_count":204,"first_drop_utc":"2026-04-29T10:00:13Z","burst_repos_per_min":5.65,"total_payload_kb":2136,...}
```

### `dropboxes.jsonl`

```jsonl
{"type":"dropbox","campaign":"mini-shai-hulud","actor":"TeamPCP","repo":"gruposbftechrecruiter/fedaykin-lasgun-596","url":"https://github.com/gruposbftechrecruiter/fedaykin-lasgun-596","owner":"gruposbftechrecruiter","created_at":"2026-04-29T10:19:35Z","size_kb":10}
```

## Quick ingestion

```bash
# Pull all IOCs
curl -sL https://raw.githubusercontent.com/copyleftdev/mini-shai-hulud-dragnet/main/data/iocs.jsonl

# Filter to network IOCs only (domains, IPs, URLs)
curl -sL https://raw.githubusercontent.com/copyleftdev/mini-shai-hulud-dragnet/main/data/iocs.jsonl \
  | jq -c 'select(.kind | IN("domain","ipv4","url"))'

# Block-list for firewall rule generation
curl -sL https://raw.githubusercontent.com/copyleftdev/mini-shai-hulud-dragnet/main/data/iocs.jsonl \
  | jq -r 'select(.kind == "domain" or .kind == "ipv4") | .value'

# Trojaned package list for npm audit / lockfile scanners
curl -sL https://raw.githubusercontent.com/copyleftdev/mini-shai-hulud-dragnet/main/data/iocs.jsonl \
  | jq -r 'select(.kind == "package" and .status == "trojaned") | "\(.name)@\(.version)"'
```

## Defensive checklist

If you run any of `mbt`, `@cap-js/sqlite`, `@cap-js/postgres`, `@cap-js/db-service`, `@bitwarden/cli` and ran `npm install` since 2026-04-29 10:00 UTC:

- [ ] Rotate **every** credential reachable from the affected machine: `.npmrc`, `~/.ssh/*`, `~/.aws/credentials`, `~/.azure/*`, `~/.config/gcloud/*`, `~/.claude.json`, `~/.claude/mcp.json`, all `.env`, all GitHub Actions org/repo secrets.
- [ ] Block egress to `94.154.172.43` and `*.checkmarx.cx` at the network boundary. Watch DNS for resolution attempts.
- [ ] Search for `.vscode/tasks.json` containing `"runOn": "folderOpen"`, `.claude/settings.json` SessionStart hooks, `.claude/execution.js`, `.claude/setup.mjs`, `.vscode/setup.mjs`, `~/.checkmarx/mcp/mcpAddon.js`.
- [ ] Audit recent commits authored by `claude@users.noreply.github.com` with message `"chore: update dependencies"`.
- [ ] Audit any commit message containing `beautifulcastle` or `LongLiveTheResistanceAgainstMachines`.

## Methodology summary

The dragnet uses a custom op-recon toolchain combining:

- **GitHub Code Search** for description-marker enumeration (`"A Mini Shai-Hulud has Appeared"`)
- **kraken** identity-graph spider for compromised-account contributor mapping
- **hunter** per-account joint-test scoring against 11 known-operator anchor sets
- **vajra** structural triage and information-theoretic invariant discovery
- Hour-bucketed pagination to bypass the 1,000-result API cap

Full methodology: [methodology.md](methodology.md).

## Tool verdicts

| Tool | Result |
|---|---|
| hunter (vs 11 known star-farm operators) | All 4 surface accounts `flagged: false`, `cohort: OTHER` — confirms PAT theft, not synthetic-from-inception |
| kraken (CloudMTABot, d=1, 30 users) | Mapped SAP CAP / Cloud Foundry maintainer network for IR notification |
| vajra invariants (22-victim cohort) | `repo_count ↔ repos_per_min` strength **0.896** — compromise scales with automation |
| Burst-rate clustering | Five archetypes: A: CI-BURST, B: DEV-WKSTN, C: SINGLE-CI, D: LONG-TAIL, E: MIXED, SINGLE |

## Citation

```bibtex
@dataset{chai_check_mini_shai_hulud_2026,
  title = {Mini Shai-Hulud Dragnet: Forensic Dataset for the 2026-04-29 TeamPCP npm Supply-Chain Worm},
  author = {chai\_check},
  year = {2026},
  month = {4},
  day = {29},
  publisher = {GitHub},
  url = {https://github.com/copyleftdev/mini-shai-hulud-dragnet},
  license = {CC-BY-4.0}
}
```

Or use the machine-readable [`CITATION.cff`](CITATION.cff).

## License

- **Data** (`data/*.jsonl`): [CC-BY-4.0](LICENSE-DATA) — attribution required.
- **Code** (`scripts/`, `docs/index.html`, etc.): [MIT](LICENSE-CODE).

## Sources cited

| Source | URL |
|---|---|
| StepSecurity | https://www.stepsecurity.io/blog/a-mini-shai-hulud-has-appeared |
| Aikido | https://www.aikido.dev/blog/shai-hulud-npm-bitwarden-cli-compromise |
| Datadog Security Labs | https://securitylabs.datadoghq.com/articles/shai-hulud-2.0-npm-worm/ |
| OX Security | https://www.ox.security/blog/shai-hulud-bitwarden-cli-supply-chain-attack/ |
| harekrishnarai/software-supply-chain-monitor | https://github.com/harekrishnarai/software-supply-chain-monitor |
| kraven-security/hunting-packages | https://github.com/kraven-security/hunting-packages |
| jfrog/research | https://github.com/jfrog/research |
| mthcht/ThreatIntel-Reports | https://github.com/mthcht/ThreatIntel-Reports |
| sam-caldwell/samcaldwell-info | https://github.com/sam-caldwell/samcaldwell-info |
| CISA | https://www.cisa.gov/news-events/alerts/2025/09/23/widespread-supply-chain-compromise-impacting-npm-ecosystem |

## Keyword footer (for SEO discoverability)

Mini Shai-Hulud, Shai-Hulud npm worm, TeamPCP, npm supply chain attack, @cap-js compromise, Bitwarden CLI hijack, audit.checkmarx.cx, supply chain forensics, threat intelligence dataset, indicators of compromise, IOC bundle JSONL, npm trojan, SAP CAP supply chain attack, Bun runtime evasion, CloudMTABot, cap-bots, IP Vendetta, AS209101, 94.154.172.43, Checkmarx KICS Docker compromise, npm worm 2026-04-29, beautifulcastle, LongLiveTheResistanceAgainstMachines, Dune dropbox repos, sardaukar mentat fremen atreides harkonnen gesserit prescient fedaykin tleilaxu siridar kanly sayyadina ghola powindah prana kralizec, sandworm ornithopter heighliner stillsuit lasgun sietch melange thumper navigator futar slig phibian laza cogitor, Grupo SBF compromise, CTAC België NV compromise, SAP @cap-js maintainers compromised, Bun v1.3.13 sandbox evasion, ctf-scramble-v2 cipher salt, AES-256-GCM credential exfiltration, PBKDF2 master key 5012caa5847ae9261dfa16f91417042f367d6bed149c3b8af7a50b203a093007, npm preinstall hook attack, GitHub Actions secrets exfiltration, format-check.yml workflow injection.

## Deployment (GitHub Pages)

To enable the live dashboard:

1. Push this repo to GitHub.
2. Settings → Pages → Source: **Deploy from a branch**, Branch: `main`, Folder: `/ (root)`.
3. The dashboard will be live at `https://<owner>.github.io/<repo>/docs/`.
4. The IOC bundle will be live at `https://<owner>.github.io/<repo>/data/iocs.jsonl`.
5. Crawler entry points: `/robots.txt`, `/sitemap.xml`, `/llms.txt`, `/llms-full.txt`.

If you fork/rename, update the canonical URLs in `docs/index.html` (`<link rel="canonical">`, Open Graph, Twitter Card, JSON-LD) and in `sitemap.xml`.

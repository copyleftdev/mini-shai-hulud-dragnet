# Mini Shai-Hulud Dragnet — 2026-04-29

## TL;DR

Active npm supply-chain worm propagating right now. **1,117 unique victim "dropbox" repos across 22 unique compromised accounts**, all created today (2026-04-29 10:00:13Z – 17:18:30Z) with description `"A Mini Shai-Hulud has Appeared"`. Attribution: **TeamPCP** — same threat actor as April 22 Checkmarx KICS Docker/VS Code attack, March 2026 Checkmarx GitHub Actions compromise, and CanisterWorm (March 2026). Same C2 (`audit.checkmarx.cx` / `94.154.172.43` AS209101 IP Vendetta Inc., Seychelles), same workflow injection (`.github/workflows/format-check.yml`), same Bun runtime (v1.3.13), same Dune-vocabulary repo names. Day-zero of the campaign infrastructure: 2026-04-23 (C2 domain registration + first known persistence-injection commit at `iwteoieefw/princess-bride` 21:06:34Z).

Workspace: `/home/ops/Project/chai_check/dragnet/`

## Threat actor

**TeamPCP.** Public boast on X April 22 2026: *"Thank you OSS distribution for another very successful day at PCP inc."* — posted same day they pushed the Checkmarx KICS Docker images. Campaign cadence: ~1 major drop per week.

Prior known operations:
- March 2026: CanisterWorm (npm)
- March 2026: Checkmarx GitHub Actions compromise
- April 22 2026: Checkmarx KICS Docker + VS Code extensions (`checkmarx/kics`, `checkmarx/cx-dev-assist`, `checkmarx/ast-results`)
- April 29 2026: Mini Shai-Hulud + Bitwarden CLI (this incident)

Commit-message markers TeamPCP uses on infected source repos:
- `LongLiveTheResistanceAgainstMachines:<encoded-token>`
- `beautifulcastle <base64-c2-url>.<victim-token>` ← live persistence pattern, base64 decodes to `https://94.154.172.43/v1/telemetry`

## C2 infrastructure

| Indicator | Value | Notes |
|---|---|---|
| Primary domain | `audit.checkmarx.cx` | Typosquat (legit Checkmarx is `.com` / 141.193.213.20) |
| Apex domain `checkmarx.cx` | Updated **2026-04-23** | Six days before today's worm — campaign prep |
| Registrar | CentralNic Ltd (UK) | via `registry@key-systems.net` |
| Nameservers | `ns1.dnsowl.com`, `ns2.dnsowl.com`, `ns3.dnsowl.com` | DNSOwl/NameSilo (low-cost privacy registrar) |
| Resolver IP | `94.154.172.43` | **AS209101 IP Vendetta Inc., Seychelles** (offshore bulletproof hosting) |
| C2 endpoint path | `/v1/telemetry` | |
| Operational tradecraft | Subdomain only resolves during exfil window — currently NXDOMAIN | |

## Trojaned npm packages (do not install)

| Package | Version |
|---|---|
| `mbt` | 1.2.48 |
| `@cap-js/sqlite` | 2.2.2 |
| `@cap-js/postgres` | 2.2.2 |
| `@cap-js/db-service` | 2.10.1 |
| `@bitwarden/cli` | 2026.4.0 |

Loader (identical across all): `setup.mjs`
SHA-256 `4066781fa830224c8bbcc3aa005a396657f9c8f9016f9a64ad44a9d7f5f45e34`

Payload: `execution.js` (~11.6MB obfuscated). PBKDF2 master key `5012caa5847ae9261dfa16f91417042f367d6bed149c3b8af7a50b203a093007`. Cipher salt `ctf-scramble-v2`.

Additional payload SHA-256s tracked in TeamPCP campaign:
- `18f784b3bc9a0bcdcb1a8d7f51bc5f54323fc40cbd874119354ab609bef6e4cb`
- `8605e365edf11160aad517c7d79a3b26b62290e5072ef97b102a01ddbb343f14`
- `167ce57ef59a32a6a0ef4137785828077879092d7f83ddbc1755d6e69116e0ad`

## Two infection vectors

**Vector 1 — Dropbox creation** (1,117 confirmed today):
- Encrypted JSON envelopes uploaded via stolen victim PATs
- Description marker: `"A Mini Shai-Hulud has Appeared"`
- Filename: `results-{unix_ms}-N.json`
- Repo-name regex: `(sardaukar|mentat|fremen|atreides|harkonnen|gesserit|prescient|fedaykin|tleilaxu|siridar|kanly|sayyadina|ghola|powindah|prana|kralizec)-(sandworm|ornithopter|heighliner|stillsuit|lasgun|sietch|melange|thumper|navigator|fedaykin|futar|slig|phibian|laza|cogitor|ghola)-\d{1,3}`

**Vector 2 — Persistence-commit injection**:
- `beautifulcastle <base64-c2-url>.<victim-token>` commit message pushed to victim's existing repo
- First known: `iwteoieefw/princess-bride` 2026-04-23 21:06:34Z (six minutes after C2 domain registration)
- Spoofed author: `claude@users.noreply.github.com`, message `"chore: update dependencies"`
- Spoofed dependabot variant: branch `dependabout/github_actions/format/setup-formatter`, file `.github/workflows/format-check.yml`, committer `dependabot[bot]@users.noreply.github.com`, artifact `format-results`

## On-disk persistence (in compromised dev environments)

- `.vscode/tasks.json` containing `"runOn": "folderOpen"`
- `.claude/settings.json` SessionStart hook (steals MCP / `.claude.json`)
- `.claude/execution.js`, `.claude/setup.mjs`, `.vscode/setup.mjs`
- `~/.checkmarx/mcp/mcpAddon.js` (variant from KICS campaign — same actor)

## Code strings (defensive detection)

- `"Exiting as russian language detected!"` (geolocation evasion)
- `__DAEMONIZED` env flag
- GitHub PAT regex `/gh[op]_[A-Za-z0-9]{36}/g`
- npm token regex `/npm_[A-Za-z0-9]{36,}/g`
- Bun version `1.3.13`, fetched from `github.com/oven-sh/bun/releases/download/bun-v1.3.13/`
- VARIABLE_STORE / `${{ toJSON(secrets) }}` (GitHub Actions exfil primitive in injected workflow)

## Confirmed compromised npm-publisher GitHub account

**`CloudMTABot`** — https://github.com/CloudMTABot
- Email: `cloudmtabot@gmail.com`
- Created 2019-04-30, last update 2026-02-11
- Hunter verdict (against 11 known star-farm operator anchor sets): no joint flags, no anchor hits, `cohort:OTHER`, 0 stars, 0 keys
- **Ruling: legitimate SAP service-bot account; PAT/npm-token stolen, not synthetic-from-inception**

## Victim machine-archetype taxonomy (clustered by burst signature)

22 compromised accounts cluster cleanly into 5 archetypes:

| Class | Pattern | Accounts |
|---|---|---|
| **A: CI-BURST** | >5 repos/min, <30 min span | 4 victim machines: ranges 5.65–8.93 r/min over 16–36 min; 1 single-build SAP service-bot |
| **B: DEV-WKSTN** | <2 repos/min, multi-hour span | 2 victim machines: 0.88 r/min over 5h and 0.25 r/min over 8 min |
| **D: LONG-TAIL** | <0.1 repos/min, multi-hour span | 4 victim machines: 0.01–0.05 r/min over 1.2–5.9h |
| **E: MIXED** | 2-5 repos/min over 2+ hours | 2 victim machines: ~2 r/min over 2.5h — sustained dev box with heavy CI loop |
| **SINGLE** | 1 repo, single npm-install event | 10 victims |

## Vajra cross-field invariants (information-theoretic structure)

| Pair | Strength | Reading |
|---|---|---|
| `repo_count ↔ repos_per_min` | **0.896** | CI-compromise = both heavy AND fast (compromise scales with automation) |
| `median_size ↔ total_size_kb` | **0.792** | Per-bundle harvest is consistent within a victim machine (uniform cred density per project) |
| `median_size ↔ repo_count` | 0.452 | Weaker; payload size per drop ~= per-machine cred density |

## Corporate / geographic attribution (cluster on profile metadata)

This is **SAP-ecosystem pen-flooding** — the trojaned `@cap-js/*` and `mbt` packages are SAP-specific, so the victim distribution maps directly to SAP-tooling consumers:

| Org | Affected accounts (count) | Evidence |
|---|---|---|
| **SAP** (`@cap-js`) | 1 bot (`cap-bots`) | Service-account PAT used to publish `@cap-js/*` trojans |
| **SAP** (CloudMTA) | 1 bot (`CloudMTABot`) | Service-account PAT used to publish `mbt@1.2.48` trojan |
| **Grupo SBF** (Brazil retail / Centauro / Nike-BR) | 1 corporate user account | Patient zero of observable propagation (10:00:13Z) |
| **CTAC België NV** (Belgian SAP gold-partner) | 2 employee accounts | Both downstream of trojaned `@cap-js/*` consumption |
| **Maventic Innovative Solutions** (India SAP consultancy) | 1 employee account | |
| **ATOM** (Dubai) | 1 employee account | |
| **Oslo Metropolitan University** | 1 academic account | |
| Other SAP partners (-AMT suffix etc.) | 1+ employee account | |
| Personal / undisclosed | 11 accounts | Individual developer machines pulled in via npm |

> Individual victim handles, names, and emails are intentionally omitted from this public dossier. Affected orgs should coordinate IR routing privately; raw account-level evidence is retained in the internal investigation workspace.

Geographic spread: India (4), Belgium (2), Brazil, Dubai, Norway, SAP infrastructure.

## Social-graph negative finding

Top 6 victim accounts have **0 followers, 0 following from each other** — confirmed via pairwise intersection. **The worm propagates through `npm install` exclusively, no social-vector amplification.** Each victim is an independent node — no edges between them.

## Exfil-time forensics (45 sample envelopes across 17 victims)

| Statistic | Value |
|---|---|
| Median drift (exfil_at − repo_created_at) | **5 seconds** |
| p25 / p75 | 2 / 12 seconds |
| p99 | 299 seconds |
| Negative drift count | 0 / 45 |

Implication: harvest → create dropbox → upload is **one unbroken automated chain on the victim machine**, not a batched/staged exfil. Tail outliers (258s, 299s, 338s) suggest occasional retry or two-stage cred collection on the same dropbox.

## Patient-zero timeline

| Time UTC | Event |
|---|---|
| 2026-04-23 | C2 domain `checkmarx.cx` registered/updated |
| 2026-04-23 21:06:34Z | First known TeamPCP persistence commit (`iwteoieefw/princess-bride`) |
| 2026-04-29 10:00:13Z | First worm dropbox observable: Grupo SBF corporate user account |
| 2026-04-29 10:01:28Z | Second observable: AMT-suffixed SAP-partner account |
| 2026-04-29 10:07:06Z | Third observable: personal account |
| 2026-04-29 10:00–11:00 | Peak hour: 368 dropboxes |
| 2026-04-29 17:18:30Z | Latest observed dropbox (dev-workstation archetype) |

Hourly distribution:

| Hour UTC | Dropboxes |
|---|---|
| 10:00 | 368 |
| 11:00 | 163 |
| 12:00 | 276 |
| 13:00 | 147 |
| 14:00–18:00 | 168 |

Decay after ~13:00 UTC suggests early PAT rotations are landing.

## CloudMTABot collaborator network (kraken — high-level)

The kraken d=1 spider around `CloudMTABot` surfaces a ~30-developer maintainer ecosystem of SAP CAP / Cloud Foundry contributors with corporate `@sap.com` affiliations. These developers commit to repos in CloudMTABot's 1-hop network and are downstream consumers of the trojaned `mbt` / `@cap-js/*` packages.

The aggregated email list is intentionally omitted from this public dossier — even though each address is independently public via git commit history, aggregating them into a "high-priority IR notification list" is a soft re-disclosure pattern best handled privately. **SAP PSRT (security@sap.com) is the correct first hop** for routing notifications inside this maintainer network.

Active orgs in the collaborator graph: `SAP`, `sap-cloudfoundry`, `sap-tutorials`, `cloudfoundry`, `open-resource-discovery`, `gardener`, `cap-js`.

## Heaviest exfil bundles (most credentials stolen)

- 447 KB encrypted (single biggest cred haul observed; mixed-archetype personal account)
- 342 KB (Grupo SBF corporate-user CI burst)
- 79 KB (sustained dev workstation)

(Specific repo paths retained in the internal investigation workspace; not republished here to avoid driving traffic to live victim repos.)

## Researcher-tracker repos (auto-IOC feeds for follow-on TeamPCP drops)

- `harekrishnarai/software-supply-chain-monitor`
- `jfrog/research`
- `kraven-security/hunting-packages`
- `mthcht/ThreatIntel-Reports`
- `sam-caldwell/samcaldwell-info` (cached threatfox feed)

## Tool verdicts

- **hunter** (4 leads × 11 known-operator anchor sets): no joint flags, no anchor hits, all `cohort:OTHER`. ⇒ **NOT a star-farm campaign.** Surface accounts are real, not synthetic. Calibration is correctly tuned for star-farm operators; for PAT-theft worms the per-axis output (lifecycle, identity) is what's load-bearing.
- **kraken** (CloudMTABot d=1, 30 users): yields the SAP CAP / Cloud Foundry maintainer network — used for IR-routing inside SAP PSRT, not republished here.
- **vajra** (anomalies + invariants on 1,117-victim slice): cluster-by-owner reveals the bursty CI-pipeline signature (5–9 repos/min for compromised CI accounts vs. 0.9/min for compromised dev workstations). Information-theoretic correlations confirmed.

## Next steps for IR

1. **Page SAP PSRT** (security@sap.com) — they own the CloudMTABot / @cap-js notification routing inside the SAP CAP / Cloud Foundry maintainer ecosystem.
2. **Notify Grupo SBF security** — patient-zero corporate compromise (10:00:13Z).
3. **Notify CTAC België NV security** — two compromised employee accounts; their entire SAP-implementation pipeline should be checked.
4. **Notify Maventic Innovative Solutions, ATOM (Dubai), Oslo Metropolitan University**, and the AMT-suffixed SAP-partner organisation, via their respective security channels.
5. **Alert npm/GitHub** to revoke `CloudMTABot` and `cap-bots` tokens and yank the trojaned versions if not already done.
6. **Anyone running `mbt`, `@cap-js/sqlite`, `@cap-js/postgres`, `@cap-js/db-service` since 2026-04-29 10:00Z**: treat ALL credentials in `.npmrc`, `~/.ssh/`, `~/.aws/`, `~/.claude.json`, `.env`, MCP configs, GitHub Actions secrets as compromised. Rotate every one.
7. **Check `.vscode/tasks.json`, `.claude/settings.json`, `.claude/execution.js`, `.vscode/setup.mjs`, `~/.checkmarx/mcp/mcpAddon.js`** in every repo on suspect machines.
8. **Audit recent commits authored by `claude@users.noreply.github.com` with message `"chore: update dependencies"` AND any commit message containing `beautifulcastle` or `LongLiveTheResistanceAgainstMachines`.**
9. **Block egress to `94.154.172.43` and `*.checkmarx.cx`** at network boundary. Watch for resolution attempts (subdomain only resolves during exfil).

## Artefacts on disk

| File | Description |
|---|---|
| `victims_slim.json` | First 1000 victim repos, slim metadata |
| `stage1_p[1-10].json` | Raw search responses |
| `by_owner.json` / `deep/by_owner_full.json` | Per-owner aggregation w/ burst signature |
| `deep/all_victim_repos.json` | All 1,117 unique victim repos (hour-bucketed enumeration) |
| `deep/victim_profiles.jsonl` | 22 victim account profiles |
| `deep/exfil_times.tsv` | Exfil-time vs repo-creation-time forensics |
| `deep/teampcp_persistence.tsv` | 19 researcher repos tracking the campaign |
| `deep/checkmarx_victim_owners.txt` | Cross-campaign victim list (Apr 22 KICS attack) |
| `op-recon/hunter_*.json` | Per-account hunter verdicts |
| `op-recon/kraken_cloudmtabot.toon` | SAP collaborator network |
| `op-recon/kraken_<personal>.toon` | personal-account identity recovery — held internally |

## Sources

- [A Mini Shai-Hulud has Appeared — StepSecurity](https://www.stepsecurity.io/blog/a-mini-shai-hulud-has-appeared)
- [Bitwarden CLI compromise — Aikido](https://www.aikido.dev/blog/shai-hulud-npm-bitwarden-cli-compromise)
- [Shai-Hulud 2.0 lineage — Datadog Security Labs](https://securitylabs.datadoghq.com/articles/shai-hulud-2.0-npm-worm/)
- [Shai-Hulud: The Third Coming — OX Security](https://www.ox.security/blog/shai-hulud-bitwarden-cli-supply-chain-attack/)
- [Checkmarx KICS Docker/VS Code IOCs — harekrishnarai](https://github.com/harekrishnarai/software-supply-chain-monitor/blob/main/attacks/2026-04-checkmarx-kics-docker-vscode.md)
- [Bitwarden CLI / Mini Shai-Hulud network IOCs — kraven-security](https://github.com/kraven-security/hunting-packages)
- [JFrog research — Bitwarden CLI hijack](https://github.com/jfrog/research)
- [npm supply-chain alert — CISA](https://www.cisa.gov/news-events/alerts/2025/09/23/widespread-supply-chain-compromise-impacting-npm-ecosystem)

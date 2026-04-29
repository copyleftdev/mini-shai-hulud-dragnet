# Methodology

How the Mini Shai-Hulud dragnet was performed.

## Tooling

| Tool | Role |
|---|---|
| `gh` (GitHub CLI) | Search & metadata API access |
| `jq` | JSONL transformation |
| `kraken` | GitHub identity-graph spider (per-seed contributor mapping, email, affiliation) |
| `hunter` | Per-account joint-test scoring against known star-farm operator anchor sets (lifecycle / graph / identity / temporal axes) |
| `vajra` | Structural triage of JSON populations; cluster, anomaly, invariant, drift |
| `ariadne` | Per-repo content-laundering verdict (n/a for this incident — dropboxes are fresh, not laundered) |
| `entropyx` | Authorship-dynamics scan (n/a for this incident — dropboxes are 1-2 files) |

Orchestration: a custom **op-recon** playbook orchestrates the above, bridging GitHub Code Search with the joint-test scoring pipeline.

## Step-by-step

### 1. Marker enumeration

GitHub Search API: `q='"A Mini Shai-Hulud has Appeared" in:description'`. The total_count exceeded 1,000 — the API hard cap. Bypassed by partitioning the query on `created:` ranges per UTC hour, then deduplicating on repo `id`.

```bash
for h in 10 11 12 13 14 15 16 17; do
  for page in 1 2 3 4 5; do
    gh api -X GET search/repositories \
       -f q="\"A Mini Shai-Hulud has Appeared\" in:description created:2026-04-29T${h}:00..2026-04-29T$((h+1)):00" \
       -f per_page=100 -F page=$page
  done
done | jq -s 'unique_by(.id)'
```

Result: **1,117 unique dropbox repositories** across **22 unique owner accounts**.

### 2. Per-victim profile enrichment

For each unique owner login, pull GitHub user profile (`gh api users/{login}`). Capture `created_at`, `followers`, `following`, `public_repos`, `company`, `location`, `email`, `bio`, `name`. Cluster on `company` and inferred location to surface corporate / industry compromises.

### 3. Burst-rate aggregation

Per-owner aggregate:

```jq
group_by(.owner.login) | map({
  owner: .[0].owner.login,
  repo_count: length,
  first_drop: ([.[].created_at] | min),
  last_drop: ([.[].created_at] | max),
  span_seconds: ((last - first) | as_seconds),
  repos_per_min: (length * 60 / span_seconds),
  total_size_kb: ([.[].size] | add),
  median_size: ([.[].size] | sort | .[length/2|floor])
})
```

This produces the coordinates for the archetype clustering.

### 4. Hunter star-farm rule-out

Run `hunter score <login> --anchors-dir <11_known_operators> --identity` on the four highest-volume accounts. Expectation: hunter is calibrated for star-farm operators (synthetic identities pre-positioned over years); a PAT-theft worm should NOT flag.

Result: all four leads return `flagged: false` across all 11 anchor sets, `cohort: OTHER`, 0 anchor hits, 0 stars, 0 keys. **Confirms surface accounts are real, not synthetic.** The compromise vector is PAT theft via npm `preinstall`, not pre-positioned synthetic identities.

### 5. Identity-graph spider (kraken)

`kraken CloudMTABot -d 1 --max-users 30 --max-repos 10` on the suspected primary npm-publisher compromise (`CloudMTABot`).

Output: 30-user contributor network with corporate-email attribution. Surfaced 15+ `@sap.com` employees as the IR-notification target list (CloudMTABot's collaborator graph is the SAP Cloud Foundry / CAP maintainer team).

### 6. Exfil-time forensics

Each dropbox contains files named `results-{unix_ms}-N.json`. Extract the unix timestamp, compute drift against repo creation:

```bash
ts_ms=$(echo "$fname" | sed -n 's/results-\([0-9]*\)-.*/\1/p')
exfil_at_s=$((ts_ms / 1000))
created_at_s=$(date -u -d "$repo_created" +%s)
drift=$(( exfil_at_s - created_at_s ))
```

Result on 45-envelope sample: median drift 5 s, p25 2 s, p75 12 s, p99 299 s, **zero negative drifts**. Implication: harvest → create dropbox → upload is a single unbroken automated chain on the victim machine. No batching.

### 7. Cross-campaign pivot

Cross-reference the marker `"A Mini Shai-Hulud has Appeared"` with other current campaigns. Found one residual repo from `"Checkmarx Configuration Storage"` (the April 22 KICS attack) using the same Dune-vocabulary repo regex. Same C2, same Bun runtime, same workflow injection. Bridges the two campaigns to a single actor: **TeamPCP**.

Attribution source: `harekrishnarai/software-supply-chain-monitor/attacks/2026-04-checkmarx-kics-docker-vscode.md` — TeamPCP X/Twitter quote on 2026-04-22.

### 8. Vajra structural triage

Vajra runs information-theoretic invariant discovery on the per-owner aggregate.

Strongest invariants:
- `repo_count ↔ repos_per_min` — **strength 0.896**. Compromise scales with automation: high-volume CI compromises burst fast; sparse manual workflows burst slow.
- `median_size ↔ total_size_kb` — strength 0.792. Per-bundle harvest size is consistent within a victim.
- `median_size ↔ repo_count` — strength 0.452 (weak). Per-machine credential density is loosely correlated with how many distinct dropboxes the worm produced.

### 9. Social-graph negative finding

Pairwise intersection of follower / following sets across the top-6 victim accounts. Result: **zero overlap.** The worm has no social-vector amplification; each victim is an independent node compromised purely through `npm install` consumption.

### 10. Privacy guardrail

Corporate / infrastructure compromises are disclosed by org name (consistent with industry IR practice — StepSecurity, Aikido, JFrog all publish `cap-bots` / `CloudMTABot`). Individual personal-victim accounts are retained in raw artefacts but redacted from `data/victims.jsonl`.

## Caveats

- **Decay artifact**: GitHub Trust & Safety actively removes dropboxes during the propagation window. The 1,117 figure is a conservative lower bound; the true count is higher.
- **Hunter calibration**: hunter is calibrated for star-farm operators. PAT-theft worms do not match its joint-rule shape. Read this as "hunter correctly excluded star-farm involvement," not as "hunter found nothing interesting."
- **Encrypted payload**: dropbox contents are AES-256-GCM-encrypted. Exfil-time analysis uses filename Unix-ms timestamps only; payload byte content is not decryptable from this dataset.
- **Subdomain DNS**: `audit.checkmarx.cx` resolves only during the exfil window; passive-DNS lookups at rest will show NXDOMAIN. The IP `94.154.172.43` is the ASN-attributed bulletproof host, sourced via the kraven-security IOC bundle.

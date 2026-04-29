# SEO submission — accelerate first crawl

Tracking which crawlers have been notified and what manual steps remain.

## Already submitted (automated)

### IndexNow ✅
Notified all participating crawlers in one shot. Bing, Yandex, Naver, and Seznam pull from the IndexNow ecosystem — no per-engine submission needed for these.

| Endpoint | HTTP | Result |
|---|---|---|
| `api.indexnow.org/indexnow` | 202 | Accepted (queued, fans out to Bing / Yandex / Naver / Seznam) |
| `www.bing.com/indexnow` | 200 | OK (Bing accepted directly, key validated) |
| `yandex.com/indexnow` | 202 | Success (`{"success":true}`) |

Key file lives at: `https://copyleftdev.github.io/mini-shai-hulud-dragnet/<KEY>.txt`
(See `.indexnow-key` in repo root for the actual key — do not delete this file or the keyfile.)

### Re-submission script

When new content lands or you want to re-ping crawlers:

```bash
cd /home/ops/Project/chai_check/mini-shai-hulud-dragnet
KEY=$(cat .indexnow-key | tr -d '\n')
curl -X POST "https://api.indexnow.org/indexnow" \
  -H "Content-Type: application/json" \
  -d "{\"host\":\"copyleftdev.github.io\",\"key\":\"$KEY\",\"keyLocation\":\"https://copyleftdev.github.io/mini-shai-hulud-dragnet/$KEY.txt\",\"urlList\":[\"https://copyleftdev.github.io/mini-shai-hulud-dragnet/\"]}"
```

(`scripts/indexnow.sh` is also provided.)

---

## Manual: Google Search Console (5 min, interactive)

Google's Indexing API requires OAuth + service account, and the legacy `/ping?sitemap=` endpoint was deprecated June 2023. The fastest path is GSC.

1. Sign in: https://search.google.com/search-console
2. **Add property** → **URL prefix** → enter: `https://copyleftdev.github.io/mini-shai-hulud-dragnet/`
3. **Verify ownership.** Pick one method:
   - **HTML file**: Google gives you `googleXXXXXXXXX.html`. Save it to repo root, commit, push, then click **Verify**.
   - **HTML tag**: Google gives you `<meta name="google-site-verification" content="..." />`. Add to the `<head>` of `docs/index.html` (see "Verification meta-tag block" below), commit, push, click **Verify**.
4. Once verified: **Sitemaps** → enter `sitemap.xml` → **Submit**.
5. Optionally: **URL Inspection** → enter the dashboard URL → **Request Indexing** for instant push.

GSC will start showing impressions / queries within 24-72 hours.

---

## Manual: Bing Webmaster Tools (3 min, optional — IndexNow already covers Bing)

**You can skip this** — IndexNow already submitted to Bing and the URLs are queued. But BWT gives you analytics dashboards, crawl-error reports, and SEO health checks.

1. Sign in: https://www.bing.com/webmasters
2. **Import from Google Search Console** (one-click if GSC is set up), OR add property manually:
3. **Add a Site** → enter: `https://copyleftdev.github.io/mini-shai-hulud-dragnet/`
4. Verify ownership via:
   - `BingSiteAuth.xml` file at repo root, OR
   - Meta tag `<meta name="msvalidate.01" content="..." />` in `docs/index.html`
5. **Sitemaps** → submit `https://copyleftdev.github.io/mini-shai-hulud-dragnet/sitemap.xml`

---

## Verification meta-tag block (drop into docs/index.html when you have the values)

Find the `<!-- Open Graph -->` comment near the top of `docs/index.html` and paste these meta tags BEFORE it:

```html
<!-- Search engine verification (replace placeholder with values from GSC / BWT / Yandex) -->
<meta name="google-site-verification" content="YOUR_GOOGLE_VERIFICATION_TOKEN">
<meta name="msvalidate.01" content="YOUR_BING_VERIFICATION_TOKEN">
<meta name="yandex-verification" content="YOUR_YANDEX_VERIFICATION_TOKEN">
```

Commit, push, then click "Verify" in each console.

---

## Other useful submissions

| Service | URL | What it does |
|---|---|---|
| **OTX (AlienVault)** | https://otx.alienvault.com/ | Submit a Pulse with the IOCs from `data/iocs.jsonl`. Free; your IOCs become discoverable in their threat-intel feed. |
| **abuse.ch ThreatFox** | https://threatfox.abuse.ch/ | Submit IOCs (domains, IPs, hashes). Also feeds the wider threat-intel ecosystem (sam-caldwell mirrors ThreatFox in `samcaldwell-info/data/cybersecurity/cache/`). |
| **MalwareBazaar** | https://bazaar.abuse.ch/ | If you obtain payload samples (we don't ship the malware itself in this repo). |
| **VirusTotal Graph** | https://www.virustotal.com/graph/ | Build a public graph from the campaign IOCs. Becomes a citable artifact. |
| **Spamhaus DBL** | https://www.spamhaus.org/lookup/ | Report `audit.checkmarx.cx` and `94.154.172.43` if not already listed. |
| **GitHub Topics page** | https://github.com/topics/mini-shai-hulud | Once tagged (already done), the repo appears here. |

## Common Crawl

Common Crawl picks up indexed pages on its monthly cadence and ML training corpora pull from Common Crawl. Make sure `robots.txt` allows `CCBot` (already done in this repo).

Confirm: `curl -sL https://copyleftdev.github.io/mini-shai-hulud-dragnet/robots.txt | grep CCBot`.

## RSS / Atom (optional)

Want to publish a feed of new dragnet entries? Add `data/feed.xml` and link it in `<head>`. Useful if you turn this into a recurring threat-intel publication.

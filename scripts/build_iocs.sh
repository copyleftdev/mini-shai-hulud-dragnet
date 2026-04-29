#!/bin/bash
cat <<'IOCS'
{"type":"ioc","kind":"package","registry":"npm","name":"mbt","version":"1.2.48","status":"trojaned","campaign":"mini-shai-hulud","actor":"TeamPCP","source":"stepsecurity","first_observed":"2026-04-29"}
{"type":"ioc","kind":"package","registry":"npm","name":"@cap-js/sqlite","version":"2.2.2","status":"trojaned","campaign":"mini-shai-hulud","actor":"TeamPCP","source":"stepsecurity","first_observed":"2026-04-29"}
{"type":"ioc","kind":"package","registry":"npm","name":"@cap-js/postgres","version":"2.2.2","status":"trojaned","campaign":"mini-shai-hulud","actor":"TeamPCP","source":"stepsecurity","first_observed":"2026-04-29"}
{"type":"ioc","kind":"package","registry":"npm","name":"@cap-js/db-service","version":"2.10.1","status":"trojaned","campaign":"mini-shai-hulud","actor":"TeamPCP","source":"stepsecurity","first_observed":"2026-04-29"}
{"type":"ioc","kind":"package","registry":"npm","name":"@bitwarden/cli","version":"2026.4.0","status":"trojaned","campaign":"mini-shai-hulud","actor":"TeamPCP","source":"aikido","first_observed":"2026-04-29"}
{"type":"ioc","kind":"package","registry":"docker","name":"checkmarx/kics","version":"v2.1.20","status":"trojaned","campaign":"checkmarx-kics-vsx-2026-04","actor":"TeamPCP","source":"harekrishnarai","first_observed":"2026-04-22"}
{"type":"ioc","kind":"package","registry":"docker","name":"checkmarx/kics","version":"v2.1.21","status":"trojaned","campaign":"checkmarx-kics-vsx-2026-04","actor":"TeamPCP","source":"harekrishnarai","first_observed":"2026-04-22"}
{"type":"ioc","kind":"package","registry":"vscode","name":"checkmarx/cx-dev-assist","version":"1.17.0","status":"trojaned","campaign":"checkmarx-kics-vsx-2026-04","actor":"TeamPCP","source":"harekrishnarai","first_observed":"2026-04-22"}
{"type":"ioc","kind":"package","registry":"vscode","name":"checkmarx/cx-dev-assist","version":"1.19.0","status":"trojaned","campaign":"checkmarx-kics-vsx-2026-04","actor":"TeamPCP","source":"harekrishnarai","first_observed":"2026-04-22"}
{"type":"ioc","kind":"package","registry":"vscode","name":"checkmarx/ast-results","version":"2.63.0","status":"trojaned","campaign":"checkmarx-kics-vsx-2026-04","actor":"TeamPCP","source":"harekrishnarai","first_observed":"2026-04-22"}
{"type":"ioc","kind":"package","registry":"vscode","name":"checkmarx/ast-results","version":"2.66.0","status":"trojaned","campaign":"checkmarx-kics-vsx-2026-04","actor":"TeamPCP","source":"harekrishnarai","first_observed":"2026-04-22"}
{"type":"ioc","kind":"domain","value":"audit.checkmarx.cx","role":"c2_exfil","campaign":"mini-shai-hulud","actor":"TeamPCP","source":"kraven-security","notes":"typosquat of legit checkmarx.com","first_seen":"2026-04-23"}
{"type":"ioc","kind":"domain","value":"checkmarx.cx","role":"c2_apex","campaign":"mini-shai-hulud","actor":"TeamPCP","source":"whois","registrar":"CentralNic Ltd","nameservers":["ns1.dnsowl.com","ns2.dnsowl.com","ns3.dnsowl.com"],"updated":"2026-04-23","first_seen":"2026-04-23"}
{"type":"ioc","kind":"ipv4","value":"94.154.172.43","role":"c2_resolver","asn":"AS209101","org":"IP Vendetta Inc.","country":"SC","city":"Victoria","campaign":"mini-shai-hulud","actor":"TeamPCP","source":"ipapi","notes":"offshore bulletproof hosting"}
{"type":"ioc","kind":"url","value":"https://audit.checkmarx.cx/v1/telemetry","role":"c2_endpoint","campaign":"mini-shai-hulud","actor":"TeamPCP","source":"kraven-security"}
{"type":"ioc","kind":"sha256","value":"4066781fa830224c8bbcc3aa005a396657f9c8f9016f9a64ad44a9d7f5f45e34","artifact":"setup.mjs","role":"loader","campaign":"mini-shai-hulud","actor":"TeamPCP","source":"stepsecurity"}
{"type":"ioc","kind":"sha256","value":"80a3d2877813968ef847ae73b5eeeb70b9435254e74d7f07d8cf4057f0a710ac","artifact":"execution.js","registry":"npm","package":"mbt","version":"1.2.48","role":"payload","campaign":"mini-shai-hulud","actor":"TeamPCP","source":"stepsecurity"}
{"type":"ioc","kind":"sha256","value":"6f933d00b7d05678eb43c90963a80b8947c4ae6830182f89df31da9f568fea95","artifact":"execution.js","registry":"npm","package":"@cap-js/sqlite","version":"2.2.2","role":"payload","campaign":"mini-shai-hulud","actor":"TeamPCP","source":"stepsecurity"}
{"type":"ioc","kind":"sha256","value":"18f784b3bc9a0bcdcb1a8d7f51bc5f54323fc40cbd874119354ab609bef6e4cb","role":"payload_variant","campaign":"mini-shai-hulud","actor":"TeamPCP","source":"kraven-security"}
{"type":"ioc","kind":"sha256","value":"8605e365edf11160aad517c7d79a3b26b62290e5072ef97b102a01ddbb343f14","role":"payload_variant","campaign":"mini-shai-hulud","actor":"TeamPCP","source":"kraven-security"}
{"type":"ioc","kind":"sha256","value":"167ce57ef59a32a6a0ef4137785828077879092d7f83ddbc1755d6e69116e0ad","role":"payload_variant","campaign":"mini-shai-hulud","actor":"TeamPCP","source":"kraven-security"}
{"type":"ioc","kind":"sha256","value":"2a6a35f06118ff7d61bfd36a5788557b695095e7c9a609b4a01956883f146f50","artifact":"kics_elf","registry":"docker","package":"checkmarx/kics","role":"payload","campaign":"checkmarx-kics-vsx-2026-04","actor":"TeamPCP","source":"harekrishnarai"}
{"type":"ioc","kind":"sha256","value":"24680027afadea90c7c713821e214b15cb6c922e67ac01109fb1edb3ee4741d9","artifact":"mcpAddon.js","role":"payload","campaign":"checkmarx-kics-vsx-2026-04","actor":"TeamPCP","source":"harekrishnarai"}
{"type":"ioc","kind":"crypto_key","value":"5012caa5847ae9261dfa16f91417042f367d6bed149c3b8af7a50b203a093007","kind_detail":"pbkdf2_master","campaign":"mini-shai-hulud","actor":"TeamPCP","source":"stepsecurity"}
{"type":"ioc","kind":"crypto_salt","value":"ctf-scramble-v2","campaign":"mini-shai-hulud","actor":"TeamPCP","source":"stepsecurity"}
{"type":"ioc","kind":"github_account","value":"CloudMTABot","role":"compromised_npm_publisher","email":"cloudmtabot@gmail.com","verdict":"legitimate_account_PAT_stolen","campaign":"mini-shai-hulud","actor":"TeamPCP"}
{"type":"ioc","kind":"github_account","value":"cap-bots","role":"compromised_npm_publisher","org":"@cap-js","verdict":"legitimate_account_PAT_stolen","campaign":"mini-shai-hulud","actor":"TeamPCP"}
{"type":"ioc","kind":"string","value":"A Mini Shai-Hulud has Appeared","role":"dropbox_description_marker","campaign":"mini-shai-hulud","actor":"TeamPCP","source":"github_search"}
{"type":"ioc","kind":"string","value":"Checkmarx Configuration Storage","role":"dropbox_description_marker","campaign":"checkmarx-kics-vsx-2026-04","actor":"TeamPCP","source":"github_search"}
{"type":"ioc","kind":"string","value":"beautifulcastle","role":"persistence_commit_marker","campaign":"mini-shai-hulud","actor":"TeamPCP","source":"kraven-security","notes":"prefix to base64-encoded c2 url + victim token"}
{"type":"ioc","kind":"string","value":"LongLiveTheResistanceAgainstMachines","role":"persistence_commit_marker","campaign":"teampcp-multi","actor":"TeamPCP","source":"kraven-security"}
{"type":"ioc","kind":"string","value":"Exiting as russian language detected!","role":"geo_evasion_log","campaign":"mini-shai-hulud","actor":"TeamPCP","source":"stepsecurity"}
{"type":"ioc","kind":"string","value":"__DAEMONIZED","role":"runtime_flag","campaign":"mini-shai-hulud","actor":"TeamPCP","source":"stepsecurity"}
{"type":"ioc","kind":"regex","value":"/gh[op]_[A-Za-z0-9]{36}/g","role":"github_pat_extraction","campaign":"mini-shai-hulud","actor":"TeamPCP","source":"stepsecurity"}
{"type":"ioc","kind":"regex","value":"/npm_[A-Za-z0-9]{36,}/g","role":"npm_token_extraction","campaign":"mini-shai-hulud","actor":"TeamPCP","source":"stepsecurity"}
{"type":"ioc","kind":"regex","value":"(sardaukar|mentat|fremen|atreides|harkonnen|gesserit|prescient|fedaykin|tleilaxu|siridar|kanly|sayyadina|ghola|powindah|prana|kralizec)-(sandworm|ornithopter|heighliner|stillsuit|lasgun|sietch|melange|thumper|navigator|fedaykin|futar|slig|phibian|laza|cogitor|ghola)-\\d{1,3}","role":"dropbox_repo_naming","campaign":"mini-shai-hulud","actor":"TeamPCP","source":"stepsecurity"}
{"type":"ioc","kind":"file_path","value":".vscode/tasks.json","role":"persistence","property":"runOn:folderOpen","campaign":"mini-shai-hulud","actor":"TeamPCP","source":"stepsecurity"}
{"type":"ioc","kind":"file_path","value":".claude/settings.json","role":"persistence","property":"SessionStart_hook","campaign":"mini-shai-hulud","actor":"TeamPCP","source":"stepsecurity"}
{"type":"ioc","kind":"file_path","value":".claude/execution.js","role":"persistence_payload_copy","campaign":"mini-shai-hulud","actor":"TeamPCP","source":"stepsecurity"}
{"type":"ioc","kind":"file_path","value":".claude/setup.mjs","role":"persistence_loader_copy","campaign":"mini-shai-hulud","actor":"TeamPCP","source":"stepsecurity"}
{"type":"ioc","kind":"file_path","value":".vscode/setup.mjs","role":"persistence_loader_copy","campaign":"mini-shai-hulud","actor":"TeamPCP","source":"stepsecurity"}
{"type":"ioc","kind":"file_path","value":".github/workflows/format-check.yml","role":"workflow_injection","campaign":"mini-shai-hulud","actor":"TeamPCP","source":"stepsecurity"}
{"type":"ioc","kind":"file_path","value":"~/.checkmarx/mcp/mcpAddon.js","role":"persistence","campaign":"checkmarx-kics-vsx-2026-04","actor":"TeamPCP","source":"harekrishnarai"}
{"type":"ioc","kind":"author_email","value":"claude@users.noreply.github.com","role":"spoofed_commit_author","campaign":"mini-shai-hulud","actor":"TeamPCP","source":"stepsecurity"}
{"type":"ioc","kind":"author_email","value":"dependabot[bot]@users.noreply.github.com","role":"spoofed_commit_author","campaign":"mini-shai-hulud","actor":"TeamPCP","source":"stepsecurity"}
{"type":"ioc","kind":"git_branch","value":"dependabout/github_actions/format/setup-formatter","role":"workflow_injection_branch","campaign":"mini-shai-hulud","actor":"TeamPCP","source":"stepsecurity"}
{"type":"ioc","kind":"runtime","value":"oven-sh/bun@1.3.13","role":"sandbox_evasion","url":"https://github.com/oven-sh/bun/releases/download/bun-v1.3.13/","campaign":"mini-shai-hulud","actor":"TeamPCP","source":"stepsecurity"}
IOCS

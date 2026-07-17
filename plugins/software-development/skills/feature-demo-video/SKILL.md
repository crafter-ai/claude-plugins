---
name: feature-demo-video
description: >
  Record a feature demo video by driving a web app with the Playwright MCP browser, with
  step-by-step subtitles, producing three artifacts in the machine's /tmp: raw video (.webm),
  subtitle file (.srt), and a burnt-in-subtitle video. Use whenever the user asks to "record a
  video" of a flow, a video demo for a PR/ticket, a recorded E2E test, subtitles on a test video,
  or to regenerate/speed-up/re-subtitle an existing demo video. Also covers the environment
  unlocks required (MCP recording config + reconnect, ffmpeg).
---

# Feature demo video (Playwright MCP + subtitles)

Goal: record a real flow in the app (real browser via Playwright MCP), generate subtitles
indicating each step, and leave separate artifacts so the dev can iterate later (change subtitle
text, change speed, etc.) without re-recording.

**Language rule: default to Brazilian Portuguese for all generated user-facing text** — subtitle
labels, step descriptions, file summaries reported back to the user. This skill file is in
English, but that's just the file; match the video's language to whoever will actually watch it.
If a project's own conventions say otherwise (e.g. an English-speaking team), follow those
instead.

## Artifacts (always these three, kept separate)

Create everything under `/tmp/<slug>-video/` (the machine's `/tmp` — nothing lands in the repo;
artifacts are ephemeral by design and vanish on reboot, which is fine since sharing happens right
away).

**Deriving `<slug>`: tool-agnostic, ticket-first.** Look for an issue/ticket identifier tied to
the current branch or PR — regardless of which tracker it comes from (Linear `ABC-123`, Jira
`PROJ-456`, a GitHub issue number `123` or `gh-123`, etc.) — and use it, lowercased, as the slug.
Branch names usually embed it (`feature/abc-123-checkout-fix`, `123-fix-login-bug`); check there
first. If no identifier pattern is found, fall back to a slugified branch name or PR title. Example
for a branch `feature/proj-123-recurring-billing`:

```
/tmp/proj-123-video/
├── steps.log        # raw timestamps (epoch|label) — input to regenerate subtitles
├── demo.webm        # raw video, original speed, NO subtitles
├── demo.srt         # subtitles, original-speed timings
└── demo-legendado.webm  # burnt-in subtitles (ready to attach to a PR)
```

(`demo-legendado.webm` keeps the Portuguese name — "subtitled" — as the default artifact name;
rename it if the project's language convention differs.)

Keeping the three separate is a requirement, not an optimization: the dev may ask "change the
text of step 4", "make a 3x version", "just the clean video" — each request uses a different
artifact as its source without reprocessing the others. Speed variants get a suffix
(`demo-3x.webm` + `demo-3x.srt`, `demo-6x-legendado.webm`).

## Phase 0 — Unlocks (do BEFORE planning the flow)

### 1. Video recording in the Playwright MCP (one-time setup, permanent)

`@playwright/mcp` (0.0.78) has **no `--save-video` flag** — inventing flags makes the server fail
to boot and the reconnect fail with `-32000`. The supported path is a config file with
Playwright's native `contextOptions`. This skill ships that file:
[`playwright-mcp-video.json`](playwright-mcp-video.json) (records 1280x720 to
`/tmp/playwright-mcp-videos` — the machine's `/tmp`, so recordings never pollute the repo and get
wiped on reboot).

**Zero setup when installed as a plugin**: this plugin bundles a `playwright` MCP server (see the
plugin's `.mcp.json`) that already boots with this config — recording is on whenever the browser
is driven through the plugin's playwright tools. If those tools are available, skip to Phase 0.2.

**If using a standalone playwright MCP server instead**, check whether it's already wired: look at
the `playwright` server args in `~/.claude.json` (`mcpServers.playwright.args`). If they already
include `--config=...playwright-mcp-video.json`, recording is live — skip to Phase 0.2, no
reconnect needed. This setup is permanent by design: every session records to `/tmp` at negligible
cost, and in exchange no future demo needs the manual reconnect dance.

If not wired yet, add to the args (the config path is inside the installed plugin — resolve
`${CLAUDE_PLUGIN_ROOT}` to this skill's parent plugin directory):

```
--config=${CLAUDE_PLUGIN_ROOT}/skills/feature-demo-video/playwright-mcp-video.json
--output-dir=/tmp/playwright-mcp-videos
--output-max-size=2000000000
```

(`--output-max-size` auto-evicts old output files so `/tmp` doesn't grow unbounded.)

**The MCP server does not hot-reload config.** After editing, validate that it boots with the new
args BEFORE involving the user — a test boot guarantees a single reconnect:

```bash
timeout 8 npx @playwright/mcp@0.0.78 <new args> <<'EOF'
{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}}}
EOF
# must answer a JSON with serverInfo and exit 0
```

Only then ask the user to run `/mcp` and reconnect **playwright**. That is their action — you
cannot reconnect it yourself. This happens once per machine, not once per demo.

### 2. ffmpeg

Not installed by default; needed for duration probing, sync validation, subtitle burning, and
speed-ups: `sudo apt-get install -y ffmpeg` (unsandboxed).

Also check the Playwright browser binary: if the MCP server errors on first navigation with a
missing-browser message, run `npx playwright install chromium` (add `--with-deps` on a fresh
Linux box).

### 3. Server and data

- Start the project's dev server **unsandboxed** so the MCP browser can reach it — check whether
  the project already has its own skill, doc, or script for this (env quirks, ports, seed data,
  multi-tenant/subdomain routing, etc.) and follow that first.
- Prepare data BEFORE recording (test users/credentials, and a scenario that actually demonstrates
  the fix — e.g. for a multi-account bug, an account with 2+ sub-entities where the target one is
  NOT the one a naive fallback would pick).

## Phase 1 — Record

Recorder rules that shape the script:

- **One `.webm` per page.** Plan the whole flow in a single page/tab. Closing the page
  (`browser_close`) finalizes the file.
- **The browser profile persists** across MCP reconnects — a logged-in session from earlier work
  contaminates the recording. Start with: clear cookies (`page.context().clearCookies()` via
  `browser_run_code_unsafe`), close the page, note which `.webm` files already exist in
  `/tmp/playwright-mcp-videos` (recording is always on, so old ones linger), and ONLY THEN
  navigate (new page = clean new video).
- **Timestamp before each step.** Immediately before each action that becomes a subtitle:

  ```bash
  echo "$(date +%s.%N)|<step label>" >> /tmp/<slug>-video/steps.log
  ```

  Labels are the literal subtitles — write them for the person watching ("App opened on company
  X, the one already being viewed"), not as machine logs. Match the language rule above.
- **Deliberate pauses, sized to the subtitle, not a flat number.** The video only shows what
  stayed on screen, and a flat 2-3s hold either cuts off long labels before they're readable or
  sits as dead air after short ones. After each proof moment (expected result visible), hold for
  `max(2, chars/16 + 1)` seconds with `browser_wait_for`, where `chars` is the length of that
  step's subtitle text (16 cps ≈ comfortable reading speed for Portuguese; adjust down a bit for
  denser languages, up for sparser ones — +1s floor to register the screen before moving on). A
  40-char label needs ~3.5s; an 80-char one needs ~6s. If a step's proof needs longer than that to
  register (e.g. waiting on a background job), the extra time is real content, not padding — don't
  shrink it to fit the formula.
- App click gotchas: dismiss any cookie-consent/overlay banner before clicking through it, and
  watch for fixed headers/toolbars covering the target element — if a click times out with
  "subtree intercepts pointer events", submit the underlying action via JS (e.g.
  `btn.closest('form').requestSubmit()`) with `browser_run_code_unsafe`.
- Close the browser when done. The time between the end of the flow and `browser_close` is also
  recorded — don't linger.
- After `browser_close`, identify the newly created `.webm` in `/tmp/playwright-mcp-videos`
  (newest mtime) and **copy it to `/tmp/<slug>-video/demo.webm`** — the per-slug folder is the
  working set for iteration; the recorder's own folder gets auto-evicted.

## Phase 2 — Subtitles (.srt)

**Sync: video time ≈ wall-clock offset from the FIRST step, 1:1.** The recorder does not compress
idle time. Two known traps:

- **Do not anchor on the close time**: the agent's "thinking" time between `browser_close` and any
  later measurement inflates the end epoch by tens of seconds.
- **Validate before delivering**: `ffprobe` for the duration, and scene detection to check 2–3
  major transitions (page changes) against the offsets in `steps.log`:

  ```bash
  ffmpeg -i demo.webm -vf "select='gt(scene,0.25)',showinfo" -f null - 2>&1 | grep -oP "pts_time:\K[0-9.]+"
  ```

Generate the SRT with a script: each subtitle runs from its step's offset to the next step's
offset; the last one ends at the video duration; a step logged after the video ended (final
marker) gets anchored to the last ~3s. SRT time format: `HH:MM:SS,mmm`.

## Phase 3 — Variants (burnt-in and sped-up)

Always start from the original `demo.webm` (avoids chained re-encodes). The trick that avoids
recomputing timings: apply `subtitles=` BEFORE `setpts=` in the filter chain — subtitles are
burnt using the original timestamps and the speed-up happens afterwards:

```bash
# burnt-in subtitles, original speed
ffmpeg -y -i demo.webm -vf "subtitles=demo.srt:force_style='FontSize=16,Bold=1,Outline=1'" \
  -an -c:v libvpx -b:v 2M demo-legendado.webm

# Nx speed variant with burnt-in subtitles (same source, same srt)
ffmpeg -y -i demo.webm -vf "subtitles=demo.srt:force_style='FontSize=16,Bold=1,Outline=1',setpts=PTS/N" \
  -an -c:v libvpx -b:v 2M demo-Nx-legendado.webm
```

For a sped-up variant WITH a separate `.srt` (not burnt), also generate the SRT with all times
divided by N. Reference point: 3x turns a ~6min flow into ~2min without hurting readability;
propose the factor based on idle time and confirm with the user if they didn't specify one. With
the pacing rule in Phase 1 applied at capture time, most flows won't need this at all — it's a
lever for flows with a lot of real interaction time (typing, page loads), not for fixing bad
pauses after the fact.

Validate the burn by extracting a frame at a subtitled moment and reading the image
(`ffmpeg -ss <t> -i demo-legendado.webm -frames:v 1 check.png`).

## Phase 4 — Delivery and cleanup

- **End the report with the explicit paths of the shareable artifacts**, in the video's language —
  the dev's next action is grabbing a file, so make it copy-paste ready. Point out which file is
  the "attach this one" default (usually `demo-legendado.webm` or the sped-up burnt-in variant)
  and list the others (raw video, .srt) as iteration sources, each with its duration.
- Remind that `/tmp` is wiped on reboot — if the demo matters beyond today, share/attach it now.
- Leave the MCP args in place — the recording setup is permanent (Phase 0.1); `/tmp` and
  `--output-max-size` handle cleanup.
- Stop the dev server.
- If the video is for a PR: inline attachment in the description often only works via
  drag-and-drop in the web UI (many trackers' APIs have no attachment upload) — give the dev the
  path to `demo-legendado.webm` (or the sped-up variant) to drag in.

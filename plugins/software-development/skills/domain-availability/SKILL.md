---
name: domain-availability
description: >
  Check whether a domain name is registered or available to buy, using RDAP over plain
  HTTPS/curl — no whois client or API key needed. Use whenever the user asks to check if a
  domain is available, look up whois for a domain, see if a .com/.io/.dev/etc is taken, or
  brainstorm/verify available names for a product or project. Covers a single quick check,
  bulk-checking many candidates and/or TLDs, and what to do when a TLD has no RDAP coverage.
---

# Domain availability check (RDAP over curl)

## Why RDAP, not WHOIS

Classic WHOIS is its own stateful protocol on port 43 — `curl` can't speak it directly.
RDAP (Registration Data Access Protocol) is WHOIS's standardized successor: plain HTTPS,
JSON responses, one registry per TLD. That's what makes this curl-able at all.

The signal is the HTTP status code alone — no need to parse the JSON body for a plain
available/taken check:

- **`200`** → registered. Body has registration/expiration dates, status flags, nameservers.
- **`404`** → not currently registered (i.e. available, with the caveats below).
- **connection failure / no route** → that TLD's registry doesn't expose RDAP; fall back
  (see "TLDs with no RDAP" below).

## Quick check, one domain

For **`.com` / `.net`** (Verisign is authoritative and fast, no redirect hop):

```bash
curl -s -o /dev/null -w "%{http_code}\n" "https://rdap.verisign.com/com/v1/domain/example.com"
```

For **any other TLD**, use `rdap.org` as a universal redirector — it looks up the right
registry from the TLD and 302s there. **Always follow the redirect with `-L`**; without it
you only learn that rdap.org resolved the TLD, not whether the domain is registered
(rdap.org itself returns 302 for both a taken and an available domain — the true 200/404
only shows up after following through to the registry):

```bash
curl -s -L -o /dev/null -w "%{http_code}\n" "https://rdap.org/domain/example.dev"
```

To see the actual registration details instead of just the code, drop `-o /dev/null` and
pipe through `jq`:

```bash
curl -s -L "https://rdap.org/domain/example.dev" | jq '{ldhName, status, events}'
```

## Bulk-checking many candidates

This skill ships [`scripts/check-domain.sh`](scripts/check-domain.sh) — pass any number of
domains (mixed TLDs are fine), it prints one line each and paces requests to avoid
tripping rate limits:

```bash
${CLAUDE_PLUGIN_ROOT}/skills/domain-availability/scripts/check-domain.sh rubylabs.com rubylabs.io rubylabs.dev
```

When brainstorming names for a product, generate the candidate list first (base name ×
the TLDs the user cares about, typically `.com` plus 1-2 alternates), then run the whole
batch through the script in one go rather than one-off curls — it's the same number of
requests either way, but the batched table is what the user actually wants to read.

## TLDs with no RDAP coverage

Not every registry publishes RDAP. Confirmed gaps include some ccTLDs (e.g. `.ar`, `.cl`
returned a connection failure through rdap.org as of 2026-08). When a lookup times out or
fails to connect rather than returning 200/404, don't report that as "available" — say
RDAP isn't available for that TLD and offer an alternative:

- A local `whois` binary, if installed (`whois example.ar`) — parses the legacy text
  format instead.
- The registrar's own lookup page/API (Namecheap, GoDaddy, Porkbun, the local ccTLD
  registry's own site) for a real purchase-availability signal.

## Caveats to mention alongside any result

- **`404` means "not currently registered," not "definitely purchasable."** A domain can
  sit in a pending-delete/redemption grace period after non-renewal and briefly reappear
  as available before it's truly droppable — this matters most for previously-owned or
  recently-expired names, not fresh ones.
- **`200` doesn't always mean "actively used."** Plenty of registered domains are parked,
  unused, or squatted — worth noting if the user's goal is "is anyone actually using
  this," which is a different question from "is it registered."
- **Rate limits are real.** RDAP servers throttle abusive polling; space out bulk checks
  (the bundled script already sleeps between requests) rather than firing dozens
  concurrently.
- For an actual purchase (not just a check), the registrar's own availability API is the
  ground truth — RDAP can occasionally lag a same-day registration/release by minutes.

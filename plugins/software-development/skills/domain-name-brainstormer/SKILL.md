---
name: domain-name-brainstormer
description: >
  Generate creative domain name candidates for a project, product, or personal brand, then
  check which ones are actually available across chosen TLDs (.com, .io, .dev, .ai, .app,
  etc.). Use whenever the user wants to brainstorm a domain name, name a new
  project/startup/side project, find alternatives because their first choice is taken, or
  needs a short/brandable/pronounceable name across several extensions at once.
license: Apache-2.0
source: >
  Adapted from ComposioHQ/awesome-claude-skills, skill "domain-name-brainstormer"
  (https://github.com/ComposioHQ/awesome-claude-skills/tree/master/domain-name-brainstormer),
  licensed Apache License 2.0. Adapted here to delegate the availability check to this
  plugin's own [[domain-availability]] skill instead of ad-hoc lookups.
---

# Domain name brainstormer

Two separate jobs, run in sequence: generate names worth wanting, then find out which of
them are actually free. Don't skip straight to checking — a list of available-but-forgettable
names isn't the point.

## 1. Understand the project before naming it

Before generating candidates, get (or infer from context already given):

- What it does, in one sentence — the thing the name should evoke or stay neutral to.
- Who it's for (developers, consumers, a specific niche) — shapes tone and TLD choice.
- Any constraints: keywords to include/avoid, target TLDs, length limit, existing brand to
  stay consistent with.

If the user's ask is already specific enough ("suggest .dev names for a code-snippet
sharing tool"), don't stall on this — just proceed with sensible defaults.

## 2. Generate candidates

Produce 10-15 candidates, spanning a few different naming strategies rather than variations
on one idea:

- **Descriptive**: says what it does (`snippetbox`, `codeclip`).
- **Evocative/brandable**: a real or invented word that suggests the domain without
  spelling it out (`vercel`, `linear`).
- **Compound**: two short, relevant words fused (`devpaste`, `sharecode`).
- **Keyword-anchored**: if the user gave specific words to use, build variants around them.

Naming qualities to optimize for, roughly in this order: short (under ~15 characters),
pronounceable out loud, easy to spell from hearing it once, no hyphens or numbers (both hurt
verbal/word-of-mouth sharing), and only as descriptive as it needs to be — brandable often
beats literal.

### TLD choice

Default to checking `.com` plus 1-2 alternates suited to the audience, unless the user
specifies otherwise:

| TLD | Fits |
|---|---|
| `.com` | universal default, always worth checking regardless of audience |
| `.io` | tech/developer tools, startups |
| `.dev` | developer-focused products specifically |
| `.ai` | AI/ML products |
| `.app` | mobile or web apps |
| `.co` | `.com`-unavailable fallback, still broadly trusted |
| `.xyz` | modern/creative/informal projects |

## 3. Check availability

Use this plugin's **[[domain-availability]]** skill for the actual lookups — it covers the
RDAP mechanics (curl, status codes, rate limits, TLDs with no RDAP coverage) so this skill
doesn't need to duplicate that. Concretely, build the candidate × TLD matrix and run it
through that skill's bundled script in one batch:

```bash
${CLAUDE_PLUGIN_ROOT}/skills/domain-availability/scripts/check-domain.sh \
  snippetbox.com snippetbox.io snippetbox.dev \
  codeclip.com codeclip.io \
  devpaste.com devpaste.dev
```

## 4. Present results

Group by status, not by candidate — the user is scanning for "what can I actually take,"
not re-reading the same name three times:

```
## Available
- snippet.dev — short, .dev signals developer tool, no hyphen
- codebox.io — clean, tech-forward

## Taken
- codeshare.com
- snippets.com

## Recommendation
snippet.dev — best fit: short, pronounceable, TLD matches the audience
```

For each available name, one line on *why* it works (audience fit, brevity, brandability) —
not just the checkmark. For taken names, no need to speculate on price; that's the
availability skill's/registrar's job, not this one's.

## 5. Iterate

If everything strong is taken, generate a second batch rather than stretching to weak
variations of the same root word — a fresh angle (different strategy from the list above,
or a different TLD) usually beats `name2`, `getname`, `myname` style fallbacks, which read
as second-choice to anyone who sees them.

## Related, not covered here

Once a name is picked: checking matching social-media handles, trademark conflicts, and
actually registering the domain are separate concerns this skill doesn't handle — flag them
as next steps rather than attempting them.

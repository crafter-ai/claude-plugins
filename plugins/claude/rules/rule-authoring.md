---
paths:
  - ".claude/rules/**/*.md"
---

# Writing and maintaining Claude rules

A rule's job is to tell a reviewer — human or AI — *where* to look harder,
not to teach them the underlying mechanism. Optimize for staying true over
time, not for completeness today. Length is the real cost: a skimmed fact
gets looked up, but a skimmed directive gets violated — every line added
weakens the ones already there.

- **Nudge, don't document:** state the failure mode and its consequence,
  not the code path that produces it. The mechanism belongs in code and
  tests, which is where a stale detail can't hide.
- **No code-level specifics that will drift:** avoid method/hook names,
  file paths, line numbers, error/event codes, file or call-site counts.
  A stale specific is worse than no specific — it actively misleads.
- **Flat bullets, not a table plus a separate legend:** `**Subject:**
  explanation`, capped at ~3 lines / ~80 chars. Most entries need one
  line — don't pad the obvious ones just to look consistent.
- **State cutoffs once, precisely, in wording reused everywhere:** a
  threshold restated two ways (">500" vs. "at or above 500", "less than
  90 days ago" read backwards) is a bug waiting to be found.
- **Verify a claim against the current codebase before writing it down:**
  a specific-sounding statement hasn't earned trust just by sounding
  precise.
- **Separate the nudge from the maintenance mechanics:** refresh
  procedures, SQL, and step-by-step instructions go in a linked doc named
  `docs/runbooks/claude-rule-*.md`, flagged "skip during code review" —
  not in the rule itself, which reloads on every matching file change.
- **Only add structure (tiers, categories) if it changes handling:** a
  split that doesn't change what a reviewer does with either side of it
  is taxonomy for its own sake.
- **Mirror `paths:` wherever the repo re-declares it:** if another review
  tool reads these rules through its own config (e.g. CodeRabbit's
  `filePatterns`), update both in the same change — or that tool silently
  stops applying a rule Claude still loads.
- **Scope `paths:` by what needs the concern, not by excluding what
  doesn't:** `app/**/*.rb` already leaves out `config/`/`lib/` without
  negation syntax.
- **When the concern is content- or usage-dependent, not
  directory-dependent, `paths:` can't be narrowed to match it — don't
  force it.** Lead with a one-line conditional check ("only relevant
  if...") and defer full guidance to a linked doc instead. Size the
  inline cost for the common case where the file doesn't trigger the
  concern, not the rare case where it does.
- **Keyword test — should this be a rule at all?** If a description with
  the obvious keywords would catch the need ("create a PR", "deploy", a
  file type), write a skill instead — rules are for needs with no
  conversation keyword, surfacing mid-task via the files being touched.
  Never encode the same policy in both a rule and a skill.

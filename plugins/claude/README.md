# Claude authoring rules

Rules about writing rules and skills — meta-guidelines that load when someone
edits `.claude/rules/*.md` or `.claude/skills/**/*.md` in a project.

They are not loaded from the plugin: Claude Code plugins can't ship
auto-loading rules, so `/claude:install-rules` copies them into the project's
`.claude/rules/claude/`, which the project commits.

## What's inside

- `rule-authoring.md` — rules are nudges for needs with no conversation
  keyword: no drift-prone code specifics, flat bullets, precise cutoffs,
  mechanics extracted to runbooks, and the keyword test for when the content
  should be a skill instead.
- `skill-authoring.md` — skills are procedures for needs that announce
  themselves: the description is the trigger, the last step performs the
  action, non-negotiables baked into commands, one home per policy.

The two files cross-reference the same boundary from both sides: keyword
detectable → skill; file-touch signal only → rule; triggers on nothing →
CLAUDE.md.

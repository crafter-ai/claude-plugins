---
paths:
  - ".claude/skills/**/*.md"
---

# Writing and maintaining skills

Skills are procedural — how to do one specific thing. They load by
matching their description against the conversation, so they fit needs
that announce themselves (a task verb, a tool or service name, a file
type). Policy goes in the description; procedure goes in the body.

- **The description is the trigger:** without one, the skill is reachable
  only as a typed slash command. State what it does + when to use it,
  listing the phrasings users actually say — in every language your team
  writes in.
- **No procedure, no skill:** a one-line policy makes a body that just
  repeats its description — put it in a rule (if a file-touch signal
  exists) or CLAUDE.md instead.
- **Finish the task:** the last step performs the action, not a handoff.
  Conventions die in the manual gap between a skill that prepares and a
  human step that executes.
- **Bake non-negotiables into the commands:** a mandatory flag belongs in
  the command line the skill runs, not only in prose above it.
- **Compose, don't duplicate:** when another skill owns part of the job,
  invoke it — a copied procedure drifts from its source.
- **Ask only real questions:** pause for genuine user decisions; don't
  confirm what the skill can determine itself.
- **Verify every command, path, and name against the repo before writing
  it down** — same bar as rules.
- **One home per policy:** never encode the same policy in both a skill
  and a rule — two places to maintain, and they drift.

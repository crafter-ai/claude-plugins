---
description: Copy this plugin's Rails coding rules into the project's or user's .claude/rules/ so they auto-load by file path
argument-hint: "[project|user]"
---

Install (or update) the Ruby on Rails coding rules from this plugin as Claude Code rules.

Plugins can't ship auto-loading rules, so this command copies them out of the plugin into a `.claude/rules/` directory, where Claude Code loads them lazily based on their `paths:` globs.

## Pick the scope

Parse `$ARGUMENTS`:

- `project` → target `.claude/rules/ruby-on-rails/` in the current project root. Rules apply only to this project; the project commits them so the whole team gets them.
- `user` → target `~/.claude/rules/ruby-on-rails/`. Rules apply to every project you work in on this machine; nothing to commit.
- Anything else (including no argument): ask the user which scope they want, briefly explaining the difference above, before doing anything.

Don't install to both scopes in the same run — if the user wants both, run the command twice.

Steps:

1. Locate the plugin's `rules/` directory at `${CLAUDE_PLUGIN_ROOT}/rules/`. If that variable was not substituted (it appears literally above), find the newest installed version under `~/.claude/plugins/cache/crafter-ai/ruby-on-rails/*/rules/`.
2. Resolve the target directory per the scope picked above (project root's `.claude/rules/ruby-on-rails/`, or `~/.claude/rules/ruby-on-rails/`).
3. If the target directory does not exist: create it and copy all `*.md` files from the plugin's `rules/` directory into it.
4. If it already exists: diff the existing files against the plugin's versions first. If there are local modifications, show the user a summary of what would change and ask before overwriting. Otherwise replace the directory contents (including deleting rule files that no longer exist in the plugin).
5. Confirm the result: list the installed rule files, the path globs each one applies to (from their frontmatter), and which scope they were installed at.
6. If scope was `project`: remind the user to commit `.claude/rules/ruby-on-rails/` so the whole team gets the rules. If scope was `user`: note that no commit is needed since it applies machine-wide. Either way, mention that re-running this command after a plugin update pulls in rule changes.

Note: if both a user-level and project-level copy of these rules exist at once, Claude Code loads user rules first and project rules take precedence on overlap — so having both isn't harmful, just redundant. Prefer one scope unless there's a specific reason to override a personal rule per-project.

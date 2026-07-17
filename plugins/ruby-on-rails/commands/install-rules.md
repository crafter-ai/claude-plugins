---
description: Copy this plugin's Rails coding rules into the project's .claude/rules/ so they auto-load by file path
---

Install (or update) the Ruby on Rails coding rules from this plugin into the current project.

Plugins can't ship auto-loading rules, so this command copies them into the project, where Claude Code loads them lazily based on their `paths:` globs.

Steps:

1. Locate the plugin's `rules/` directory at `${CLAUDE_PLUGIN_ROOT}/rules/`. If that variable was not substituted (it appears literally above), find the newest installed version under `~/.claude/plugins/cache/crafter-ai/ruby-on-rails/*/rules/`.
2. If `.claude/rules/ruby-on-rails/` does not exist in the project root: create it and copy all `*.md` files from the plugin's `rules/` directory into it.
3. If it already exists: diff the existing files against the plugin's versions first. If there are local modifications, show the user a summary of what would change and ask before overwriting. Otherwise replace the directory contents (including deleting rule files that no longer exist in the plugin).
4. Confirm the result: list the installed rule files and the path globs each one applies to (from their frontmatter).
5. Remind the user to commit `.claude/rules/ruby-on-rails/` so the whole team gets the rules, and that re-running this command after a plugin update pulls in rule changes.

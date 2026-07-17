# Rails rules

These files are Claude Code rules (markdown + `paths:` frontmatter). They are not loaded from the plugin: Claude Code plugins can't ship auto-loading rules, so `/ruby-on-rails:install-rules` copies them into the project's `.claude/rules/ruby-on-rails/`, which the project commits.

## How these files are split

One file per path scope (glob set), not one file per rule:

- The glob is the loading unit. Claude Code loads a rule file when it reads a file matching its `paths:`. Rules sharing the same globs load together anyway, so splitting them into more files saves no context and multiplies maintenance.
- A single all-in-one file wastes context the other way: model rules would load when editing controllers.
- Keep each file under ~200 lines (Claude Code guidance). If a scope outgrows that, split it then.

`tests.md` and `e2e-tests.md` overlap on purpose: both apply when editing an e2e test.

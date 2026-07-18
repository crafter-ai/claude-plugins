# Crafter AI Claude Code plugins

Claude Code plugins with skills we use daily. Grouped by domain so you enable only what applies to your project.

## Plugins

| Plugin | What's inside |
|---|---|
| `software-development` | Language-agnostic dev skills. Currently: record feature demo videos with Playwright MCP, with subtitles. Bundles a pre-configured Playwright MCP server (video recording enabled), so no manual MCP setup. Needs Node; ffmpeg and the Chromium binary are installed on first use. |
| `ruby-on-rails` | Ruby on Rails coding rules: models, tests, e2e tests, general Ruby. Run `/ruby-on-rails:install-rules project` once per project to copy them into `.claude/rules/` (plugins can't auto-load rules), commit, and every dev gets them scoped by file path — or `/ruby-on-rails:install-rules user` to copy them into `~/.claude/rules/` instead, so they apply to every project on your machine without committing anything. |
| `writing` | Writing style guide for emails, docs, PRs, commits and chat. Direct, no AI-sounding text. |
| `progressive-web-app` | Generate PWA icons, splash screens and manifest entries from a single source image. |

## Install

Add the marketplace:

```
/plugin marketplace add crafter-ai/claude-plugins
```

Install what you need:

```
/plugin install software-development@crafter-ai
/plugin install ruby-on-rails@crafter-ai
/plugin install writing@crafter-ai
/plugin install progressive-web-app@crafter-ai
```

## Auto-install for your whole team

Commit this to your project's `.claude/settings.json`. Everyone who trusts the repo gets prompted to install:

```json
{
  "extraKnownMarketplaces": {
    "crafter-ai": {
      "source": { "source": "github", "repo": "crafter-ai/claude-plugins" }
    }
  },
  "enabledPlugins": {
    "software-development@crafter-ai": true,
    "ruby-on-rails@crafter-ai": true
  }
}
```

## License

MIT

# Crafter AI Claude Code plugins

Claude Code plugins with skills we use daily. Grouped by domain so you enable only what applies to your project.

## Plugins

| Plugin | What's inside |
|---|---|
| `software-development` | Language-agnostic dev skills. Currently: record feature demo videos with Playwright MCP, with subtitles. |
| `ruby-on-rails` | Ruby on Rails skills. Empty for now, content coming. |
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
/plugin install writing@crafter-ai
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

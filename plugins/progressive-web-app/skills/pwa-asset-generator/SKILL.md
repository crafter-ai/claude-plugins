---
name: pwa-asset-generator
description: >
  Generates PWA icons, splash screens, favicons, and mstile images from a single source image
  using the pwa-asset-generator CLI. Automatically updates manifest.json and index.html with
  the correct link/meta tags. Use this skill whenever the user mentions generating PWA assets,
  app icons, splash screens, iOS launch images, apple-touch-icon, web app manifest icons,
  adding icons to a PWA, making a PWA work on iOS home screen, or wants their app to look
  native on Android/iOS. Also trigger for "my PWA is missing icons", "how do I add a splash
  screen to my PWA", "generate all icon sizes", or "update manifest with icons".
---

# pwa-asset-generator

Automates PWA asset generation from a single source image or HTML file. Generates all required
icon sizes, iOS splash screens, favicons, and Windows tiles — and wires them into your
`manifest.json` and `index.html` automatically.

## Quick start

```bash
npx pwa-asset-generator logo.svg ./assets -i ./public/index.html -m ./public/manifest.json
```

This one command: generates all icon sizes + all iOS splash screens, updates `manifest.json`
with icon entries, and injects `<link>` tags into `index.html`.

## Common scenarios

### 1. Full PWA setup (icons + splash screens)

```bash
npx pwa-asset-generator logo.svg ./assets \
  --manifest ./public/manifest.json \
  --index ./public/index.html
```

### 2. Icons only (skip splash screens)

```bash
npx pwa-asset-generator logo.svg ./assets --icon-only \
  --manifest ./public/manifest.json \
  --index ./public/index.html
```

### 3. Splash screens only

```bash
npx pwa-asset-generator logo.svg ./assets --splash-only \
  --index ./public/index.html
```

### 4. With a colored background

```bash
npx pwa-asset-generator logo.svg ./assets \
  --background "#1a1a2e" \
  --manifest ./public/manifest.json \
  --index ./public/index.html
```

Background accepts any CSS value: hex, `rgba(...)`, `linear-gradient(...)`, named colors.

### 5. Dark mode splash screens (iOS)

Two commands — one for light, one for dark:

```bash
# Light mode
npx pwa-asset-generator logo.svg ./assets/light \
  --splash-only --background "#ffffff" \
  --index ./public/index.html

# Dark mode (adds prefers-color-scheme: dark media attr)
npx pwa-asset-generator logo-dark.svg ./assets/dark \
  --splash-only --dark-mode --background "#1a1a2e" \
  --index ./public/index.html
```

### 6. Include favicon + Windows tiles

```bash
npx pwa-asset-generator logo.svg ./assets \
  --favicon --mstile \
  --index ./public/index.html
```

### 7. React / Create React App (uses %PUBLIC_URL%)

```bash
npx pwa-asset-generator logo.svg ./public/assets \
  --path "%PUBLIC_URL%/assets" \
  --manifest ./public/manifest.json \
  --index ./public/index.html
```

### 8. Transparent PNG icons (no white background)

```bash
npx pwa-asset-generator logo.svg ./assets \
  --opaque false --type png \
  --icon-only \
  --manifest ./public/manifest.json
```

### 9. JPG with quality control (smaller files)

```bash
npx pwa-asset-generator logo.svg ./assets \
  --type jpg --quality 80
```

## Input source options

| Type | Example |
|------|---------|
| Local SVG/PNG/JPG | `logo.svg`, `logo.png` |
| Local HTML file | `splash.html` (full creative control with CSS) |
| Remote image URL | `https://cdn.example.com/logo.png` |
| Remote HTML URL | `https://example.com/splash-template.html` |

SVG is strongly recommended as the source — it scales perfectly to all target resolutions.

## Key flags reference

| Flag | Purpose | Default |
|------|---------|---------|
| `-b / --background` | CSS background color/gradient | `transparent` |
| `-o / --opaque` | White canvas (set `false` for transparency) | `true` |
| `-p / --padding` | Padding around logo | `"10%"` |
| `-t / --type` | Output format: `png` or `jpg` | `jpg` (icons: `png`) |
| `-q / --quality` | JPG quality 0–100 | `70` |
| `-h / --splash-only` | Only splash screens | false |
| `-c / --icon-only` | Only icons | false |
| `-f / --favicon` | Also generate favicon | false |
| `-w / --mstile` | Also generate Windows tiles | false |
| `-e / --maskable` | Mark icons as maskable in manifest | `true` |
| `-d / --dark-mode` | iOS dark mode media query on splash tags | false |
| `-r / --portrait-only` | Portrait splash screens only | false |
| `-l / --landscape-only` | Landscape splash screens only | false |
| `-u / --single-quotes` | Single quotes in HTML tags | false |
| `-x / --xhtml` | Self-closing HTML tags (for JSX) | false |
| `-a / --path` | Path prefix for generated href/src | — |
| `-v / --path-override` | Override image path in tags | — |
| `-m / --manifest` | Path to manifest.json to update | — |
| `-i / --index` | Path to index.html to update | — |
| `--scrape false` | Skip scraping Apple specs (use cached) | scrape=true |

## Padding tips

- Default `"10%"` — safe for most logos
- Larger logo: `--padding "calc(50vh - 20%) calc(50vw - 40%)"`
- Smaller logo: `--padding "calc(50vh - 5%) calc(50vw - 10%)"`

## Transparent favicon + opaque app icons (workaround)

```bash
# Step 1: transparent favicon
npx pwa-asset-generator logo.svg ./assets \
  --opaque false --icon-only --favicon --type png

# Step 2: overwrite app icons with opaque background
npx pwa-asset-generator logo.svg ./assets \
  --background "#ffffff" --icon-only
```

## Using as a Node.js module

```javascript
const pwaAssetGenerator = require('pwa-asset-generator');

const { savedImages, htmlMeta, manifestJsonContent } = await pwaAssetGenerator.generateImages(
  'logo.svg',
  './assets',
  {
    background: '#1a1a2e',
    splashOnly: true,
    portraitOnly: true,
    manifest: './public/manifest.json',
    index: './public/index.html',
  }
);
```

## What to tell the user after running

When the command completes, summarize:
1. Where the images were saved
2. That `manifest.json` / `index.html` were updated (if those flags were used)
3. Any follow-up steps (e.g., committing assets, deploying, verifying on device)

If manifest/index flags weren't used, remind them to manually add the generated tags — the
tool prints the tags to stdout.

---
name: responsive-css
description: >
  Write responsive, mobile-first CSS and give the UI a deliberate visual direction. Use when
  building or restyling a page, layout or component, making something work on mobile, fixing
  overflow, horizontal scroll, text that is too small or too long, 100vh bugs behind the mobile
  address bar, notch or safe-area issues, small tap targets, or choosing units (rem, em, %, fr,
  vw, dvh, cqi, ch, px), breakpoints, media or container queries, clamp() and fluid type.
  Portuguese triggers: "CSS responsivo", "mobile-first", "layout no celular", "quebrando no
  mobile", "rolagem horizontal", "tamanho de fonte", "breakpoint".
license: MIT
---

<!-- Adapted from secondsky/claude-skills mobile-first-design (MIT) and anthropics/skills frontend-design (Apache-2.0). -->

# Responsive CSS

Write the mobile layout first, as the base styles with no media query, then add
`min-width` queries only where the content breaks. Let intrinsic layout (grid, flex,
`clamp()`, container queries) do most of the work so few breakpoints are needed.

## Units

| Job | Use | Why |
|---|---|---|
| Font sizes | `rem` | Scales with the user's browser setting, so it respects accessibility |
| Fluid type and spacing | `clamp()` with `rem` and `vw` | One line replaces a stack of media queries |
| Layout structure and grids | `%` and `fr` | Sizes relative to the parent or the grid container |
| Component-level responsiveness | `cqi` / `cqw` | The element reacts to its own space, not the viewport |
| Full-height sections on mobile | `dvh` (or `svh`) | Survives the mobile address bar showing and hiding |
| Line length (the measure) | `ch` | Caps text at a readable number of characters |
| Borders and hairlines | `px` | A 1px border should be 1px everywhere |

- **Never `vw` alone for font size:** it ignores browser zoom and text-size settings. Always
  `clamp(1rem, 0.9rem + 0.5vw, 1.25rem)`, with a `rem` floor and ceiling.
- **`svh` vs `dvh`:** `svh` is the small viewport (bar visible) and doesn't jump while
  scrolling; `dvh` resizes live. Prefer `svh` for heroes, `dvh` for app shells. Keep a `vh` line
  before it as fallback.
- **`100vw` includes the scrollbar:** on desktop it causes horizontal scroll. Use `100%`.
- **Prefer `min-height` to `height`:** fixed heights clip content when text wraps or the user
  enlarges fonts.

## Base setup

```html
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
```

Never add `maximum-scale=1` or `user-scalable=no`: it blocks zoom, an accessibility failure.

```css
*, *::before, *::after { box-sizing: border-box; }
img, video, svg { max-width: 100%; height: auto; display: block; }
body { min-height: 100svh; overflow-wrap: break-word; }
input, select, textarea { font-size: max(1rem, 16px); }  /* below 16px, iOS Safari zooms on focus */
```

## Layout

```css
/* Cards wrap by available width, no breakpoints */
.grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(min(100%, 18rem), 1fr));
  gap: clamp(1rem, 0.5rem + 2vw, 2rem);
}

/* Centered column that keeps a gutter on small screens */
.wrapper { width: min(100% - 2rem, 70rem); margin-inline: auto; }

/* Readable text */
.prose { max-width: 65ch; }

/* Component adapts to its slot, wherever it is placed */
.card-slot { container-type: inline-size; }
@container (min-width: 30rem) {
  .card { grid-template-columns: 10rem 1fr; }
}
```

- **Breakpoints come from the content:** widen the browser until the layout looks wrong, and
  put the breakpoint there. Don't use a device table; device widths change every year.
- **Write queries in `em`/`rem`:** `@media (min-width: 48em)` follows the user's font size,
  `px` doesn't. Range syntax (`@media (width >= 48em)`) is fine in current browsers.
- **Container query before media query:** if the question is "how much room does this
  component have", it's a container query. Media queries are for page-level layout.
- **Logical properties:** `margin-inline`, `padding-block`, `inset-inline-start` instead of
  left/right, so RTL works for free.
- **Watch `min-width: auto` on flex/grid children:** a long word or URL forces overflow. Add
  `min-width: 0` on the child (or `minmax(0, 1fr)` on the track).

## Touch and device

```css
.button { min-block-size: 2.75rem; min-inline-size: 2.75rem; }  /* 44px tap target */

@media (hover: hover) and (pointer: fine) {
  .button:hover { background: var(--hover); }
}

.app-bar { padding-bottom: max(1rem, env(safe-area-inset-bottom)); }

@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after { animation-duration: 0.01ms !important; transition-duration: 0.01ms !important; }
}
```

- **Tap targets:** 44×44px minimum (Apple HIG; WCAG 2.2 AA's floor is 24px), with spacing
  between adjacent targets. Enlarge the hit area with padding, not by scaling the visual.
- **Hover is an enhancement:** nothing should be reachable only by hovering. Gate hover styles
  with `(hover: hover)`, or touch devices show a stuck hover after a tap.
- **Safe areas:** with `viewport-fit=cover`, fixed headers, bottom bars and full-bleed sections
  need `env(safe-area-inset-*)`.
- **Visible focus:** keep a clear `:focus-visible` outline; never `outline: none` without a
  replacement.

## Images and performance

- **Reserve space:** set `width`/`height` attributes or `aspect-ratio` so images don't shift
  the layout when they load.
- **Serve the right size:** `srcset` + `sizes` (or `<picture>` for art direction), modern
  formats (AVIF/WebP), `loading="lazy"` below the fold, never on the hero image.
- **Progressive enhancement:** content and links work from the HTML alone; gate new CSS
  features with `@supports` when the fallback would be broken, not just plainer.

## Visual direction

When building new UI or reshaping one (not when fixing a layout bug), make deliberate choices
instead of templated defaults. If the project has a design system or tokens, use them and skip
the plan.

1. **Ground it in the subject:** name the product, its audience and the page's main job. The
   subject's industry, materials and vernacular are where distinctive choices come from.
2. **Plan before code:** a compact token system: 4–6 named hex colors, one or two typefaces
   with roles and a type scale, a layout concept (one sentence plus an ASCII wireframe,
   including alignment), and the principle that makes this page its own.
3. **Review the plan:** if a part is what you'd produce for any similar page, revise it and say
   what changed. Where the brief pins a direction, follow it exactly.
4. **Build, then critique:** screenshot at 320px, ~768px and desktop, and fix what you see.
   Before finishing, remove one accessory.

Generic tells to avoid unless the brief asks for them:
- Cream background (near `#F4F1EA`) with a serif display and terracotta accent (near `#D97757`).
- Near-black background with one acid-green or vermilion accent.
- Identical rounded cards with the same soft grey shadow and one radius on everything, plus
  decorative gradient washes.
- ALL-CAPS tracked eyebrow labels above every heading, `A · B · C` meta strings,
  `WORD — fragment` labels, monospace for small data labels, `→` appended to buttons.
- One word in a headline accented with italic, bold or color.
- `01 / 02 / 03` markers on content that isn't a sequence.
- Fade-and-slide-up on every section and hover transitions on every card. Use one orchestrated
  moment; motion that answers a user action is welcome.

Principles:
- **Spend boldness in one place:** one memorable element, everything around it quiet.
- **Type carries the personality:** choose typefaces on purpose, not the usual defaults; keep
  body text under ~80 characters per line, with a bit more line-height for serif body text.
- **Structure is information:** borders, numbering, dividers and labels must encode something
  about the content, not decorate it.
- **Copy is design:** name things as users understand them, active voice, buttons say what
  happens ("Save changes", not "Submit"), the same action keeps the same name through the flow,
  errors say what went wrong and how to fix it, empty states invite the next action.
- **Watch selector specificity:** a type selector like `.section` and a component one like
  `.cta` easily cancel each other's padding and margins.

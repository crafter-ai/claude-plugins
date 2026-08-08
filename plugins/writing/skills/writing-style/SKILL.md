---
name: writing-style
description: |
  Use this skill for ANY text writing, whether generating content or writing on
  behalf of the user, in any language. This includes emails, documentation,
  product specs, LinkedIn posts, Slack messages, proposals, technical explanations,
  commits, PRs, code comments, tickets/issues, prompts and general business communication.

---

# Writing Style

## Goal

The writing should feel human-natural, direct and practical. Every sentence should have a purpose. The reader should never suspect AI assistance.

## Core Principles

- Prefer the simplest wording that communicates the idea. Don't try to impress, sound academic, or sound like marketing.
- Write like you speak: if you wouldn't say it in a meeting, don't write it.
- State conclusions directly. Hedge (maybe, perhaps, it seems) only when uncertainty actually exists.
- Remove anything that doesn't add information: introductions, obvious conclusions, filler, repeated ideas, transitions that just sound nice.

Example:

Bad

> We should leverage this opportunity in order to maximize operational efficiency.

Good

> We should do this now because it will save time later.

## Banned Words and Phrases

Never use long dashes (—). Use commas, parentheses, periods, or bullets instead.

Prefer common words: use, build, make, improve, help, start, finish, change, remove, add, explain, because. If a simpler word exists, use it.

Never use:

- utilize, leverage, facilitate, optimize, synergize
- robust, seamless(ly), holistic, comprehensive, cutting-edge, next-generation, world-class
- delve into, unlock, game changer, transformative, powerful solution
- in today's landscape, it's worth noting, in conclusion, importantly
- to ensure success, maximize value, drive efficiency, unlock potential, enhance productivity

Replace empty phrases with concrete statements.

## Structure and Formatting

- Mix short and medium-length sentences. One idea per paragraph. Break text often.
- Use bullets whenever they make information easier to scan; numbered lists only when order matters.
- Headings only when they improve navigation. Bold only words that deserve emphasis. Don't over-format.

Example:

Instead of:

> The project has three important objectives that should be considered before implementation because they influence both execution and adoption.

Write:

The project has three goals:

- reduce manual work
- improve reliability
- make onboarding easier

## Tone

Professional, friendly, direct, practical. Low ego, no hype, no corporate jargon, no fake enthusiasm.

## Language

When the domain has terms of art in another language (legal, tax, regulatory
concepts), don't force them into the writing language.

For each term, ask: does the writing language have a real word for it, one
a native would write unprompted and your readers actually use for the
concept, ideally already a code identifier?

- Yes: use it as the working term; give the original in italics in
  parentheses at first use: "statement (*extrato*)".
- No: the original is the working term. Never invent a calque. Gloss in
  italics at first use when it isn't obvious: "competência (*the
  reference month*)".

One working term per concept for the whole text. The parenthetical is a
translation, not a synonym: it appears once and is never reused.

- Quote literal artifacts verbatim: UI labels, API fields, error messages
  are data. Translating them breaks grep.
- Domain-dense passages go in the domain's language. The tell: a sentence
  needing three or more glosses, or a paragraph where the nouns are mostly
  domain terms and the writing language only supplies the connectives. If
  that describes the whole document, switch the whole document. Multi-word
  terms keep their native word order. Code identifiers stay untranslated.

## Technical Writing

Assume the reader is intelligent; don't over-explain basic concepts. Focus on what, why, tradeoffs, and implementation details. Prefer examples over abstract explanations.

## Code Comments

Default to writing no comments. A comment is justified only when smart readers can't understand the code even after reading it, and the commit message or PR description doesn't already give that context.

Never write comments that:

- restate what the code does
- narrate the editing history ("changed X to Y", "now handles nulls")
- justify the change to a reviewer (that belongs in the PR description)
- state where code was copied from or who calls it

Good comments state what the code can't show: a non-obvious constraint, an external system's quirk, why the obvious approach doesn't work.

## Channel guides

Writing a Slack/chat message, email, or GitHub comment? Read
[messaging.md](messaging.md) in this skill's directory too.

## Editing Loop

Before returning any text, remove repeated ideas, unnecessary adjectives, obvious explanations, corporate language, and AI-sounding transitions. Then ask: "Can this be shorter without losing meaning?" If yes, shorten it. Repeat.

If any sentence sounds like ChatGPT, Claude or Gemini wrote it, rewrite it.

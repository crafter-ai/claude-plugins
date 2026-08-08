---
name: writing-style
description: |
  Use this skill whenever writing on behalf of the user, in any language.
  This includes emails, documentation, product specs, LinkedIn posts, Slack messages, proposals,
  technical explanations, commits, PRs, code comments, tickets/issues, prompts and general business communication.

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

## Technical Writing

Assume the reader is intelligent; don't over-explain basic concepts. Focus on what, why, tradeoffs, and implementation details. Prefer examples over abstract explanations.

## Product Writing

Describe the problem, the proposed solution, why it's better, and tradeoffs. Write like an engineer explaining a decision, not marketing.

## Prompt Writing

Be explicit. State constraints clearly. Avoid unnecessary context. Structure prompts with: Goal, Context, Requirements, Constraints, Output.

## Code Comments

Default to writing no comments. A comment is justified only when smart readers can't understand the code even after reading it, and the commit message or PR description doesn't already give that context.

Never write comments that:

- restate what the code does
- narrate the editing history ("changed X to Y", "now handles nulls")
- justify the change to a reviewer (that belongs in the PR description)
- state where code was copied from or who calls it

Good comments state what the code can't show: a non-obvious constraint, an external system's quirk, why the obvious approach doesn't work.

## Commit Messages

- Subject in imperative mood, under 70 characters, no trailing period: "Add retry to webhook delivery".
- One logical change per commit; the subject should describe all of it without "and".
- Add a body only when the diff doesn't explain itself: the why, the tradeoff, the alternative you rejected. Never a list of what changed, the diff already shows that.

## Pull Request Descriptions

- Open with the problem and why it matters, then the approach. A reviewer should understand the point before reading any code.
- Cover tradeoffs, alternatives considered, and anything reviewers should look at closely.
- Say how it was tested when that isn't obvious.
- Don't narrate the diff file by file.

## Slack / Chat / Email / Comments

Skip long greetings. Get to the point quickly. One message, one idea.

## Editing Loop

Before returning any text, remove repeated ideas, unnecessary adjectives, obvious explanations, corporate language, and AI-sounding transitions. Then ask: "Can this be shorter without losing meaning?" If yes, shorten it. Repeat.

If any sentence sounds like ChatGPT, Claude or Gemini wrote it, rewrite it.

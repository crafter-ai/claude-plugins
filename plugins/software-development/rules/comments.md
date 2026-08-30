---
paths:
  - "**/*"
---

# Code comments

Default to writing no comments. If you REALLY need to write a comment, avoid
multi-paragraph docstrings or multi-line comment blocks — prefer one short line.
Don't create planning, decision, or analysis documents unless the user asks for
them — work from conversation context, not intermediate files.

A comment is justified only when smart readers can't understand the code even
after reading it, and the commit message or PR description doesn't already give
that context.

Never write comments that:

- restate what the code does
- narrate the editing history ("changed X to Y", "now handles nulls")
- justify the change to a reviewer (that belongs in the PR description)
- state where code was copied from or who calls it

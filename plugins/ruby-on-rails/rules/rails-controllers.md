---
paths:
  - "app/controllers/**/*.rb"
---

# Passing data to views

- Always pass data to views through `render ... locals:`, never through instance variables (`@foo`). Locals make a view's inputs explicit, and a typo raises `NameError` instead of silently rendering `nil`.

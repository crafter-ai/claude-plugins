---
paths:
  - "test/**/*.rb"
  - "spec/**/*.rb"
---

# One setup, one test

- Each test verifies **one state transition** (one action), not one assertion
- If two tests share the same setup and trigger the same action, they must be merged into a single test
- Place all assertions about that action's outcome together in the same test block (`it` in RSpec, `test`/`def test_*` in minitest)
- Do not split assertions into separate tests just for "readability" — group them within one test instead
- In RSpec, use `:aggregate_failures` when a test has multiple assertions, so all failures are reported rather than stopping at the first one. Minitest has no equivalent; keeping the assertions together in one test is enough.

# Journey tests

- Journey tests (multi-step flows spanning multiple actions) should keep the whole flow in a single test instead of separate tests that would duplicate the preceding steps
- Group assertions after each meaningful step. In RSpec, use an `aggregate_failures` block with a label describing the step (e.g., `aggregate_failures "after creating the order" do`), so a failure mid-journey still reports subsequent assertion results. In minitest, a comment labeling each step's assertion group serves the same readability purpose.

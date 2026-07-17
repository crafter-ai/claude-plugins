---
paths:
  - "**/*.rb"
  - "**/*.rake"
---

# Method readability

- Always use guard clauses to keep methods simple and readable. Prefer multiple guard clauses with a single condition each (or as few as possible) instead of combining multiple conditions. Example:
  Bad:
  ```ruby
  def send_email(user)
    return unless user.subscribed? && user.active?

    # send email logic
  end
  ```
  Good:
  ```ruby
  def send_email(user)
    return unless user.subscribed?
    return unless user.active?

    # send email logic
  end
  ```

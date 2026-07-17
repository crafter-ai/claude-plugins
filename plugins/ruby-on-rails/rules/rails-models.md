---
paths:
  - "app/models/**/*.rb"
---

# Class definition

- ActiveRecord models inherit from `ApplicationRecord` directly or indirectly. Exception: if the project uses multiple databases and it has multiple base models.

# Enum

- Use string-based enums - the value is stored as string in the database.
  ```ruby
  enum :role, %i[owner admin manager].index_with(&:to_s), suffix: :role, validate: true
  ```

- Enable validation (`validate: true`)

- Use `prefix` or `suffix` to avoid method name conflicts and improve code readability

- Use `prefix` or `suffix` with the same name of the attribute.
  - The choice of prefix or suffix should be based on what reads better in english. Example:
    ```ruby
    # Suffix - clearer when attribute is the key context
    enum :status, %i[pending approved rejected], suffix: :status
    order.status_pending?  # Reads naturally
    order.pending_status?  # Feels awkward

    # Prefix - clearer when value is the main identity
    enum :role, %i[owner admin manager], prefix: :role
    user.admin_role?       # Reads naturally
    user.role_admin?       # Feels clunky
    ```

# Normalization

In general, string fields should have extra spaces removed, and should be converted to `nil` if they are empty (see example below).

```ruby
normalizes <string attribute>, with: ->(value) { value.squish.presence }
```

# Validation

- There should be ActiveRecord validations matching database constraints. E.g. presence, uniqueness, etc
- Attributes with names that are clearly related to well-known formats (such as URL, Email, UUID, etc) should have format validation

## Uniqueness validation

If the model uses soft deletion, do not validate uniqueness of non-primary attributes (anything other than id or uuid) against soft-deleted records.
Example: notice the `conditions: -> { undiscarded }` below.

```ruby
validates :name, uniqueness: { conditions: -> { undiscarded }, ... }
```

## In-model custom validations

Validations that require a custom implemention within the model should be implemented within private methods prefixed with `validate_`.
```ruby
validate :validate_start_date_before_end_date
```

# Callbacks

- Enqueuing jobs should always be done in `after_commit`

## Prevent Destruction

When a model should never be destroyed, use the pattern below using `before_destroy` callback:

```ruby
before_destroy :prevent_destroy

private

def prevent_destroy
  errors.add(:base, :cannot_destroy)
  throw :abort
end
```

# ActiveRecord built-in methods

- ActiveRecord generated methods such as `def <attribute>` and `def <attribute>=` should never be overridden. Instead, leverage callbacks or implement a custom method to manipulate an attribute at read/write time.
- Never override ActiveRecord methods that are not intended to be overridden, such as `initialize`, `attributes`, `save`, `update`, `validate`, `valid?`, `self.create`, `self.model`, etc. These are methods that developers never guess that are customized. On the other hand, the method `as_json` is known to be ok to override when the application doesn't have a serialization layer.

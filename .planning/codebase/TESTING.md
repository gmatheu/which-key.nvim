# Testing Patterns

**Analysis Date:** 2026-02-24

## Test Framework

**Runner:** mini.test

**Assertion Library:** mini.test built-in assertions

**Run Commands:**
```bash
./scripts/test              # Run all tests
./scripts/test tests/buf_spec.lua    # Run specific test file
```

## Test File Organization

**Location:** `tests/`

**Naming:** `*_spec.lua`

**Structure:**
```
tests/
├── buf_spec.lua          # Buffer tests
├── mappings_spec.lua     # Mapping tests
├── triggers_spec.lua     # Trigger tests
├── hooks_spec.lua        # Hook tests
└── health_spec.lua       # Health check tests
```

## Test Structure

**Suite Organization:**
```lua
describe("feature", function()
  before_each(function()
    require("helpers").reset()
  end)

  it("should do something", function()
    assert.equals(expected, actual)
    assert.same(table_expected, table_actual)
    assert.is_true(condition)
  end)
end)
```

**Patterns:**
- `describe()` - Test suites
- `it()` - Individual tests
- `before_each()` - Setup before each test
- `after_each()` - Cleanup after each test (if needed)

## Mocking

**Framework:** mini.test + manual mocking

**Patterns:**
- Override `Config.options` for config tests
- Use `require("helpers").reset()` to clean state
- Mock `Util.warn` for error testing

**What to Mock:**
- Global state (Config, mappings)
- User notifications (Util.warn)
- External dependencies

**What NOT to Mock:**
- Core Neovim API (vim.api, vim.fn)
- Buffer state

## Fixtures and Factories

**Test Data:**
- Inline table definitions
- No external fixture files

**Example:**
```lua
local tests = {
  {
    spec = {
      ["<leader>"] = {
        name = "leader",
        ["a"] = { "a" },
      },
    },
    mappings = {
      { lhs = "<leader>a", desc = "a", mode = "n" },
    },
  },
}
```

**Location:** Inline in test files

## Coverage

**Requirements:** None enforced

**View Coverage:**
```bash
./scripts/test  # Run tests (no coverage tool mentioned)
```

## Test Types

**Unit Tests:**
- Scope: Individual modules
- Location: `tests/*_spec.lua`
- Approach: Test functions in isolation

**Integration Tests:**
- Scope: Module interactions
- Examples: Buffer + Tree, State + Triggers

**E2E Tests:**
- Not present (manual testing in Neovim)

## Common Patterns

**Async Testing:**
- mini.test handles async internally
- Tests wait for scheduled callbacks

**Error Testing:**
```lua
local errors = {}
Util.warn = function(msg)
  table.insert(errors, msg)
end
-- ... test code ...
assert.equals(1, #errors)
```

**State Reset:**
```lua
before_each(function()
  require("helpers").reset()
end)
```

---

*Testing analysis: 2026-02-24*

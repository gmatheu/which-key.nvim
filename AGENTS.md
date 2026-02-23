# Agent Instructions for which-key.nvim

## Build / Test / Lint Commands

### Testing
```bash
# Run all tests
./scripts/test

# Run a specific test file
./scripts/test tests/buf_spec.lua
./scripts/test tests/mappings_spec.lua

# Run tests matching a pattern
./scripts/test --pattern "triggers"
```

### Linting & Formatting
```bash
# Lint with Selene (Lua linter)
selene lua/

# Format with StyLua
stylua lua/ tests/

# Check formatting without writing
stylua --check lua/ tests/
```

### Documentation
```bash
# Generate documentation
./scripts/docs
```

## Code Style Guidelines

### Formatting
- **Indent**: 2 spaces (no tabs)
- **Line width**: 120 columns (StyLua), 100 columns (lua-format for docs)
- **Quotes**: Double quotes preferred
- **Trailing commas**: Required in tables
- **Final newline**: Required (enforced by .editorconfig)

### Imports
```lua
-- Group by: stdlib → local modules
local uv = vim.uv or vim.loop  -- Use vim.uv with vim.loop fallback

-- Internal requires at top
local Config = require("which-key.config")
local Util = require("which-key.util")
```

### Naming Conventions
- **Modules**: `M` for the main table, capitalized for classes/types
- **Types**: PascalCase with `wk.` prefix (e.g., `wk.Trigger`, `wk.Mapping`)
- **Functions**: snake_case, descriptive and action-oriented
- **Private**: Prefix with underscore (e.g., `M._triggers`)
- **Constants**: UPPER_CASE for module-level constants
- **Keys**: Use `<leader>`, `<cr>`, `<esc>` format (lowercase special keys)

### Type Annotations (LuaCATS)
```lua
---@class wk.MyClass
---@field name string Description
---@field optional? number Optional field

---@param arg string Argument description
---@param opts? table Optional options
---@return boolean success, string? error Returns success and optional error
function M.my_function(arg, opts)
  -- implementation
end
```

### Error Handling
- Use `pcall` for operations that might fail
- Prefer `vim.pcall` or `pcall` with proper error handling
- Use `Util.warn()` or `Util.error()` from which-key.util for user-facing errors
- Return `(ok, result)` pattern for recoverable errors

### Patterns
```lua
-- Module structure
local M = {}
M.cache = {}  -- For module-level state

-- Timer pattern
M.timer = (vim.uv or vim.loop).new_timer()

-- Autocmd setup
local group = vim.api.nvim_create_augroup("wk", { clear = true })
vim.api.nvim_create_autocmd("BufEnter", {
  group = group,
  callback = function(ev)
    -- handler
  end,
})

-- Keymap creation
vim.keymap.set(mode, lhs, rhs, {
  buffer = buf,
  nowait = true,
  desc = "description",
})
```

### Testing
```lua
local Module = require("which-key.module")

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

## Project Structure
- `lua/which-key/` - Core plugin modules
- `lua/which-key/plugins/` - Built-in plugins (marks, registers, etc.)
- `tests/` - Test files (mini.test framework)
- `doc/` - Generated vim help files
- `scripts/` - Build/test scripts

## Configuration Files
- `stylua.toml` - Formatting config
- `selene.toml` - Linting config
- `.editorconfig` - Editor settings
- `.neoconf.json` - Neovim LSP settings

# Coding Conventions

**Analysis Date:** 2026-02-24

## Naming Patterns

**Files:**
- Pattern: snake_case
- Examples: `state.lua`, `buf.lua`, `triggers.lua`

**Functions:**
- Pattern: snake_case (lowercase verbs)
- Examples: `M.setup()`, `M.start()`, `M.check()`
- Some short verb names: `M.show()`, `M.hide()`

**Private Functions:**
- Pattern: Leading underscore
- Example: `M._run_hooks()`

**Types (LuaCATS):**
- Pattern: PascalCase with `wk.` prefix
- Examples: `wk.State`, `wk.Node`, `wk.Trigger`, `wk.Opts`

**Variables:**
- Pattern: snake_case
- Constants: UPPER_CASE for module-level

## Code Style

**Formatting:**
- Tool: StyLua
- Config: `stylua.toml`
- Indent: 2 spaces
- Line width: 120 columns
- Sort requires: Enabled

**Linting:**
- Tool: Selene
- Config: `selene.toml`
- Standard: vim
- Rules: Allows mixed tables

**Editor:**
- Config: `.editorconfig`
- Final newline: Required
- Trim trailing whitespace: Yes

## Import Organization

**Order:**
1. Standard library (vim.uv, vim.loop)
2. Local modules (which-key.*)

**Pattern:**
```lua
-- Standard library
local uv = vim.uv or vim.loop

-- Local modules
local Config = require("which-key.config")
local Util = require("which-key.util")
```

**Path Aliases:**
- None (explicit relative requires)

## Error Handling

**Patterns:**
- Use `pcall()` around API calls that might fail
- Examples: `vim.api.nvim_buf_call()`, `vim.fn.maparg()`
- Delegate to `Util.warn()` or `Util.error()` for user messages

**Example:**
```lua
-- From state.lua
local ok, char = pcall(vim.fn.getcharstr)
if not ok then
  return nil, true
end
```

## Type Annotations (LuaCATS)

**Pattern:**
- Classes: `---@class wk.Name`
- Fields: `---@field name type description`
- Parameters: `---@param name type description`
- Returns: `---@return type description`

**Example:**
```lua
---@class wk.State
---@field mode wk.Mode
---@field node wk.Node
---@field started number
---@field show boolean
```

## Logging

**Framework:** Custom (file-based)

**Patterns:**
- `M.log()` - General logging
- `Util.debug()` - Debug messages
- `Util.trace()` - Trace messages
- Output: `wk.log` file in repo root

**Usage:**
```lua
Util.debug("message", value)
Util.trace("event_name")
```

## Comments

**When to Comment:**
- Complex logic explanations
- Workarounds (marked with "HACK:")
- TODO items for future work

**Patterns:**
```lua
-- HACK: ModeChanged does not always trigger
-- TODO: Add more tests for edge cases
```

## Function Design

**Size:** Small, focused functions preferred

**Parameters:**
- Required first, optional (tables) last
- Document with LuaCATS

**Return Values:**
- Multiple returns common: `(success, result)`
- Boolean status + value/error pattern

## Module Design

**Pattern:**
```lua
local M = {}
M.cache = {}  -- Module-level state

function M.setup()
  -- implementation
end

return M
```

**Exports:**
- Main table returned at end
- Public functions on main table
- Private functions local to module

**Barrel Files:**
- Not used (explicit requires)

---

*Convention analysis: 2026-02-24*

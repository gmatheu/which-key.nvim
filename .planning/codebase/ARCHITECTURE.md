# Architecture

**Analysis Date:** 2026-02-24

## Pattern Overview

**Overall:** Event-driven state machine plugin

**Key Characteristics:**
- State machine for tracking key sequence input
- Buffer-scoped mode trees
- Trigger system for keymap detection
- Async hook execution
- Timer-based mode change detection (workaround)

## Layers

**Entry Point:**
- Purpose: Bootstrap the plugin
- Location: `plugin/which-key.vim`
- Contains: Vimscript loader, lazy.nvim integration

**State Machine:**
- Purpose: Orchestrate the which-key flow
- Location: `lua/which-key/state.lua`
- Contains: State transitions, step execution, hook invocation
- Depends on: Buf, Triggers, View, Config
- Key functions: `M.start()`, `M.stop()`, `M.check()`, `M.execute()`

**Buffer Management:**
- Purpose: Manage buffer-scoped keymap trees
- Location: `lua/which-key/buf.lua`
- Contains: `wk.Mode`, `Buf.new()`, `Buf.get()`
- Depends on: Tree, Config

**Trigger System:**
- Purpose: Detect and handle keymap triggers
- Location: `lua/which-key/triggers.lua`
- Contains: Mode triggers, keymap detection
- Depends on: Config, Util

**View/UI:**
- Purpose: Render the which-key popup
- Location: `lua/which-key/view.lua`
- Contains: Window management, text formatting
- Depends on: Config, icons

**Configuration:**
- Purpose: Default settings and user configuration
- Location: `lua/which-key/config.lua`
- Contains: Defaults, option validation, hook definitions

**Utilities:**
- Purpose: Shared helper functions
- Location: `lua/which-key/util.lua`
- Contains: Logging, key translation, safety checks

## Data Flow

**Key Press Flow:**

1. User presses trigger key
2. `triggers.lua` detects trigger via autocmd
3. `state.lua` starts state machine (`M.start()`)
4. `buf.lua` retrieves/creates buffer mode tree
5. `view.lua` renders initial popup
6. User presses subsequent keys
7. `state.lua` steps through input (`M.step()`)
8. `state.lua` checks for matches (`M.check()`)
9. If match found: `state.lua` executes (`M.execute()`)
10. Hooks run at key points (start, check, execute, stop)

## Key Abstractions

**State (`wk.State`):**
- Purpose: Tracks current which-key session
- Fields: mode, node, filter, started, show
- Location: `lua/which-key/state.lua`

**Node (`wk.Node`):**
- Purpose: Represents a keymap or group in the tree
- Used by: Tree, Buf
- Supports: keymap actions, child nodes, count

**Mode (`wk.Mode`):**
- Purpose: Buffer-scoped keymap collection
- Location: `lua/which-key/buf.lua`
- Contains: tree, buffer reference, mode string

**Tree:**
- Purpose: Hierarchical keymap organization
- Used by: Buf, State
- Supports: path-based lookup, expansion

**Trigger:**
- Purpose: Detect prefix key presses
- Location: `lua/which-key/triggers.lua`
- Configured via: `Config.triggers`

## Entry Points

**Plugin Load:**
- Location: `plugin/which-key.vim`
- Triggers: Neovim startup (if using lazy.nvim)
- Responsibilities: Load core module

**Core Setup:**
- Location: `lua/which-key/init.lua` → `M.setup()`
- Triggers: User calls `require("which-key").setup(opts)`
- Responsibilities: Initialize config, set up autocmds, register triggers

**State Start:**
- Location: `lua/which-key/state.lua` → `M.start()`
- Triggers: Key press matching a trigger pattern
- Responsibilities: Initialize state, show UI, begin input loop

## Error Handling

**Strategy:** Graceful degradation with warnings

**Patterns:**
- `pcall()` around potentially failing API calls
- `Util.warn()` / `Util.error()` for user-facing messages
- Silent failures for non-critical operations

## Cross-Cutting Concerns

**Logging:**
- Approach: File-based logging to `wk.log`
- Functions: `Util.debug()`, `Util.trace()`, `M.log()`
- Debug mode: Controlled by `Config.debug`

**Validation:**
- Approach: Type checking via LuaCATS annotations
- Config validation in `config.lua`

**Hooks:**
- Approach: User-defined callbacks at key lifecycle points
- Types: start, stop, check, execute
- Execution: Asynchronous via `vim.schedule()`

---

*Architecture analysis: 2026-02-24*

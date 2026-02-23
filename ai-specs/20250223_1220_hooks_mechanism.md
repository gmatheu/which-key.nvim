# Hooks Mechanism Implementation

**Date:** 20250223_1220
**Feature:** Add hooks mechanism for main actions in which-key.nvim

## Request

Add a 'hooks' mechanism for main actions on `lua/which-key/state.lua` module (e.g: start, stop, execute, check). The hooks mechanism should:

- Allow subscribing custom functions via plugin's setup options (from `lua/which-key/config.lua`)
- Execute hooks asynchronously so they don't interfere with Neovim's normal behavior

## Implementation

### Files Modified

1. **lua/which-key/types.lua**
   - Added type definitions:
     - `wk.HookType` - Union type: `"start" | "stop" | "execute" | "check"`
     - `wk.HookContext` - Context passed to hooks with fields: `type`, `state`, `key`, `node`
     - `wk.Hook` - Function type signature
     - `wk.Hooks` - Configuration class with optional fields for each hook type

2. **lua/which-key/config.lua**
   - Added `hooks = {}` to default configuration
   - Includes documentation comments explaining the feature

3. **lua/which-key/state.lua**
   - Added `M._run_hooks(hook_type, context)` helper function
     - Retrieves hooks from Config
     - Normalizes single function to array
     - Executes via `vim.schedule()` for async behavior
     - Wraps in `pcall()` with error handling via `Util.warn()`
   - Added hook calls in:
     - `M.start()` - after state is initialized
     - `M.stop()` - before clearing state
     - `M.check()` - at function start
     - `M.execute()` - at function start before executing

4. **tests/hooks_spec.lua** (new file)
   - Comprehensive test suite covering:
     - Configuration (default empty, single function, array of functions)
     - `_run_hooks` helper behavior (async execution, error handling, missing hooks)
     - All hook types (start, stop, execute, check)
     - Hook context validation
     - Execution order for multiple hooks

## Design Decisions

- **Async execution via vim.schedule**: Ensures hooks don't block the main which-key flow
- **Error handling with pcall**: Prevents hook errors from breaking which-key functionality
- **Normalize to array**: Allows users to provide either a single function or array of functions
- **Context object**: Provides relevant state information to each hook type
  - `start`: type, state
  - `stop`: type, state
  - `execute`: type, state, key, node
  - `check`: type, state, key

## Usage Example

```lua
require("which-key").setup({
  hooks = {
    start = function(ctx)
      print("Which-key started!")
    end,
    stop = function(ctx)
      print("Which-key stopped!")
    end,
    execute = {
      function(ctx)
        vim.notify("Executing: " .. (ctx.key or ""))
      end,
      function(ctx)
        -- Additional hook
      end,
    },
  },
})
```

## Testing

The test file `tests/hooks_spec.lua` can be run with:

```bash
./scripts/test tests/hooks_spec.lua
```

Note: Full test execution requires the test environment to be set up (lazy.nvim, mini.test, etc.)

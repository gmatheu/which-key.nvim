# Codebase Structure

**Analysis Date:** 2026-02-24

## Directory Layout

```
/home/gmatheu/.dotfiles/stow-files/astronvim/dev/which-key.nvim/
├── lua/which-key/          # Core plugin modules
│   ├── init.lua           # Main entry point
│   ├── state.lua          # State machine
│   ├── buf.lua            # Buffer management
│   ├── triggers.lua       # Trigger system
│   ├── view.lua           # UI rendering
│   ├── config.lua         # Configuration
│   ├── tree.lua           # Tree data structure
│   ├── icons.lua          # Icon resolution
│   ├── util.lua           # Utilities
│   └── plugins/           # Built-in plugins
│       ├── marks.lua
│       ├── registers.lua
│       └── presets.lua
├── plugin/                # Vim plugin entry
│   └── which-key.vim      # Bootstrap loader
├── tests/                 # Test files
│   ├── buf_spec.lua
│   ├── mappings_spec.lua
│   ├── triggers_spec.lua
│   └── hooks_spec.lua
├── scripts/               # Build scripts
│   ├── test
│   └── docs
├── doc/                   # Generated docs
├── .github/workflows/     # CI/CD
└── [config files]         # stylua.toml, selene.toml, etc.
```

## Directory Purposes

**`lua/which-key/`:**
- Purpose: Core plugin implementation
- Contains: All main modules (state, buf, triggers, view, etc.)
- Key files:
  - `init.lua` - Public API
  - `state.lua` - State machine
  - `config.lua` - Configuration defaults

**`lua/which-key/plugins/`:**
- Purpose: Built-in plugins (marks, registers)
- Contains: Additional which-key functionality

**`plugin/`:**
- Purpose: Vim plugin bootstrap
- Contains: `which-key.vim` entry point

**`tests/`:**
- Purpose: Unit tests
- Contains: `*_spec.lua` test files
- Framework: mini.test

**`scripts/`:**
- Purpose: Build and development scripts
- Contains: Test runner, doc generator

**`.github/workflows/`:**
- Purpose: CI/CD automation
- Contains: GitHub Actions workflows

## Key File Locations

**Entry Points:**
- `plugin/which-key.vim` - Plugin bootstrap
- `lua/which-key/init.lua` - Lua API entry

**Configuration:**
- `lua/which-key/config.lua` - Default config
- `stylua.toml` - Formatting rules
- `selene.toml` - Linting rules

**Core Logic:**
- `lua/which-key/state.lua` - State machine
- `lua/which-key/buf.lua` - Buffer trees
- `lua/which-key/triggers.lua` - Trigger detection

**Testing:**
- `tests/` - All test files
- `scripts/test` - Test runner

## Naming Conventions

**Files:**
- Pattern: snake_case.lua
- Examples: `state.lua`, `buf.lua`, `triggers.lua`

**Directories:**
- Pattern: lowercase
- Examples: `which-key/`, `plugins/`, `tests/`

**Types (LuaCATS):**
- Pattern: PascalCase with `wk.` prefix
- Examples: `wk.State`, `wk.Node`, `wk.Trigger`

**Functions:**
- Pattern: snake_case
- Examples: `M.setup()`, `M.start()`, `M.check()`

**Private Functions:**
- Pattern: Leading underscore
- Examples: `M._run_hooks()`

## Where to Add New Code

**New Feature:**
- Primary code: `lua/which-key/[feature].lua`
- Tests: `tests/[feature]_spec.lua`
- Registration: `lua/which-key/init.lua`

**New Plugin:**
- Implementation: `lua/which-key/plugins/[name].lua`
- Registration: `lua/which-key/config.lua` (plugin list)

**Utilities:**
- Shared helpers: `lua/which-key/util.lua`

## Special Directories

**`doc/`:**
- Purpose: Generated vim help files
- Generated: Yes (via scripts/docs)
- Committed: Yes

**`.tests/`:**
- Purpose: Test runtime artifacts
- Generated: Yes
- Committed: No (in .gitignore)

---

*Structure analysis: 2026-02-24*

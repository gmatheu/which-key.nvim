# Technology Stack

**Analysis Date:** 2026-02-24

## Languages

**Primary:**
- Lua (Lua 5.1 / LuaJIT) - Core plugin implementation in `lua/which-key/`

**Secondary:**
- Vimscript - Plugin entry point in `plugin/which-key.vim`
- Markdown - Documentation

## Runtime

**Environment:**
- Neovim 0.9.4+ (LuaJIT/Lua 5.1 embedded)

**Package Manager:**
- lazy.nvim (for plugin installation)
- No lockfile (plugin distributes as source)

## Frameworks

**Core:**
- Neovim Lua API - `vim.api.*`, `vim.fn.*`, `vim.keymap.*`
- Event-driven architecture with autocmds and timers

**Development Tools:**
- StyLua - Lua code formatting
- Selene - Lua linting
- mini.test - Testing framework

## Key Dependencies

**Runtime:**
- Neovim 0.9.4+ (embedded Lua runtime)
- vim.uv or vim.loop - Async timers and scheduling

**Optional:**
- mini.icons - Icon provider (optional)
- nvim-web-devicons - Alternative icon provider (optional)

**Internal Modules:**
- `lua/which-key/buf.lua` - Buffer state management
- `lua/which-key/config.lua` - Configuration
- `lua/which-key/state.lua` - Core state machine
- `lua/which-key/triggers.lua` - Keymap trigger handling
- `lua/which-key/view.lua` - UI rendering
- `lua/which-key/util.lua` - Utilities

## Configuration

**Environment:**
- No external environment variables required
- Configured via Lua setup() call

**Build Tools:**
- `stylua.toml` - Formatting config (2 spaces, 120 column width)
- `selene.toml` - Linting config (vim std, allows mixed tables)
- `.editorconfig` - Editor settings

**Scripts:**
- `scripts/test` - Run tests
- `scripts/docs` - Generate documentation

## Platform Requirements

**Development:**
- Neovim 0.9.4+
- Lua 5.1 / LuaJIT
- StyLua and Selene for linting/formatting

**Production:**
- Neovim 0.9.4+
- Optional: mini.icons or nvim-web-devicons for icon support

---

*Stack analysis: 2026-02-24*

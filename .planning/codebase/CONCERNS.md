# Codebase Concerns
**Analysis Date:** 2026-02-24
## Tech Debt
**[State machine / asynchronous hooks]:**
- Issue: ModeChanged handling relies on a timer hack.
- Files: `/home/gmatheu/.dotfiles/stow-files/astronvim/dev/which-key.nvim/lua/which-key/state.lua`
- Impact: Potential misses and performance overhead.
## Fragile Areas
**[ModeChanged hack]:**
- Files: `/home/gmatheu/.dotfiles/stow-files/astronvim/dev/which-key.nvim/lua/which-key/state.lua`
- Why fragile: timer-based detection can be flaky across environments.
## Performance Considerations
**[State machine]:**
- Files: `/home/gmatheu/.dotfiles/stow-files/astronvim/dev/which-key.nvim/lua/which-key/state.lua`
- Concern: heavy logic and frequent redraws.

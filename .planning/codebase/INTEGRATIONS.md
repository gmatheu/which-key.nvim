# External Integrations

**Analysis Date:** 2026-02-24

## APIs & External Services

**None directly integrated**
This is a standalone Neovim plugin with no external API calls.

## CI/CD & Deployment

**GitHub Actions:**
- `.github/workflows/ci.yml` - Continuous integration
- `.github/workflows/pr.yml` - PR automation
- `.github/workflows/update.yml` - Dependency updates

**Release Management:**
- Uses folke/github-actions workflows
- release-please for automated releases

## Environment Configuration

**No external services required**
- All configuration via Lua setup() in user config
- No API keys, databases, or external auth needed

**Optional Integrations:**
- mini.icons - For icon display
- nvim-web-devicons - Alternative icon provider

## Documentation Generation

**Tools:**
- `scripts/docs` - Documentation generation script
- LuaCATS type annotations for API docs

## Webhooks & Callbacks

**None**
No incoming or outgoing webhooks.

---

*Integration audit: 2026-02-24*

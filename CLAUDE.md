# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This started as a fork of [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) but has been fully restructured into a modular config under the `sievins` namespace. Nothing from the original kickstart layout remains.

## Commands

### Linting and Formatting

```bash
# Format Lua files with StyLua (must be installed)
stylua .

# Check formatting without modifying
stylua --check .
```

### Health Check

Run inside Neovim:
```
:checkhealth sievins
```

This verifies the Neovim version (requires 0.11+) and external dependencies. Implemented in `lua/sievins/health.lua`, discovered automatically via the `lua/<name>/health.lua` runtimepath convention.

## Architecture

`init.lua` is a small entry point (~46 lines): it loads the config modules, bootstraps lazy.nvim, and imports plugin specs.

```
init.lua                  Entry point
lua/sievins/
  config/                 options.lua, keymaps.lua, autocmds.lua
  util/                   Utilities (provides the sievins.* global): bufdelete, bufhistory, root
  plugins/                One file per plugin spec, imported by lazy.nvim via { import = 'sievins.plugins' }
  health.lua              :checkhealth sievins
```

To add a plugin, create a new file in `lua/sievins/plugins/` returning a lazy.nvim spec.

### Key Technologies

- **lazy.nvim**: Plugin manager with lazy-loading
- **Mason**: LSP/tool installer
- **blink.cmp**: Completion engine
- **snacks.nvim**: Picker (fuzzy finding, grep, git) and other utilities
- **Treesitter**: Syntax highlighting
- **Conform**: Code formatting
- **neo-tree**: File explorer

## Code Style

Enforced via `.stylua.toml`:
- 2 spaces indentation
- 160 column width
- Single quotes preferred
- No call parentheses

Use `vim.o` for options (not `vim.opt`). LSP keybindings follow Neovim 0.11 conventions (gr prefix).

## External Dependencies

Required: `git`, `rg`, `fd`, `lazygit`, `unzip`, `cargo` (blink.cmp build), `node` (Copilot, markdown-preview), C compiler (Treesitter parsers)

Optional: `gh` (snacks issue/PR pickers), Nerd Font (set `vim.g.have_nerd_font = true` if installed)

`:checkhealth sievins` checks for these.

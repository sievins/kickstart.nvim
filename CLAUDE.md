# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a fork of [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) - a minimal, single-file Neovim configuration designed as a starting point. It's intentionally simple and heavily commented for learning purposes.

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
:checkhealth kickstart
```

This verifies Neovim version (requires 0.10+) and external dependencies.

## Architecture

### Single-File Configuration

The entire configuration lives in `init.lua` (~945 lines), organized into sections:
1. Global settings (leader keys, nerd font flag)
2. Vim options (using `vim.o` API)
3. Basic keymaps
4. Autocommands
5. Plugin manager bootstrap (lazy.nvim)
6. Plugin specifications with inline configuration

### Plugin Structure

- **Core plugins**: Defined inline in `init.lua`
- **Optional plugins**: Located in `lua/kickstart/plugins/` - uncomment imports in `init.lua` to enable
- **Custom plugins**: Add to `lua/custom/plugins/init.lua` for personal additions

Currently enabled optional plugin: `neo-tree.lua`

### Key Technologies

- **lazy.nvim**: Plugin manager with lazy-loading
- **Mason**: LSP/tool installer
- **blink.cmp**: Completion engine
- **Telescope**: Fuzzy finder
- **Treesitter**: Syntax highlighting
- **Conform**: Code formatting

## Code Style

Enforced via `.stylua.toml`:
- 2 spaces indentation
- 160 column width
- Single quotes preferred
- No call parentheses

Use `vim.o` for options (not `vim.opt`). LSP keybindings follow Neovim 0.11 conventions (gr prefix).

## External Dependencies

Required: `git`, `make`, `unzip`, C compiler, `ripgrep`, `fd-find`

Optional: Nerd Font (set `vim.g.have_nerd_font = true` if installed)

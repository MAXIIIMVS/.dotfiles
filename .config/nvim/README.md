# My Neovim Configuration

This is my personal Neovim configuration. It is designed for productivity, coding, and personal workflow customization.

> ⚠️ **Warning:** This configuration is tested **only on Ubuntu**.  
> ⚠️ This is for personal use. I do **not** accept PRs and I will **not** provide support for issues.

---

## Requirements

- **Neovim v0.11.6** or later
- **System binaries** (required for full plugin functionality):
  - `git` → used by `gitsigns.nvim`
  - `universal-ctags` → used by `vim-gutentags`
  - `rg` (ripgrep) → used by `todo-comments.nvim` for fast searching
  - `fd` → optional, used by path completions (e.g., `cmp-path`)
  - `fzf` → optional, for fuzzy file finding if integrated
  - `lazygit` → optional, for Git workflow
  - `gnome-pomodoro` → optional, for lualine Pomodoro status
  - `zoxide` → optional, for faster directory navigation
  - LaTeX toolchain (`pdflatex`, `latexmk`, etc.) → used by `vimtex` for LaTeX compilation

> ⚠️ **Note:** Not all of these are mandatory. Missing optional dependencies may break parts of the configuration (e.g., Pomodoro timer, fuzzy file finding, or LaTeX workflow).

## Features

- Async Pomodoro timer in lualine (requires gnome-pomodoro)
- Second-accurate countdown with local timer
- Automatic LSP and Treesitter setup via Mason
- Git integration with gutter signs and lazygit support
- Automatic project root detection (vim-rooter)
- Todo comment highlighting with rg support
- Snippets and completion (LuaSnip + nvim-cmp)
- Dynamic statusline and icons via lualine + web-devicons
- Fast directory navigation with zoxide

## Usage Notes

- Pomodoro timer will only show status if gnome-pomodoro is running.
- LaTeX files require a working LaTeX installation (pdflatex / latexmk) for compilation.
- Git features depend on having git installed and optionally lazygit.
- Todo search requires rg.
- Path completions may benefit from fd being installed.
- Fuzzy finder requires fzf.
- Directory navigation benefits from zoxide.

## Limitations

- Tested only on Ubuntu.
- This is my personal configuration.
- I do not accept PRs.
- I will not provide support for issues.

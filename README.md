# 🛠️ My Dotfiles

**My dotfiles. DON'T USE THEM unless you're me (or know exactly what you're doing). No support, no mercy.**

My personal dotfiles for managing system and app configurations using GNU Stow and Git submodules.

## 📦 Requirements

- Git
- GNU Stow
- A POSIX-compliant shell (bash, zsh, etc.)
- Linux (tested on Ubuntu-based distros)

## 🚀 Installation

### 1. Clone the repo

```bash
git clone --recurse-submodules git@github.com:MAXIIIMVS/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

### 2. Create symlinks with GNU Stow

```bash
stow .
```

---

## 🔄 Updating Submodules

If you use Git submodules (like themes or plugins), update them with:

```bash
git submodule update --remote --merge
git commit -am "Update submodules"
```

---

## 🧠 Tips

- Use `stow -nvt ~ .` to preview what will be symlinked before running `stow .`
- When adding new submodules, remember to `git add .gitmodules` and the submodule folder
- Clone with `--recursive` to automatically pull submodules

---

## 🔒 License

Feel free to fork, or learn from this — but keep your secrets out of your dotfiles 😉.

#!/usr/bin/env bash

# TODO: fix this and commit it

set -euo pipefail

# ──────────────────────────────── Colors ────────────────────────────────
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RESET='\033[0m'

ask_install() {
    local name="$1"
    local check="$2"
    local install_cmd="$3"

    if eval "$check"; then
        echo -e "${GREEN}$name is already installed. Skipping.${RESET}"
    else
        read -rp "$(echo -e \"${YELLOW}Install $name? (y/n) ${RESET}\")" choice
        if [[ "$choice" == [Yy] ]]; then
            eval "$install_cmd"
        else
            echo -e "${YELLOW}Skipped $name.${RESET}"
        fi
    fi
}

# ──────────────────────────── Update System ────────────────────────────
echo -e "${GREEN}Updating system...${RESET}"
sudo apt update
sudo apt full-upgrade -y
sudo snap refresh

# ───────────────────── Core Dev Tools (LTS Focused) ─────────────────────

# Python with pyenv
ask_install "Python build dependencies" "dpkg -s libssl-dev >/dev/null 2>&1" "sudo apt install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev"
ask_install "pyenv" "command -v pyenv >/dev/null" "curl https://pyenv.run | bash && echo -e \"${YELLOW}After install, run:\npyenv install 3.12.4 (or latest LTS)${RESET}\""

# Go (official package)
GO_VERSION="1.24.4"
ask_install "Go $GO_VERSION" "command -v go >/dev/null && go version | grep -q $GO_VERSION" "wget https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz -O /tmp/go.tar.gz && sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf /tmp/go.tar.gz && rm /tmp/go.tar.gz && echo 'export PATH=\$PATH:/usr/local/go/bin' >> ~/.bashrc"

# Rust (stable)
ask_install "Rust (stable)" "command -v rustc >/dev/null" "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable"

# Node.js (LTS via n)
ask_install "Node.js LTS" "command -v node >/dev/null && node --version | grep -q '18.x\|20.x'" "sudo apt install -y nodejs npm && sudo npm install -g n && sudo n lts"

# ────────────────────────────── CLI Tools ──────────────────────────────
ask_install "GNU Stow" "command -v stow >/dev/null" "sudo apt install -y stow"
ask_install "zoxide" "command -v zoxide >/dev/null" "sudo apt install -y zoxide"
ask_install "fzf" "command -v fzf >/dev/null" "sudo apt install -y fzf"
ask_install "ripgrep (rg)" "command -v rg >/dev/null" "sudo apt install -y ripgrep"
ask_install "bat" "command -v bat >/dev/null" "sudo apt install -y bat"
ask_install "fd-find" "command -v fd >/dev/null" "sudo apt install -y fd-find && sudo ln -sf \"$(which fdfind)\" /usr/bin/fd"
ask_install "jq" "command -v jq >/dev/null" "sudo apt install -y jq"

# ─────────────────────────── System Utilities ──────────────────────────
ask_install "curl, git, wget" "command -v curl >/dev/null && command -v git >/dev/null && command -v wget >/dev/null" "sudo apt install -y curl git wget"
ask_install "build-essential" "dpkg -s build-essential >/dev/null 2>&1" "sudo apt install -y build-essential"
ask_install "ufw" "command -v ufw >/dev/null" "sudo apt install -y ufw && sudo ufw enable"
ask_install "flatpak" "command -v flatpak >/dev/null" "sudo apt install -y flatpak"

# ─────────────────────────── Version Check ────────────────────────────
echo -e "\n${GREEN}Current versions:${RESET}"
{
    echo -n "Python: "; python --version 2>/dev/null || python3 --version 2>/dev/null || echo "Not installed"
    echo -n "Go: "; command -v go >/dev/null && go version || echo "Not installed"
    echo -n "Node: "; command -v node >/dev/null && node --version || echo "Not installed"
    echo -n "Rust: "; command -v rustc >/dev/null && rustc --version || echo "Not installed"
} | column -t

# ─────────────────────────────── Cleanup ──────────────────────────────
echo -e "${GREEN}Cleaning up...${RESET}"
sudo flatpak update -y
sudo apt autoremove -y
sudo apt autoclean -y

echo -e "\n${GREEN}Installation complete!${RESET}"
echo -e "${YELLOW}Don't forget to:${RESET}"
echo -e "1. Run 'source ~/.bashrc' or restart your terminal"
echo -e "2. For pyenv: Add to your .bashrc and install Python version"
echo -e "3. Verify all tools with 'command -v <tool>'"

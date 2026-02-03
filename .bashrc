# NOTE: bash background: #171421 or #1D182E or #191724

# cursor color is #FF006D
# NOTE: bash font: patched version of  FiraCode Nerd Font Medium [Mono] (Medium|Retina|SemiBold) 8.5 (icons in nvim-tree are big, no italics) (use tweaks)
# the old version without patch was FiraMono Nerd Font Medium 10.
# NOTE: default color: text: #D0CFCC, background: #1D182E
# NOTE: bold color: #BAC415
# NOTE: cursor color: text: #EFE9F3, background: #FF006D
# no highlight color
# transparent background: like 20%ish

# ╭──────────────────────────────────────────────────────────╮
# │             Settings & Environment Variables             │
# ╰──────────────────────────────────────────────────────────╯

HISTCONTROL=ignoreboth
HISTSIZE=20000
HISTFILESIZE=20000
PROMPT_DIRTRIM=3 # Show last 3 directories in path

# disables Ctrl-S/Ctrl-Q flow control (common for Vim terminals).
stty -ixon

# export SHELL=/usr/bin/bash

export ATAC_KEY_BINDINGS=/home/mustafa/.config/atac/vim_key_bindings.toml
export ATAC_MAIN_DIR=/home/mustafa/code/atac/
export COLORTERM=gnome-terminal
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export DOTNET_ROOT=$HOME/dotnet
export EDITOR="$(which nvim)"
export GOPATH=$HOME/go
export LG_CONFIG_FILE="$HOME/.config/lazygit/config.yml,$HOME/.config/lazygit/themes/catppuccin/themes-mergable/mocha/peach.yml"
export NVM_DIR="$HOME/.nvm"
export VISUAL="$EDITOR"

export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd -t d . $HOME"

# export PATH="$HOME/tools/xpack-gcc-14.2.0-2/bin:$PATH"
# export PATH="$HOME/tools/llvm-20.1.8/bin:$PATH"
# export LD_LIBRARY_PATH="$HOME/tools/llvm-20.1.8/lib:$LD_LIBRARY_PATH"
# export CMAKE_PREFIX_PATH="$HOME/tools/llvm-20.1.8:$CMAKE_PREFIX_PATH"
# export PATH=$PATH:$HOME/.emacs.d/bin
export PATH="$PATH:$GOPATH/bin:$HOME/.local/bin:$HOME/bin"

# [ -d "/usr/local/go/bin" ] && export PATH="$PATH:/usr/local/go/bin"
for p in /usr/local/go/bin \
	/var/lib/flatpak/exports/share \
	/snap/bin \
	"$HOME/.local/share/nvim/mason/bin" \
	"$HOME/bin/premake" \
	"$HOME/dotnet" \
	"$HOME/.local/share/flatpak/exports/share" \
	"$HOME/bin/scriptcs" \
	"$HOME/.cargo/bin" \
	"$HOME/.local/kitty.app/bin" \
	"$HOME/bin/dart-sass"; do
	[ -d "$p" ] && PATH="$PATH:$p"
done
export PATH

# ╭──────────────────────────────────────────────────────────╮
# │                 Interactive Shell Check                  │
# ╰──────────────────────────────────────────────────────────╯

case $- in
*i*) ;;
*) return ;;
esac

# ╭──────────────────────────────────────────────────────────╮
# │                      Shell Options                       │
# ╰──────────────────────────────────────────────────────────╯

# Append to the history file, rather than overwriting it
shopt -s histappend
# Update LINES and COLUMNS after each command, useful if terminal resized
shopt -s checkwinsize
# Allow ** to recursively match directories (e.g., `ls **/*.c`)
shopt -s globstar
# Allow `cd dir` without typing `cd`
shopt -s autocd
# Match hidden files in globs
shopt -s dotglob
# Minor spelling correction for cd
shopt -s cdspell
# Case-insensitive globbing
shopt -s nocaseglob
# Save multi-line commands as single history entry
shopt -s cmdhist
# Show history command before executing (! expansion)
shopt -s histverify

# ╭──────────────────────────────────────────────────────────╮
# │             Source External Scripts / Tools              │
# ╰──────────────────────────────────────────────────────────╯

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

[ -x "$(command -v zoxide)" ] && eval "$(zoxide init bash)"

# enable fzf key-bindings for bash
command -v fzf >/dev/null 2>&1 && source /usr/share/doc/fzf/examples/key-bindings.bash

# ╭──────────────────────────────────────────────────────────╮
# │                        Functions                         │
# ╰──────────────────────────────────────────────────────────╯

toggle_proxy() {
	if [ "$1" == "on" ]; then
		export http_proxy="http://127.0.0.1:12334/"
		export https_proxy="http://127.0.0.1:12334/"
		export ftp_proxy="http://127.0.0.1:12334/"
		export all_proxy="socks5://127.0.0.1:9050/"
		echo "Proxy enabled."
	elif [ "$1" == "off" ]; then
		unset http_proxy
		unset https_proxy
		unset ftp_proxy
		unset all_proxy
		echo "Proxy disabled."
	else
		echo "Usage: toggle_proxy [on|off]"
	fi
}

pyproxy() {
	mirrors=(
		"Default (PyPI) https://pypi.org/simple"
		"Tsinghua University https://pypi.tuna.tsinghua.edu.cn/simple"
		"Alibaba Cloud https://mirrors.aliyun.com/pypi/simple"
		"USTC (University of Science and Technology of China) https://pypi.mirrors.ustc.edu.cn/simple"
		"Douban https://pypi.doubanio.com/simple"
		"Huawei Cloud https://repo.huaweicloud.com/repository/pypi/simple"
		"Tencent Cloud https://mirrors.cloud.tencent.com/pypi/simple"
		"163 (NetEase) https://mirrors.163.com/pypi/simple"
		"Kakao https://pypi.kakao.com/simple"
		"Yandex https://mirror.yandex.ru/mirrors/pypi/simple"
		"LUG (Linux User Group) https://ftp.lug.ro/pypi/simple"
		"Mirrors ISPConfig https://pypi.mirrors.ustc.edu.cn/simple"
		"FossAsia https://pypi.fossasia.org/simple"
		"Univ. of Belgrade http://pypi.rcub.bg.ac.rs/simple"
		"FreeBSD https://ftp-archive.freebsd.org/pub/FreeBSD/pypi/simple"
		"Japan https://pypi.jp/simple"
		"Python Panama https://pypi.panama.org/simple"
		"Columbia http://mirror.edatel.net.co/pypi/simple"
		"Finnish University http://ftp.funet.fi/pub/mirrors/pypi/simple"
		"OpenSUSE https://download.opensuse.org/repositories/devel:/languages:/python:/pypi/simple"
		"Australian National University https://mirror.its.anu.edu.au/pub/pypi/simple"
		"University of British Columbia http://ftp.ubc.ca/mirror/pypi/simple"
		"MIT https://pypi.mit.edu/simple"
		"Python Venezuela https://pypi.ve/simple"
		"Iceland University https://ftp.hi.is/pub/pypi/simple"
	)

	echo "Select a Python mirror to use with pip:"
	PS3="Enter the number of your choice: "

	select mirror in "${mirrors[@]}"; do
		case $REPLY in
		1)
			export PIP_INDEX_URL="https://pypi.org/simple"
			break
			;;
		2)
			export PIP_INDEX_URL="https://pypi.tuna.tsinghua.edu.cn/simple"
			break
			;;
		3)
			export PIP_INDEX_URL="https://mirrors.aliyun.com/pypi/simple"
			break
			;;
		4)
			export PIP_INDEX_URL="https://pypi.mirrors.ustc.edu.cn/simple"
			break
			;;
		5)
			export PIP_INDEX_URL="https://pypi.doubanio.com/simple"
			break
			;;
		6)
			export PIP_INDEX_URL="https://repo.huaweicloud.com/repository/pypi/simple"
			break
			;;
		7)
			export PIP_INDEX_URL="https://mirrors.cloud.tencent.com/pypi/simple"
			break
			;;
		8)
			export PIP_INDEX_URL="https://mirrors.163.com/pypi/simple"
			break
			;;
		9)
			export PIP_INDEX_URL="https://pypi.kakao.com/simple"
			break
			;;
		10)
			export PIP_INDEX_URL="https://mirror.yandex.ru/mirrors/pypi/simple"
			break
			;;
		11)
			export PIP_INDEX_URL="https://ftp.lug.ro/pypi/simple"
			break
			;;
		12)
			export PIP_INDEX_URL="https://pypi.mirrors.ustc.edu.cn/simple"
			break
			;;
		13)
			export PIP_INDEX_URL="https://pypi.fossasia.org/simple"
			break
			;;
		14)
			export PIP_INDEX_URL="http://pypi.rcub.bg.ac.rs/simple"
			break
			;;
		15)
			export PIP_INDEX_URL="https://ftp-archive.freebsd.org/pub/FreeBSD/pypi/simple"
			break
			;;
		16)
			export PIP_INDEX_URL="https://pypi.jp/simple"
			break
			;;
		17)
			export PIP_INDEX_URL="https://pypi.panama.org/simple"
			break
			;;
		18)
			export PIP_INDEX_URL="http://mirror.edatel.net.co/pypi/simple"
			break
			;;
		19)
			export PIP_INDEX_URL="http://ftp.funet.fi/pub/mirrors/pypi/simple"
			break
			;;
		20)
			export PIP_INDEX_URL="https://download.opensuse.org/repositories/devel:/languages:/python:/pypi/simple"
			break
			;;
		21)
			export PIP_INDEX_URL="https://mirror.its.anu.edu.au/pub/pypi/simple"
			break
			;;
		22)
			export PIP_INDEX_URL="http://ftp.ubc.ca/mirror/pypi/simple"
			break
			;;
		23)
			export PIP_INDEX_URL="https://pypi.mit.edu/simple"
			break
			;;
		24)
			export PIP_INDEX_URL="https://pypi.ve/simple"
			break
			;;
		25)
			export PIP_INDEX_URL="https://ftp.hi.is/pub/pypi/simple"
			break
			;;
		*)
			echo "Invalid option. Please try again."
			continue
			;;
		esac
	done

	echo "Using Python mirror: $PIP_INDEX_URL"
}

# Function to reset pip mirror to default
reset_pip_mirror() {
	unset PIP_INDEX_URL
	echo "Reset pip mirror to default (PyPI)"
}

goproxy() {
	export GOPROXY=https://goproxy.io,direct
}

function rustproxy() {
	MIRRORS=(
		"https://rsproxy.cn"
		"https://mirrors.cloud.tencent.com/crates.io-index/"
		"https://europe.mirror.rs"
		"https://mirrors.ustc.edu.cn/crates.io-index/"
		"https://mirrors.sjtug.sjtu.edu.cn/crates.io-index/"
	)
	echo "Select a crates.io mirror:"
	select MIRROR_URL in "${MIRRORS[@]}"; do
		if [[ -n $MIRROR_URL ]]; then
			# Export the environment variable to use the selected mirror
			export CARGO_REGISTRIES_CRATES_IO_PROTOCOL="sparse"
			export CARGO_REGISTRIES_CRATES_IO_INDEX="https://index.crates.io"
			export CARGO_REGISTRIES_MIRROR_INDEX=$MIRROR_URL
			echo "Switched to mirror: $MIRROR_URL"
			return
		else
			echo "Invalid selection. Please try again."
		fi
	done
}

v() {
	command nvim "$@"

	if [ -n "$TMUX" ]; then
		tmux set -g status-style bg=default
	fi
}

function git_commits_ahead() {
	local start_commit=$(git rev-list --max-parents=0 HEAD)
	local end_commit=$(git rev-parse HEAD)

	if [ -z "$start_commit" ] || [ -z "$end_commit" ]; then
		echo "Error: Could not find starting or ending commit."
		return 1
	fi

	git rev-list --count ${start_commit}^..${end_commit}
}

gn() {
	# Check if we're in a git repository
	if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
		echo "Not in a git repository"
		return 1
	fi

	# Check if there are any commits in the current branch
	if ! git rev-parse HEAD >/dev/null 2>&1; then
		echo "No commits in the current branch"
		return 1
	fi

	# Try to get the name of the remote branch that the HEAD points to
	local branch=""
	if git rev-parse refs/remotes/origin/HEAD >/dev/null 2>&1; then
		branch=$(git branch -r --points-at refs/remotes/origin/HEAD | grep '\->' | cut -d' ' -f5 | cut -d/ -f2)
	fi

	if [ -z "$branch" ]; then
		# Fallback: Extract branch name another method
		branch=$(basename $(git rev-parse --show-toplevel)/.git/refs/heads/*)
	fi

	# If there's still no branch or an error, perform another fallback action
	if [ -z "$branch" ]; then
		local fallback_branch=$(git remote show origin | sed -n '/HEAD branch/s/.*: //p')
		local next_commit=$(git rev-list --topo-order HEAD..$fallback_branch | tail -1)
		git checkout $next_commit
		return
	fi

	# Get the hash of the next commit
	local next_commit=$(git log --reverse --pretty=%H $branch | grep -A 1 $(git rev-parse HEAD) | tail -n1)

	# If there's no next commit, we're already at the last commit
	if [ -z "$next_commit" ]; then
		echo "Already at the last commit"
		return 1
	fi

	# Try to checkout the next commit, and use the fallback command in case of an error
	git checkout $next_commit
}

gp() {
	if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
		echo "Not in a git repository"
		return 1
	fi

	# Check if there are any commits in the current branch
	if ! git rev-parse HEAD >/dev/null 2>&1; then
		echo "No commits in the current branch"
		return 1
	fi
	git checkout HEAD^1
}

function git_pull_subdirectories() {
	local parent_dir="$1"

	# Check if the parent directory exists
	if [ ! -d "$parent_dir" ]; then
		echo "Directory '$parent_dir' does not exist."
		return 1
	fi

	# Check if 'git' is installed
	if ! command -v git &>/dev/null; then
		echo "Git is not installed."
		return 1
	fi

	# Iterate over subdirectories in the parent directory
	for dir in "$parent_dir"/*; do
		if [ -d "$dir" ]; then
			echo "Navigating into directory: $dir"
			cd "$dir" || continue

			# Check if the directory is a Git repository
			if [ -d ".git" ]; then
				echo "Performing 'git pull' in: $dir"
				git pull
			else
				echo "Skipped: $dir (not a Git repository)"
			fi

			# Return to the parent directory
			cd - >/dev/null
		fi
	done
}

gdbtty() {
	local id="$(tmux split-pane -hPF "#D" "tail -f /dev/null")"
	tmux last-pane
	local tty="$(tmux display-message -p -t "$id" '#{pane_tty}')"
	gdb -ex "dashboard -output $tty" "$@"
	tmux kill-pane -t "$id"
}

killport() {
	if [ -z "$1" ]; then
		echo "Please provide a port number."
		return 1
	fi
	kill -9 $(lsof -t -i:"$1") 2>/dev/null
	if [ $? -eq 0 ]; then
		echo "Killed process running on port $1."
	else
		echo "No process found running on port $1."
	fi
}

toggle_transparent_background() {
	# Check if dconf command exists
	if ! command -v dconf >/dev/null 2>&1; then
		echo "Error: dconf command not found."
		return 1
	fi

	# Get the default profile ID
	default_profile=$(dconf list /org/gnome/terminal/legacy/profiles:/ | grep '^:')
	profile_id=$(echo "$default_profile" | sed 's/\///')

	# Check if the profile ID is empty
	if [[ -z "$profile_id" ]]; then
		echo "Error: Failed to retrieve the default profile ID."
		return 1
	fi

	# Get the current value of use-transparent-background
	current_value=$(dconf read "/org/gnome/terminal/legacy/profiles:/$profile_id/use-transparent-background")

	# Toggle the value
	if [[ "$current_value" == "true" ]]; then
		new_value="false"
	else
		new_value="true"
	fi

	# Write the new value to dconf
	dconf write "/org/gnome/terminal/legacy/profiles:/$profile_id/use-transparent-background" "$new_value"

	# Reset the terminal within tmux
	tmux send-keys -t 0.0 C-l

	# echo "use-transparent-background toggled to $new_value"
}

dict() {
	word=$1
	command dict "$word" | bat
}

uu() {
	sudo apt update
	sudo apt full-upgrade -y
	sudo apt autoremove -y
	sudo apt autoclean
	sudo snap refresh
	sudo flatpak update -y
}

# NOTE: how to use:
# first use wgdb to compile the program: `wgdb myprogram main.cpp utility.cpp`.
# debug the program and when you want to change the code press Ctrl+C.
# make the desired modifications.
# Go back to debugger and press Enter
function wgdb() {
	local program_name="$1"
	local source_files="$2"
	local compiler_flags="-g"

	# Compile the program
	g++ $compiler_flags $source_files -o $program_name

	# Start GDB
	gdb -ex "break main" -ex "run" ./$program_name

	# Loop for hot-reloading
	while true; do
		# Wait for Ctrl+C to pause execution
		read -p "Press Ctrl+C to pause execution and edit code. Press Enter to reload."

		# Check if the program is still running
		if pgrep -x "$program_name" >/dev/null; then
			# Kill the program
			pkill -x $program_name

			# Recompile the modified source files
			g++ $compiler_flags $source_files -o $program_name

			# Restart the program under GDB
			gdb -ex "break main" -ex "run" ./$program_name
		else
			echo "Program has exited."
			break
		fi
	done
}

# kill a process
k() {
	ps aux | fzf | awk '{print $2}' | xargs kill -9
}

# history
h() {
	local cmd=$(history | fzf | awk '{print $1}')
	[ -n "$cmd" ] && fc -s "$cmd"
}

# open any file
function o() {
	local file
	file=$(fzf)
	[[ -n "$file" ]] && open "$file"
}

function pipmir() {
	# source host:
	# https://mirror-pypi.runflare.com
	# https://pypi.tuna.tsinghua.edu.cn
	# https://mirrors.aliyun.com
	# https://pypi.mirrors.ustc.edu.cn
	# https://repo.huaweicloud.com
	# http://pypi.douban.com
	# http://pypi.sdutlinux.org

	# source adderess:
	# https://mirrors.sustech.edu.cn/pypi/simple
	# https://mirror-pypi.runflare.com/simple/
	# https://pypi.tuna.tsinghua.edu.cn/simple/
	# https://mirrors.aliyun.com/pypi/simple/
	# https://pypi.mirrors.ustc.edu.cn/simple/
	# https://repo.huaweicloud.com/repository/pypi/simple/
	# http://pypi.douban.com/simple/
	# http://pypi.sdutlinux.org/
	pip config set global.index 'https://pypi.mirrors.ustc.edu.cn'
	pip config set global.index-url 'https://pypi.mirrors.ustc.edu.cn/simple/'
}

# watch a directory and run arbitrary commands
watchdir() {
	if [ $# -lt 2 ]; then
		echo "Usage: we <directory> <command>"
		return 1
	fi

	local dir="$1"
	local cmd="$2"

	if [ ! -d "$dir" ]; then
		echo "Error: Directory '$dir' does not exist."
		return 1
	fi

	echo
	ls "$dir" | entr -c "$cmd"
}

# execute with nvidia
x-nvidia() {
	__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia "$@"
}

# ╭──────────────────────────────────────────────────────────╮
# │   Conditional Logic / OS-specific / Interactive checks   │
# ╰──────────────────────────────────────────────────────────╯

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
	debian_chroot=$(cat /etc/debian_chroot)
fi

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
	if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
		# We have color support; assume it's compliant with Ecma-48
		# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
		# a case would tend to support setf rather than setaf.)
		color_prompt=yes
	else
		color_prompt=
	fi
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
	alias ls='ls --color=auto -h'
	#alias dir='dir --color=auto'
	#alias vdir='vdir --color=auto'

	alias grep='grep --color=auto'
	alias fgrep='fgrep --color=auto'
	alias egrep='egrep --color=auto'
fi

if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
		. /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
		. /etc/bash_completion
	fi
fi

# # start tmux automatically
# if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
#   exec tmux
# fi

# ╭──────────────────────────────────────────────────────────╮
# │                          Prompt                          │
# ╰──────────────────────────────────────────────────────────╯

case "$TERM" in
xterm-color | *-256color) color_prompt=yes ;;
esac

if [ -f /usr/share/git/completion/git-prompt.sh ]; then
	source /usr/share/git/completion/git-prompt.sh
elif [ -f /usr/share/bash-completion/completions/git ]; then
	source /usr/share/bash-completion/completions/git
fi

if [ "$color_prompt" = yes ]; then
	PS1='\n\[\e[0;1;38;5;28m\]┌── \u\[\e[0;38;5;28m\]☠️\h\[\e[0m\]:\[\e[0;38;5;161m\]$(__git_ps1 "%s")\[\e[0m\]: \[\e[0;38;5;32m\]\w\[\e[0;38;5;32m\]/ \[\e[1;7;38;5;82m\]\n\[\e[0;1;38;5;28m\]└─ \[\e[0;38;5;39m\]\[\e[0m\]'
else
	PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w '
fi

force_color_prompt=yes
unset color_prompt force_color_prompt

case "$TERM" in
xterm* | rxvt*)
	PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
	;;
*) ;;
esac

# ╭──────────────────────────────────────────────────────────╮
# │              Debugging / Tracing / Cleanup               │
# ╰──────────────────────────────────────────────────────────╯

exec {BASH_XTRACEFD}>/dev/null

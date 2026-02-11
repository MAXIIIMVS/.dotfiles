# ╭──────────────────────────────────────────────────────────╮
# │                         Aliases                          │
# ╰──────────────────────────────────────────────────────────╯

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias tmux='tmux -2'
alias t='tmux -2'
alias mouse='watch -n 1 xkbset ma 60 10 10 5 10'
alias gg17='g++ -std=c++17 -g -Wconversion -Wshadow -Wpedantic -Wall -Weffc++ -Wextra -Wsign-conversion -Werror -pedantic-errors -o a.out'
alias gg='g++ -std=c++2a -ggdb3 -O0 -pg -Wconversion -Wshadow -Wpedantic -Wall -Wextra -Wsign-conversion -Werror -pedantic-errors -o a.out'
alias cg='clang++ -std=c++2a -ggdb3 -O0 -pg -Wconversion -Wshadow -Wpedantic -Wall -Wextra -Wsign-conversion -Werror -pedantic-errors -o a.out'
alias ggr='g++ -std=c++2a -Wconversion -Wshadow -Wpedantic -O2 -DNDEBUG -Wall -Wextra -Wsign-conversion -Werror -pedantic-errors -o a.out'
alias lg='lazygit'
alias p8='ping 8.8.8.8'
alias vb="nvim ~/.bashrc"
alias vt="nvim ~/.tmux.conf"
alias gdvim="nvim --listen /tmp/godot.pipe"
alias f="fzf"
# Sync vimwiki notes with google drive
alias gds="google-drive-ocamlfuse ~/myGoogleDrive/ && cp ~/notes/wiki/ ~/myGoogleDrive/ -r && echo copied! && fusermount -u ~/myGoogleDrive"
alias mnt="mount | awk -F' ' '{ printf \"%s\t%s\n\",\$1,\$3; }' | column -t | egrep ^/dev/ | sort"
alias fastdl='aria2c -c -x 16 -s 16 --max-tries=0 --retry-wait=5'
alias fasttorrent='aria2c --enable-dht=true --enable-peer-exchange=true --follow-torrent=true --seed-time=0 '
alias cpv='rsync -ah --info=progress2'
alias dptrace='echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope' # disable ptrace_scope
alias eptrace='echo 1 | sudo tee /proc/sys/kernel/yama/ptrace_scope' # enable ptrace_scope
alias dulimit='ulimit -c unlimited'
alias eulimit='ulimit -c 0'
alias unite="gnome-extensions prefs unite@hardpixel.eu"
alias l="ls -a"
alias ll="ls -halitF"
alias lt="tree"
alias cd..='cd ..'
alias d='dict'
alias cmg="cmake -S . -B ./build -DCMAKE_BUILD_TYPE=Debug -DCMAKE_EXPORT_COMPILE_COMMANDS=ON"
alias cmgn="cmake -S . -B ./build -G Ninja -DCMAKE_BUILD_TYPE=Debug -DCMAKE_EXPORT_COMPILE_COMMANDS=ON"
alias cmgr="cmake -S . -B ./build -DCMAKE_BUILD_TYPE=Release"
alias cmb="cmake --build ./build"
alias cmbc="cmake --build ./build -t clean"
alias cmbcf="cmake --build ./build --clean-first"
alias cmbr="cmake --build ./build && cd ./build/bin/ && ./main && cd ../../ > /dev/null 2>&1"
alias cmr="cd ./build/bin/ && ./main && cd ../../ > /dev/null 2>&1"
alias cmt="cd ./build && ctest --schedule-random --output-on-failure && cd - > /dev/null 2>&1"
alias cmd="cmake --build ./build --target debugger"
alias cmi="cmake --install ./build"
alias py="python3.12"
alias sucker="sudo docker"
alias pipset="pip config set global.index-url 'https://mirrors.sustech.edu.cn/pypi/simple'"
alias pipunset="pip config unset global.index-url"
alias diff="diff --color=always"

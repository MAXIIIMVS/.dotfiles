-- ╭─────────────────────────────────────────────────────────╮
-- │              Local Variables and Settings               │
-- ╰─────────────────────────────────────────────────────────╯

vim.g.termdebug_wide = true
vim.g.termdebug_map_K = false
-- vim.g.termdebug_disasm_window = 15

local transparency_path = vim.fn.expand("$HOME/.cache/nvim/transparency")
signs = {
	Error = " ",
	Warn = " ",
	Hint = " ",
	Info = " ",
}
local diagnostics_enabled = true

local abbrs = {
	[":pi:"] = "𝞹",
	[":micro:"] = "μ",
	[":deathly:"] = "⏃",
	[":separator_ltt:"] = "❮",
	[":separator_rtt:"] = "❯",
	[":degrees:"] = "°",
	[":wp:"] = "♟",
	[":bp:"] = "♙",
	[":wk:"] = "♚",
	[":bk:"] = "♔",
	[":wq:"] = "♛",
	[":bq:"] = "♕",
	[":wb:"] = "♝",
	[":bb:"] = "♗",
	[":wn:"] = "♞",
	[":bn:"] = "♘",
	[":wr:"] = "♜",
	[":br:"] = "♖",
}
-- ╭─────────────────────────────────────────────────────────╮
-- │                    Core Vim Settings                    │
-- ╰─────────────────────────────────────────────────────────╯

local diagnostics_config = vim.diagnostic.config({
	virtual_text = { current_line = true, prefix = "●" },
	severity_sort = true,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = signs.Error,
			[vim.diagnostic.severity.WARN] = signs.Warn,
			[vim.diagnostic.severity.HINT] = signs.Hint,
			[vim.diagnostic.severity.INFO] = signs.Info,
		},
	},
	underline = {
		severity = vim.diagnostic.severity.ERROR,
	},
	jump = {
		on_jump = function(diagnostic, bufnr)
			if not diagnostic then
				return
			end
			vim.diagnostic.show(nil, bufnr, nil, {
				virtual_text = false,
				virtual_lines = false,
			})
			vim.diagnostic.open_float({
				bufnr = bufnr,
				scope = "cursor",
				focus = false,
			})
			local group = vim.api.nvim_create_augroup("RestoreDiagnosticsOnMove", { clear = true })
			vim.api.nvim_create_autocmd("CursorMoved", {
				group = group,
				buffer = bufnr,
				once = true,
				callback = function()
					vim.diagnostic.show(nil, bufnr)
				end,
			})
		end,
	},
})

-- vim.o.omnifunc = 'syntaxcomplete#Complete'
-- vim.o.autocomplete = true
vim.wo.winblend = 0
vim.o.pumblend = 0
vim.o.errorbells = false
vim.o.belloff = "all"
vim.o.confirm = true
if vim.fn.has("gui_running") == 1 then
	vim.o.guifont = "FiraCode Nerd Font Medium:h9"
end
vim.g.scrollopt = "ver,hor,jump"
vim.schedule(function()
	vim.opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard
end)
vim.o.mouse = "a"
-- vim.o.mousemoveevent = true
vim.o.autoread = true
vim.opt.sessionoptions = { "buffers", "tabpages", "globals", "winsize", "winpos", "folds", "help", "terminal" }
vim.bo.swapfile = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
-- NOTE: use the default path for undodir.
-- vim.opt.undodir = os.getenv("HOME") .. "/.config/undodir"
vim.o.showmode = false
vim.bo.textwidth = 80
-- vim.wo.colorcolumn = "80"
vim.wo.linebreak = true
-- vim.o.autochdir = true -- conflict with vim-rooter
vim.o.hidden = true
vim.o.wildmenu = true
vim.o.wildmode = "longest:full,full"
-- vim.g.wildoptions = "pum"
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.updatetime = 350
vim.wo.foldenable = true
vim.o.foldlevelstart = 99
-- vim.wo.foldnestmax = 10
vim.wo.foldmethod = "indent" -- manual, indent, syntax, marker, expr, diff
vim.wo.conceallevel = 0
vim.g.python3_host_prog = "/usr/bin/python3"
-- vim.o.smarttab = true
-- b.smartindent = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
-- vim.o.softtabstop = 2
vim.o.autoindent = true
vim.bo.autoindent = true
vim.o.breakindent = true
-- vim.o.expandtab = true
-- vim.bo.expandtab = true
vim.o.nrformats = "bin,octal,hex"
vim.o.fillchars = "eob: "
vim.o.winborder = "rounded"
-- vim.o.pumborder = "rounded"
-- vim.o.pummaxwidth = 40
vim.o.completeopt = "menu,menuone,noinsert,noselect"
vim.o.cursorlineopt = "number,line"
vim.o.list = true
vim.o.listchars = "trail:,nbsp:.,precedes:❮,extends:❯,tab:  "
-- vim.g.sessionoptions = "buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,globals" -- removed blank
vim.wo.spell = false
vim.o.spellcapcheck = ""
vim.wo.number = true
vim.wo.relativenumber = true
vim.wo.signcolumn = "yes:1"
vim.o.fileencodings = "utf-8,sjis,euc-jp,latin"
vim.o.encoding = "utf-8"
vim.o.title = true
vim.o.autoindent = true
vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.showcmd = true
vim.o.cmdheight = 0
vim.o.scrolloff = 1
vim.o.timeoutlen = 300
vim.o.inccommand = "split"
vim.o.ruler = false
vim.o.showmatch = true
vim.o.matchtime = 2
vim.o.lazyredraw = false
vim.o.ignorecase = true -- ignore case when searching
vim.o.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive
vim.o.backspace = "start,eol,indent"
vim.opt.path:append("**") -- NOTE: this is slow
vim.opt.wildignore:append({
	"*/node_modules/*",
	"tags",
	"*.o",
	"*/vendor/*",
	"*/build/*",
	"*/external/*",
	"*.obj",
	"*.pyc",
	"*.class",
	"*/.git/*",
	"*/.svn/*",
})
vim.o.wildignorecase = true
vim.o.termbidi = true

if vim.fn.exists("&termguicolors") == 1 and vim.fn.exists("&winblend") then
	-- vim.cmd("syntax enable")
	vim.o.termguicolors = true
	vim.o.wildoptions = "pum"
	vim.wo.winblend = 0
	vim.o.pumblend = 0
	vim.o.background = "dark"
end

-- Prefer rg > ag > ack
if vim.fn.executable("rg") == 1 then
	vim.g.ackprg = "rg -S --no-heading --vimgrep"
	vim.o.grepprg = "rg --vimgrep $*"
elseif vim.fn.executable("ag") == 1 then
	vim.g.ackprg = "ag --vimgrep"
	vim.o.grepprg = "ag --vimgrep $*"
end

vim.o.grepformat = "%f:%l:%c:%m"

-- ╭─────────────────────────────────────────────────────────╮
-- │                Vimscript-style Commands                 │
-- ╰─────────────────────────────────────────────────────────╯

for lhs, rhs in pairs(abbrs) do
	vim.cmd(string.format("iabbrev %s %s", lhs, rhs))
end

vim.cmd([[
nmap <C-_> gcc
xmap <C-_> gc
smap <C-_> <ESC><ESC>gcc
imap <C-_> <ESC>gcc
nmap <C-/> gcc
xmap <C-/> gc
smap <C-/> <ESC><ESC>gcc
imap <C-/> <ESC>gcc


" Disable while using noice.nvim
" augroup CmdHeight
"     autocmd!
"     autocmd CmdlineEnter * if &cmdheight == 0 | let g:cmdheight_prev = 0 | set cmdheight=1 | endif
"     autocmd CmdlineLeave * if exists('g:cmdheight_prev') && g:cmdheight_prev == 0 | set cmdheight=0 | unlet! g:cmdheight_prev | endif
" augroup END

" hide tmux
" autocmd VimEnter,VimLeave * silent !tmux set status
" autocmd VimLeave * silent !tmux set -g status-style bg=default


function! CloseTabAndBuffers()
  " Get the list of buffers in the current tab
  let l:tab_buffers = []
  for w in range(1, tabpagewinnr(tabpagenr(), '$'))
    call add(l:tab_buffers, winbufnr(w))
  endfor
  " Close the tab
  tabclose
  " Close all buffers that were in the tab
  for buf in l:tab_buffers
    if bufexists(buf) && buflisted(buf)
      " Make buffer modifiable if it isn't
      if !getbufvar(buf, '&modifiable')
        call setbufvar(buf, '&modifiable', 1)
      endif
      " Delete the buffer
      execute 'bdelete' buf
    endif
  endfor
endfunction

augroup NetrwSettings
  autocmd!
  autocmd WinClosed * if &filetype == 'netrw' | let g:NetrwIsOpen = 0 | endif
augroup END

let g:NetrwIsOpen=0

function! CloseNetrw() abort
  for bufn in range(1, bufnr('$'))
    if bufexists(bufn) && getbufvar(bufn, '&filetype') ==# 'netrw'
      silent! execute 'bwipeout ' . bufn
      if getline(2) =~# '^" Netrw '
        silent! bwipeout
      endif
      let g:NetrwIsOpen=0
      return
    endif
  endfor
endfunction

augroup closeOnOpen
  autocmd!
  autocmd BufWinEnter * if getbufvar(winbufnr(winnr()), "&filetype") != "netrw"|call CloseNetrw()|endif
aug END

function! ToggleNetrw()
    let g:netrw_winsize = -40
    if g:NetrwIsOpen
        let i = bufnr("$")
        while (i >= 1)
            if (getbufvar(i, "&filetype") == "netrw")
                silent exe "bwipeout " . i
            endif
            let i-=1
        endwhile
        let g:NetrwIsOpen=0
    else
        let g:NetrwIsOpen=1
				let @n = expand("%:p:h")
        silent Lexplore %:p:h
    endif
endfunction
]])

-- ╭─────────────────────────────────────────────────────────╮
-- │                        Functions                        │
-- ╰─────────────────────────────────────────────────────────╯

function save_session()
	pcall(vim.cmd, "ScopeSaveState")
	local session_name = vim.g.last_session_owner or vim.fn.getcwd()
	require("resession").save(session_name, { dir = "dirsession", notify = true })
	if vim.g.last_session_owner == nil then
		vim.g.last_session_owner = session_name
	end
end

function load_session()
	local target = vim.fn.getcwd()
	local ok, err = pcall(function()
		require("resession").load(target, { dir = "dirsession", notify = false })
	end)
	if ok then
		vim.g.last_session_owner = target
		vim.cmd("ScopeLoadState")
	else
		local session_files = vim.fs.find("Session.vim", {
			path = target,
			upward = false, -- Only look downwards into the current root
			limit = 1,
		})
		if #session_files > 0 then
			local session_path = session_files[1]
			pcall(vim.cmd, "source " .. vim.fn.fnameescape(session_path))
			save_session()
			vim.notify("Converted legacy Session.vim to resession for: " .. target, vim.log.levels.INFO)
		else
			vim.g.last_session_owner = nil
			vim.notify("No session found or failed to load: " .. target, vim.log.levels.WARN)
		end
	end
end

function lsp_disabled()
	local cwd = vim.fn.getcwd()
	return vim.fn.filereadable(cwd .. "/.disable_lsp") == 1
		or vim.fn.filereadable(cwd .. "/.disable_lsp_and_null-ls") == 1
end

function null_ls_disabled()
	local cwd = vim.fn.getcwd()
	return vim.fn.filereadable(cwd .. "/.disable_null-ls") == 1
		or vim.fn.filereadable(cwd .. "/.disable_lsp_and_null-ls") == 1
end

function goto_comment(forward)
	-- 1. Check if we are in diff mode
	if vim.wo.diff then
		-- Feed keys using 'n' (noremap) so it triggers Neovim's built-in diff jump
		local key = forward and "]c" or "[c"
		local escaped = vim.api.nvim_replace_termcodes(key, true, false, true)
		vim.api.nvim_feedkeys(escaped, "n", false)
		return
	end

	-- 2. Treesitter availability check
	local has_parser, parser = pcall(vim.treesitter.get_parser, 0)
	if not has_parser or not parser then
		return
	end

	local cursor_row, cursor_col = unpack(vim.api.nvim_win_get_cursor(0))
	cursor_row = cursor_row - 1

	local ft = vim.bo.filetype
	local has_query, query = pcall(vim.treesitter.query.get, ft, "highlights")
	if not has_query or not query then
		pcall(function()
			query = vim.treesitter.query.parse(ft, "((comment) @comment)")
		end)
	end
	if not query then
		return
	end

	local root = parser:parse()[1]:root()
	local target_pos = nil

	for id, node in query:iter_captures(root, 0) do
		local capture_name = query.captures[id]
		if capture_name == "comment" then
			local start_row, start_col, _, _ = node:range()

			if forward then
				if start_row > cursor_row or (start_row == cursor_row and start_col > cursor_col) then
					target_pos = { start_row + 1, start_col }
					break
				end
			else
				if start_row < cursor_row or (start_row == cursor_row and start_col < cursor_col) then
					target_pos = { start_row + 1, start_col }
				end
			end
		end
	end

	if target_pos then
		vim.cmd("normal! m'") -- Save to jumplist
		vim.api.nvim_win_set_cursor(0, target_pos)
	end
end

function pomodoro_break(length)
	-- NOTE: length can be "short-break" or "long-break"
	local cmd = {
		"gdbus",
		"call",
		"--session",
		"--dest",
		"org.gnome.Pomodoro",
		"--object-path",
		"/org/gnome/Pomodoro",
		"--method",
		"org.gnome.Pomodoro.SetState",
		length,
		"0",
	}

	vim.system(cmd, { text = true }, function(obj)
		if obj.code ~= 0 then
			vim.notify("Pomodoro break failed:\n" .. (obj.stderr or ""), vim.log.levels.ERROR)
		end
	end)
end

function openURL(url)
	local open_command
	if vim.fn.has("unix") == 1 then
		open_command = "xdg-open"
	elseif vim.fn.has("mac") == 1 then
		open_command = "open"
	elseif vim.fn.has("win32") == 1 then
		open_command = "start"
	else
		print("Unsupported OS for opening the browser.")
		return
	end
	vim.fn.system(open_command .. " " .. vim.fn.shellescape(url))
end

function get_transparency()
	local f = io.open(transparency_path, "r")
	if not f then
		return false
	end
	local value = f:read("*l") == "1"
	f:close()
	return value
end

function set_transparency(state)
	local f = io.open(transparency_path, "w")
	if f then
		f:write(state and "1" or "0")
		f:close()
	end
end

function apply_cursorline(win)
	if not vim.api.nvim_win_is_valid(win) then
		return
	end

	local buf = vim.api.nvim_win_get_buf(win)
	local ft = vim.bo[buf].filetype or ""

	-- skip snacks + non-file buffers
	if vim.bo[buf].buftype ~= "" then
		return
	end
	if ft:lower():find("snacks", 1, true) then
		return
	end

	vim.api.nvim_win_set_option(win, "cursorline", vim.g.show_cursorline)
end

local function get_normal_bg()
	return vim.api.nvim_get_hl_by_name("Normal", true)["background"]
end

function toggle_breakpoint_in_sign_col()
	local mouse = vim.fn.getmousepos()
	local col = mouse.column
	local line = mouse.line

	-- Only trigger breakpoint logic if click is in the sign column
	if col == 1 then
		-- Move cursor to clicked line
		vim.api.nvim_win_set_cursor(0, { line, 0 })

		if vim.g.termdebug_running then
			vim.cmd("silent Break")
		else
			require("dap")
			vim.cmd.DapToggleBreakpoint()
		end

		-- Ensure we are in normal mode
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
	else
		-- For regular clicks, execute the normal left mouse behavior
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<LeftMouse>", true, false, true), "n", false)
	end
end

function toggle_todo()
	local line = vim.api.nvim_get_current_line()
	local new_line = line
	-- Pattern for unordered list (`- [ ]` or `- [x]`)
	if string.match(line, "%- %[ %]") then
		new_line = string.gsub(line, "%- %[ %]", "- [x]")
	elseif string.match(line, "%- %[x%]") then
		new_line = string.gsub(line, "%- %[x%]", "- [ ]")
	-- Pattern for ordered list (`1. [ ]` or `1. [x]`)
	elseif string.match(line, "^%s*%d+%. %[ %]") then
		new_line = string.gsub(line, "(%d+%. )%[ %]", "%1[x]")
	elseif string.match(line, "^%s*%d+%. %[x%]") then
		new_line = string.gsub(line, "(%d+%. )%[x%]", "%1[ ]")
	end
	vim.api.nvim_set_current_line(new_line)
end

function term_debug()
	if vim.g.zen_mode then
		vim.cmd("lua Snacks.zen()")
	end
	-- local filepath = vim.fn.expand("%:p:h") -- the directory
	local filepath = vim.fn["FindRootDirectory"]() -- NOTE: depends on vim-rooter
	-- specific to my system
	-- local gdbfake_file = os.getenv("HOME") .. "/.gdbfake"
	-- local gdbinit_file = os.getenv("HOME") .. "/.gdbinit"
	-- local has_gdbfake = vim.fn.filereadable(gdbfake_file) == 1
	-- if has_gdbfake then
	-- 	os.rename(gdbfake_file, gdbinit_file)
	-- end
	-- until here
	vim.g.termdebug_wide = vim.fn.winwidth(0) > vim.g.big_screen_size
	-- local current_dir = vim.fn.expand("%:p:h")
	vim.cmd("packadd termdebug | startinsert | Termdebug")
	if vim.g.termdebug_wide then
		-- vim.cmd("Asm")
		vim.cmd("Var")
		vim.cmd("Gdb")
		vim.cmd("wincmd x")
		vim.cmd("Gdb")
		vim.cmd("resize 35")
		vim.cmd("Source")
		vim.cmd("resize 35")
		vim.cmd("Gdb")
		vim.api.nvim_feedkeys("dashboard -enabled off\n", "n", true)
		-- vim.api.nvim_feedkeys("dashboard -layout registers\n", "n", true)
	else
		vim.api.nvim_feedkeys("dashboard -enabled off\n", "n", true)
	end
	vim.g.termdebug_running = true
	-- vim.api.nvim_feedkeys("layout asm\nlayout regs\n", "n", true)
	-- vim.api.nvim_feedkeys("cd " .. current_dir .. "\n", "n", true)
	-- vim.api.nvim_feedkeys("file " .. current_dir .. "/", "n", true)
	vim.api.nvim_feedkeys("file " .. filepath .. "/", "n", true)
end

-- get a character from user and return it. returns "" if there's an error or
-- <C-c>  or <ESC> is pressed.
function get_char(prompt)
	print(prompt)
	local ok, char = pcall(vim.fn.getchar)
	if not ok then
		return ""
	end
	if char == 3 or char == 27 then
		return ""
	end
	return vim.fn.nr2char(char)
end

function get_highlight(group)
	local src = "redir @a | silent! hi " .. group .. " | redir END | let output = @a"
	vim.api.nvim_exec2(src, { output = true })
	local output = vim.fn.getreg("a")
	local list = vim.split(output, "%s+")
	local dict = {}
	for _, item in ipairs(list) do
		if string.find(item, "=") then
			local splited = vim.split(item, "=")
			dict[splited[1]] = splited[2]
		end
	end
	return dict
end

function get_git_hash()
	local handle = io.popen("git describe --always")
	if handle then
		local result = handle:read("*a")
		handle:close()
		if result then
			vim.api.nvim_command("let @g = '" .. result .. "'")
		else
			print("Error: Command did not return a result")
		end
	else
		print("Error: Failed to run command")
	end
end

function git_next()
	local handle = io.popen(
		[[
      # Check if we're in a git repository
      if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
          echo "Not in a git repository"
          return 1
      fi

      # Check if there are any commits in the current branch
      if ! git rev-parse HEAD > /dev/null 2>&1; then
          echo "No commits in the current branch"
          return 1
      fi

      # Try to get the name of the remote branch that the HEAD points to
      branch=""
      if git rev-parse refs/remotes/origin/HEAD > /dev/null 2>&1; then
          branch=$(git branch -r --points-at refs/remotes/origin/HEAD | grep '\->' | cut -d' ' -f5 | cut -d/ -f2)
      fi

      if [ -z "$branch" ]; then
          # Fallback: Extract branch name in another way
          branch=$(basename $(git rev-parse --show-toplevel)/.git/refs/heads/*)
      fi

      # If there's still no branch or an error, perform another fallback action
      if [ -z "$branch" ]; then
          fallback_branch=$(git remote show origin | sed -n '/HEAD branch/s/.*: //p')
          next_commit=$(git rev-list --topo-order HEAD..$fallback_branch | tail -1)
          git checkout $next_commit 2>&1
          return
      fi

      # Get the hash of the next commit
      next_commit=""
      next_commit=$(git log --reverse --pretty=%H $branch | grep -A 1 $(git rev-parse HEAD) | tail -n1)

      # If there's no next commit, we're already at the last commit
      if [ -z "$next_commit" ]; then
          echo "Already at the last commit"
          return 1
      fi

      # Try to checkout the next commit, and use the fallback command in case of an error
      git checkout $next_commit 2>&1
    ]],
		"r"
	)
	if handle ~= nil then
		local result = handle:read("*a")
		print(result)
		handle:close()
	else
		print("Failed to execute command")
	end
end

function git_previous()
	local handle = io.popen([[
    if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        echo "Not in a git repository"
        return 1
    fi

    # Check if there are any commits in the current branch
    if ! git rev-parse HEAD > /dev/null 2>&1; then
        echo "No commits in the current branch"
        return 1
    fi
    git checkout HEAD^ 2>&1
  ]])
	if handle ~= nil then
		local result = handle:read("*a")
		print(result)
		handle:close()
	else
		print("Failed to execute command")
	end
end

function ToggleDiagnostics()
	if not diagnostics_enabled then
		vim.diagnostic.config(diagnostics_config)
		diagnostics_enabled = true
	else
		diagnostics_config = vim.diagnostic.config()
		vim.diagnostic.config({
			virtual_text = false,
			virtual_lines = false,
			sign = true,
			float = false,
			update_in_insert = false,
			severity_sort = true,
			underline = diagnostics_config.underline,
		})
		diagnostics_enabled = false
	end
end

-- ╭─────────────────────────────────────────────────────────╮
-- │                        Autocmds                         │
-- ╰─────────────────────────────────────────────────────────╯

vim.api.nvim_create_autocmd("TabLeave", {
	callback = function()
		if vim.g.zen_mode then
			vim.g.switching_tab = true
			Snacks.zen()
		end
	end,
})

vim.api.nvim_create_autocmd("TabEnter", {
	callback = function()
		if vim.g.switching_tab then
			Snacks.zen()
			vim.g.switching_tab = false
		end
	end,
})

local yank_group = vim.api.nvim_create_augroup("HighlightYank", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
	group = yank_group,
	desc = "Highlight yanked text",
	callback = function()
		vim.hl.on_yank({ higroup = "IncSearch", timeout = 100 })
	end,
})

vim.api.nvim_create_autocmd("TermOpen", {
	callback = function()
		vim.cmd("startinsert")
		-- vim.cmd("set ft=terminal")
	end,
})

vim.api.nvim_create_augroup("auto_open_quickfix", { clear = true })

vim.api.nvim_create_autocmd("QuickFixCmdPost", {
	group = "auto_open_quickfix",
	pattern = "[^l]*",
	callback = function()
		vim.cmd("cwindow")
	end,
})

vim.api.nvim_create_augroup("termdebug_state", { clear = true })

vim.api.nvim_create_autocmd("User", {
	group = "termdebug_state",
	pattern = "TermdebugStartPost",
	callback = function()
		vim.g.termdebug_running = true
	end,
})

vim.api.nvim_create_autocmd("User", {
	group = "termdebug_state",
	pattern = "TermdebugStopPost",
	callback = function()
		vim.g.termdebug_running = false
	end,
})

vim.api.nvim_create_autocmd("TermClose", {
	group = "termdebug_state",
	pattern = "*",
	callback = function()
		vim.g.termdebug_running = false
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	-- NOTE: fo for formatoptions, c for auto-wrap comments while typing, r
	-- for continue comments when pressing enter, o for continue comments
	-- using o or O.
	-- command = "setlocal fo-=c fo-=r fo-=o",
	callback = function()
		vim.opt_local.formatoptions:remove({ "c", "r", "o" })
	end,
})

-- vim.api.nvim_create_autocmd("FileType", {
-- 	pattern = "template",
-- 	command = "setlocal filetype=html",
-- })

vim.api.nvim_create_autocmd("FileType", {
	pattern = "template",
	callback = function()
		vim.bo.commentstring = "<!-- %s -->"
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "mysql",
	callback = function()
		vim.bo.commentstring = "-- %s"
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "python", "gdscript" },
	callback = function()
		vim.bo.commentstring = "# %s"
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "rust", "go", "cpp" },
	callback = function()
		vim.bo.commentstring = "// %s"
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "lua",
	callback = function()
		vim.bo.commentstring = "-- %s"
	end,
})

vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter" }, {
	callback = function()
		apply_cursorline(vim.api.nvim_get_current_win())
	end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		vim.g.show_cursorline = not vim.g.is_transparent
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			apply_cursorline(win)
		end
	end,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
	callback = function()
		if vim.g.last_session_owner ~= nil and vim.bo.filetype ~= "snacks_dashboard" then
			save_session()
		end
	end,
})

-- ╭─────────────────────────────────────────────────────────╮
-- │                 Plugin-specific configs                 │
-- ╰─────────────────────────────────────────────────────────╯

-- Vim Visual Multi{{{
vim.g.VM_set_statusline = false
-- }}}

-- Netrw {{{
vim.g.netrw_banner = false
vim.g.netrw_bufsettings = "noma nomod nu rnu nobl nowrap ro"
vim.g.netrw_winsize = -40
vim.g.netrw_browse_split = 4
vim.g.netrw_fastbrowse = false
vim.g.netrw_liststyle = 3
-- vim.g.netrw_hide = true
-- }}}

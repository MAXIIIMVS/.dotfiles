local signs = {
	Error = " ",
	Warn = " ",
	Hint = "󰌶 ",
	Info = " ",
}

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
	local bg = vim.api.nvim_get_hl_by_name("Normal", true)["background"]
	return bg
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

function toggle_todo_window(todo_file)
	if vim.g.is_todo_open then
		vim.cmd("q")
		return
	end

	if vim.fn.filereadable(todo_file) == 0 then
		local default_content = {
			"# To-do",
			"",
			"## 🔴 Critical (Do Today)",
			"",
			"## 🟡 High Priority (This Week)",
			"",
			"## 🔵 Medium Priority (When Possible)",
			"",
			"## ⚪ Low Priority/Backlog",
			"",
			"## ✅ Done",
			"",
		}
		vim.fn.writefile(default_content, todo_file)
	end
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_option(buf, "filetype", "vimwiki")
	local content = vim.fn.readfile(todo_file)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)
	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.8)
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded",
	})
	vim.g.is_todo_open = true
	-- vim.api.nvim_win_set_option(win, "number", true)
	-- vim.api.nvim_win_set_option(win, "relativenumber", true)
	vim.api.nvim_win_set_option(win, "spell", true)
	vim.api.nvim_buf_set_keymap(buf, "n", "q", "<cmd>q<CR>", { noremap = true, silent = true })
	vim.api.nvim_buf_set_keymap(buf, "n", "<C-c>", "<cmd>q<CR>", { noremap = true, silent = true })
	vim.api.nvim_create_autocmd("BufLeave", {
		buffer = buf,
		callback = function()
			vim.g.is_todo_open = false
			local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
			local is_empty = true
			for _, line in ipairs(lines) do
				if line:match("%S") then
					is_empty = false
					break
				end
			end
			if is_empty then
				vim.ui.input({ prompt = "File is empty. Save anyway? (y/n): " }, function(input)
					if input and input:lower() == "y" then
						vim.fn.writefile(lines, todo_file)
					end
					vim.api.nvim_buf_delete(buf, { force = true })
				end)
			else
				vim.fn.writefile(lines, todo_file)
				vim.api.nvim_buf_delete(buf, { force = true })
			end
		end,
	})
end

function toggle_local_todo_window()
	local root = vim.fn["FindRootDirectory"]() -- NOTE: depends on vim-rooter
	if not root or root == "" then
		vim.notify("Could not determine project root", vim.log.levels.WARN)
		return
	end

	local todo_file = root .. "/.todo.md"
	toggle_todo_window(todo_file)
end

function toggle_global_todo_window()
	local todo_file = vim.fn.expand("~/.todo.md")
	toggle_todo_window(todo_file)
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
		vim.cmd("resize 25")
		vim.cmd("Source")
		vim.cmd("resize 25")
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

function is_tmux_running()
	local tmux_env = vim.env.TMUX
	return tmux_env ~= nil and tmux_env ~= ""
end

function set_tmux_status_color(color)
	if is_tmux_running() then
		local command = string.format(
			"tmux show-option -gq status-style | grep -q 'bg=%s' && tmux set-option -gq status-style bg=%s || tmux set-option -gq status-style bg=%s; tmux refresh-client -S",
			color,
			color,
			color
		)
		local handle = io.popen(command)
		if handle then
			handle:close()
		else
			print("Failed to execute the command.")
		end
		-- else
		-- 	print("Tmux is not running. Skipping statusline color change.")
	end
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

function sync_statusline_with_tmux()
	local current_background = get_highlight("Normal")["guibg"]
	vim.api.nvim_set_hl(0, "StatusLine", { bg = current_background == nil and "NONE" or "bg" })
	set_tmux_status_color(current_background == nil and "default" or current_background)
	-- vim.o.fillchars = "eob: "
	-- vim.wo.colorcolumn = current_background ~= nil and "80" or ""
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

local diagnostics_config = vim.diagnostic.config()
local diagnostics_enabled = true

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
			severity_sort = false,
			underline = true,
		})
		diagnostics_enabled = false
	end
end

vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = signs.Error,
			[vim.diagnostic.severity.WARN] = signs.Warn,
			[vim.diagnostic.severity.HINT] = signs.Hint,
			[vim.diagnostic.severity.INFO] = signs.Info,
		},
	},
})

-- enable diagnostics: nvim v.0.0.11
-- vim.diagnostic.config({ virtual_text = true })
-- vim.diagnostic.config({ virtual_text = { current_line = true } })
-- vim.diagnostic.config({ virtual_lines = true })
vim.diagnostic.config({ virtual_lines = { current_line = true } })

vim.api.nvim_create_autocmd("VimEnter", {
	group = vim.api.nvim_create_augroup("sync_tmux", { clear = true }),
	callback = function()
		sync_statusline_with_tmux()
	end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
	group = vim.api.nvim_create_augroup("sync_tmux", { clear = true }),
	callback = function()
		vim.schedule(function()
			sync_statusline_with_tmux()
		end)
	end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = function()
		-- NOTE: requires https://github.com/catppuccin/lazygit
		local base = vim.fn.expand("$HOME/.config/lazygit/")
		local theme = vim.o.background == "dark" and "themes/catppuccin/themes-mergable/mocha/peach.yml"
			or "themes/catppuccin/themes-mergable/latte/red.yml"
		vim.env.LG_CONFIG_FILE = base .. "config.yml," .. base .. theme
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

vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "retrobox",
	callback = function()
		local bg = vim.o.background
		local transparent = vim.g.is_transparent

		-- #1A1A2F #1D182E #171421, terminal background: #171421
		-- mocha = { base = "#191724" },
		-- mocha = { base = "#1A1527" },

		local common = {
			Visual = { bg = "#45475b", fg = "NONE" },
			VisualNOS = { bg = "#45475b", fg = "NONE" },
			NonText = { fg = "#9ca0b1" },
			Whitespace = { fg = "#504945" },
			DiagnosticError = { fg = "#ff5f5f" },
			DiagnosticWarn = { fg = "#ffaf00" },
			DiagnosticInfo = { fg = "#5fafff" },
			DiagnosticHint = { fg = "#5fffaf" },
		}

		for group, opts in pairs(common) do
			vim.api.nvim_set_hl(0, group, opts)
		end

		if transparent then
			local t = {
				CmpItemAbbr = { fg = "#a0a0b0" },
				CmpItemAbbrMatch = { fg = "#ffaf00", bold = true },
				CmpItemAbbrMatchFuzzy = { fg = "#ffaf00" },
				CmpItemKind = { fg = "#7fafff", bg = "#181826" },
				CmpItemMenu = { fg = "#8f8f99", bg = "#181826", italic = true },
				CursorLineNr = { bg = "NONE", fg = "NONE" },
				DiffAdd = { bg = "#2a332d", fg = "NONE" },
				DiffChange = { bg = "#3a2e36", fg = "NONE" },
				DiffDelete = { bg = "#3e2d2e", fg = "NONE" },
				DiffText = { bg = "#575268", fg = "NONE" },
				FloatBorder = { fg = "#5f5f5f", bg = "NONE" },
				Normal = { bg = "NONE" },
				NormalFloat = { bg = "NONE" },
				Pmenu = { bg = "NONE", fg = "#d0d0d0" },
				PmenuSel = { bg = "#444444", fg = "#ffffff" },
				QuickFixLine = { bg = "#38384C", bold = true },
				SignColumn = { bg = "NONE" },
				SnacksInputBorder = { bg = "NONE", fg = "#5f5f5f" },
				SnacksInputNormal = { bg = "NONE", fg = "#d0d0d0" },
				SnacksListBorder = { bg = "NONE", fg = "#5f5f5f" },
				SnacksListNormal = { bg = "NONE", fg = "#d0d0d0" },
				SnacksListSelection = { bg = "#444444", fg = "#ffffff" },
				StatusLine = { bg = "NONE", fg = "NONE" },
				StatusLineNC = { bg = "NONE", fg = "NONE" },
				StatusLineTerm = { bg = "NONE", fg = "NONE" },
				StatusLineTermNC = { bg = "NONE", fg = "NONE" },
				TabLineFill = { bg = "NONE", fg = "NONE" },
				TabLineSel = { fg = "#ffffff", bg = "NONE" },
				VertSplit = { bg = "NONE", fg = "#5f5f5f" },
				debugPC = { bg = "#45475b" },
			}
			for group, opts in pairs(t) do
				vim.api.nvim_set_hl(0, group, opts)
			end

			local transparent_theme = {}
			for _, mode in ipairs({ "normal", "insert", "visual", "replace", "command", "inactive" }) do
				transparent_theme[mode] = {}
				for _, section in ipairs({ "a", "b", "c" }) do
					transparent_theme[mode][section] = { bg = "NONE", gui = "bold" }
				end
			end
			require("lualine").setup({ options = { theme = transparent_theme } })
		else
			local dark = {
				CmpItemAbbr = { fg = "#a0a0b0" },
				CmpItemAbbrMatch = { fg = "#ffaf00", bold = true },
				CmpItemAbbrMatchFuzzy = { fg = "#ffaf00" },
				CmpItemKind = { fg = "#7fafff", bg = "#181826" },
				CmpItemMenu = { fg = "#8f8f99", bg = "#181826", italic = true },
				ColorColumn = { bg = "#313245" },
				CursorLine = { bg = "#29283B" },
				DiffAdd = { bg = "#2a332d", fg = "NONE" },
				DiffChange = { bg = "#3a2e36", fg = "NONE" },
				DiffDelete = { bg = "#3e2d2e", fg = "NONE" },
				DiffText = { bg = "#575268", fg = "NONE" },
				ErrorMsg = { bg = "NONE" },
				Normal = { bg = "#1A1528", fg = "#CDD6F5" },
				NormalFloat = { bg = "#181826", fg = "#CDD6F5" },
				Pmenu = { bg = "#181826", fg = "#CDD6F5" },
				PmenuSel = { bg = "#444444", fg = "#ffffff" },
				QuickFixLine = { bg = "#38384C", bold = true },
				SignColumn = { bg = "#1A1528", fg = "#CDD6F5" },
				SnacksInputBorder = { bg = "#1c1c1c", fg = "#5f5f5f" },
				SnacksInputNormal = { bg = "#1c1c1c", fg = "#d0d0d0" },
				SnacksListBorder = { bg = "#1c1c1c", fg = "#5f5f5f" },
				SnacksListNormal = { bg = "#1c1c1c", fg = "#d0d0d0" },
				SnacksListSelection = { bg = "#444444", fg = "#ffffff" },
				TabLineFill = { bg = "#130F1E" },
				TabLineSel = { fg = "#ffffff", bg = "#1A1528" },
				WinSeparator = { fg = "#554D80" },
				debugPC = { bg = "#45475b" },
			}

			local light = {
				CmpItemAbbr = { fg = "#3c3836" },
				CmpItemAbbrMatch = { fg = "#af8700", bold = true },
				CmpItemAbbrMatchFuzzy = { fg = "#af8700" },
				CmpItemKind = { fg = "#5f5fff", bg = "#f2e5bc" },
				CmpItemMenu = { fg = "#928374", bg = "#f2e5bc", italic = true },
				DiffAdd = { bg = "#d4f5dc", fg = "NONE" },
				DiffChange = { bg = "#fff5c2", fg = "NONE" },
				DiffDelete = { bg = "#f5d0d0", fg = "NONE" },
				DiffText = { bg = "#e3d8f0", fg = "NONE" },
				FloatBorder = { fg = "#928374", bg = "#f2e5bc" },
				NonText = { fg = "#a89984" },
				Normal = { fg = "#3c3836", bg = "#fbf1c7" },
				NormalFloat = { fg = "#3c3836", bg = "#f2e5bc" },
				Pmenu = { bg = "#f2e5bc", fg = "#3c3836" },
				PmenuSel = { bg = "#e6d6a8", fg = "#282828" },
				QuickFixLine = { bg = "#CBCFD9", bold = true },
				SignColumn = { fg = "#3c3836", bg = "#fbf1c7" },
				SnacksInputBorder = { fg = "#928374", bg = "#f2e5bc" },
				SnacksInputNormal = { fg = "#3c3836", bg = "#f2e5bc" },
				SnacksListBorder = { fg = "#928374", bg = "#f2e5bc" },
				SnacksListNormal = { fg = "#3c3836", bg = "#f2e5bc" },
				SnacksListSelection = { fg = "#282828", bg = "#e6d6a8" },
				Visual = { bg = "#d5c4a1", fg = "NONE" },
				VisualNOS = { bg = "#d5c4a1", fg = "NONE" },
				Whitespace = { fg = "#bdae93" },
			}

			local hl_set = bg == "dark" and dark or light
			for group, opts in pairs(hl_set) do
				vim.api.nvim_set_hl(0, group, opts)
			end

			local dark_theme = {}
			for _, mode in ipairs({ "normal", "insert", "visual", "replace", "command", "inactive" }) do
				dark_theme[mode] = {}
				for _, section in ipairs({ "a", "b", "c" }) do
					dark_theme[mode][section] = { bg = "#1A1528", fg = "#CDD6F5" }
				end
			end

			local light_theme = {}
			for _, mode in ipairs({ "normal", "insert", "visual", "replace", "command", "inactive" }) do
				light_theme[mode] = {}
				for _, section in ipairs({ "a", "b", "c" }) do
					light_theme[mode][section] = { bg = "#fbf1c7", fg = "#3c3836" }
				end
			end

			require("lualine").setup({
				options = { theme = bg == "dark" and dark_theme or light_theme },
			})
		end
	end,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
	callback = function()
		if vim.bo.filetype ~= "snacks_dashboard" then
			vim.cmd("ScopeSaveState")
			require("resession").save(vim.fn.getcwd(), { dir = "dirsession", notify = false })
		end
	end,
})

-- Auto commands and functions {{{
vim.cmd([[
" filetype plugin on
" set omnifunc=syntaxcomplete#Complete

" Prefer rg > ag > ack
if executable('rg')
    let g:ackprg = 'rg -S --no-heading --vimgrep'
    set grepprg=rg\ --vimgrep\ $*
elseif executable('ag')
    let g:ackprg = 'ag --vimgrep'
    set grepprg=ag\ --vimgrep\ $*
endif
set grepformat=%f:%l:%c:%m

nmap <C-_> gcc
xmap <C-_> gc
smap <C-_> <ESC><ESC>gcc
imap <C-_> <ESC>gcc

nmap <C-/> gcc
xmap <C-/> gc
smap <C-/> <ESC><ESC>gcc
imap <C-/> <ESC>gcc

autocmd FileType vimwiki nnoremap <silent> <buffer> <CR> :silent! VimwikiFollowLink<CR>

autocmd FileType template set filetype=html

" dadbod completion with cmp
" autocmd FileType sql,mysql,plsql lua require('cmp').setup.buffer({ sources = {{ name = 'vim-dadbod-completion' }} })
au FileType * set fo-=c fo-=r fo-=o

" Automatically open Quickfix window if there are errors after :make
augroup auto_open_quickfix
  autocmd!
  autocmd QuickFixCmdPost [^l]* cwindow
augroup END

autocmd User TermdebugStartPost lua vim.g.termdebug_running = true
autocmd User TermdebugStopPost lua vim.g.termdebug_running = false
autocmd TermClose * lua vim.g.termdebug_running = false

let g:termdebug_wide=1
let g:termdebug_map_K = 0
" let g:termdebug_disasm_window = 15

autocmd BufEnter * if &buftype == 'terminal' | startinsert | endif

if has('nvim')
  augroup hide_terminal_numbers
    autocmd!
    autocmd TermOpen * setlocal nonumber norelativenumber nospell
  augroup END
else
  augroup hide_terminal_numbers
    autocmd!
    autocmd BufEnter term://* setlocal nonumber norelativenumber nospell
  augroup END
endif

" Disable while using noice.nvim
" augroup CmdHeight
"     autocmd!
"     autocmd CmdlineEnter * if &cmdheight == 0 | let g:cmdheight_prev = 0 | set cmdheight=1 | endif
"     autocmd CmdlineLeave * if exists('g:cmdheight_prev') && g:cmdheight_prev == 0 | set cmdheight=0 | unlet! g:cmdheight_prev | endif
" augroup END

" hide tmux
" autocmd VimEnter,VimLeave * silent !tmux set status
" autocmd VimLeave * silent !tmux set -g status-style bg=default


autocmd BufWinLeave * if &laststatus != 3 | set laststatus=3 | endif

function! OpenLazyGit()
  " Save the buffer we came from
  let g:lazygit_source_buf = bufnr('%')

  " set notermguicolors " uncomment this if you're not using a theme for lazygit
	terminal lazygit
	" terminal lazygit --use-config-file="$HOME/.config/lazygit/config.yml,$HOME/.config/lazygit/themes/catppuccin/themes-mergable/mocha/peach.yml"
  tnoremap <buffer> <ESC> <ESC>
  startinsert
  redraw!

  augroup LazyGit
    autocmd! * <buffer>
    autocmd WinResized <buffer> redraw
    autocmd TermClose <buffer> call s:OnLazyGitClose()
    " autocmd TermClose * set termguicolors " uncomment this if you're not using a theme for lazygit
  augroup END
endfunction

function! s:OnLazyGitClose()
  lua Snacks.bufdelete()

  if exists('g:lazygit_source_buf') && bufexists(g:lazygit_source_buf)
    execute 'buffer' g:lazygit_source_buf
    silent! Gitsigns refresh
  endif
endfunction

function! OpenHtop()
  set notermguicolors
  terminal htop
  redraw!
  startinsert
  augroup HTOP
	  autocmd! * <buffer>
	  autocmd WinResized <buffer> redraw
	  autocmd TermClose <buffer> :lua Snacks.bufdelete()
	  autocmd TermClose * set termguicolors | execute "tnoremap <ESC> \<C-\\>\<C-n>"
  augroup END
endfunction


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

" netrw settings and functions
" let g:netrw_list_hide= netrw_gitignore#Hide()
" let s:treedepthstring     = "│ "
" let g:netrw_hide = 1
" let g:netrw_altv=1

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

" emojis
ab :pi: 𝞹
ab :micro: μ
ab :dh: ⏃
ab :bullseye: 🎯
ab :note: 📝
ab :separator_ltt: ❮
ab :separator_rtt: ❯
ab :degrees: °
ab :wp: ♟
ab :bp: ♙
ab :wk: ♚
ab :bk: ♔
ab :wq: ♛
ab :bq: ♕
ab :wb: ♝
ab :bb: ♗
ab :wk: ♞
ab :bk: ♘
ab :wr: ♜
ab :br: ♖
]])
-- }}}

-- Fundamental {{{
vim.o.winborder = "rounded"
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
-- vim.o.showtabline = 2 -- show tabline even if only one tab is open
vim.o.cmdheight = 0
vim.o.laststatus = 3
vim.g.laststatus = 3
vim.go.laststatus = 3
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

-- Syntax theme "{{{
-----------------------------------------------------------------------
if vim.fn.exists("&termguicolors") == 1 and vim.fn.exists("&winblend") then
	-- vim.cmd("syntax enable")
	vim.o.termguicolors = true
	vim.o.wildoptions = "pum"
	vim.wo.winblend = 0
	vim.o.pumblend = 0
	vim.o.background = "dark"
end
-- }}}

-- Settings {{{
-- ---------------------------------------------------------------------
-- vim.o.omnifunc = 'syntaxcomplete#Complete'
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
vim.bo.swapfile = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.config/undodir"
vim.opt.undofile = true
vim.o.showmode = false
vim.bo.textwidth = 80
-- vim.wo.colorcolumn = "80"
vim.wo.linebreak = true
vim.o.autochdir = true
vim.o.hidden = true
vim.o.wildmenu = true
vim.o.wildmode = "longest:full,full"
-- vim.g.wildoptions = "pum"
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.updatetime = 200
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

-- Vim Visual Multi{{{
vim.g.VM_set_statusline = false
-- }}}

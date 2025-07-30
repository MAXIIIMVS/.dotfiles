require("which-key").add({
	-- { "<MouseMove>", "<cmd>Lspsaga hover_doc<CR>", desc = "Hover info" }, -- vim.o.mousemoveevent = true
	{ "<RightMouse>", "<LeftMouse><cmd>Lspsaga hover_doc<CR>", desc = "Hover info" },
	{ "<Nop>", "<Plug>VimwikiRemoveHeaderLevel", desc = "disabled", nowait = true, remap = false },
	{ ",", group = "Miscellaneous", nowait = true, remap = false },
	{
		",,",
		function()
			vim.cmd("ToggleTerm size=160 direction=float dir=%:p:h")
		end,
		desc = "Floating Terminal",
		nowait = true,
		remap = false,
	},
	{ ",1", "1<C-w>w", desc = "Go to 1st window", nowait = true, remap = false },
	{ ",2", "2<C-w>w", desc = "Go to 2nd window", nowait = true, remap = false },
	{ ",3", "3<C-w>w", desc = "Go to 3rd window", nowait = true, remap = false },
	{ ",4", "4<C-w>w", desc = "Go to 4th window", nowait = true, remap = false },
	{ ",5", "5<C-w>w", desc = "Go to 5th window", nowait = true, remap = false },
	{ ",6", "6<C-w>w", desc = "Go to 6th window", nowait = true, remap = false },
	{ ",7", "7<C-w>w", desc = "Go to 7th window", nowait = true, remap = false },
	{ ",8", "8<C-w>w", desc = "Go to 8th window", nowait = true, remap = false },
	{ ",9", "9<C-w>w", desc = "Go to 9th window", nowait = true, remap = false },
	{
		",D",
		function()
			local word = vim.fn.expand("<cword>")
			-- vim.cmd("terminal dict " .. word)
			vim.cmd("!dict " .. word)
		end,
		desc = "Dictionary",
		nowait = true,
		remap = false,
	},
	{ ",d", "<cmd>silent lua Snacks.dashboard()<CR>", desc = "dashboard", nowait = true, remap = false },
	{ ",f", ":find ", desc = "find a file", nowait = true, remap = false, silent = false },
	{
		",g",
		"<cmd>call OpenLazyGit()<CR>",
		desc = "LazyGit",
		remap = false,
		silent = true,
		nowait = true,
	},
	{ ",h", "<cmd>silent lua Snacks.picker.keymaps()<CR>", desc = "Keymaps", nowait = true, remap = false },
	{ ",m", "<cmd>messages<CR>", desc = "Messages", nowait = true, remap = false },
	{ ",q", "<cmd>tabclose<CR>", desc = "Close tab", nowait = true, remap = false },
	{
		",r",
		"<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>",
		desc = "Remove a folder from workspace",
		nowait = true,
		remap = false,
	},
	{
		",S",
		":%s/<c-r><C-w>//gi<left><left><left>",
		desc = "Substitute the word in the whole file (ignore case)",
		nowait = true,
		remap = false,
		silent = false,
	},
	{
		",s",
		":s/<C-r><C-w>//gi<left><left><left>",
		desc = "Substitute the word in this line (ignore case)",
		nowait = true,
		remap = false,
		silent = false,
	},
	{
		",T",
		"<cmd>call OpenHtop()<CR>",
		desc = "HTOP",
		remap = false,
		silent = true,
		nowait = true,
	},
	-- { ",t", ":tabfind ", desc = "tab find", remap = false, silent = false, nowait = true },
	{
		",t",
		open_todo_window,
		desc = "Todos",
		nowait = true,
		remap = false,
		silent = false,
	},
	{ ",x", "<cmd>BufferLinePickClose<CR>", desc = "Pick a buffer to close", nowait = true, remap = false },
	{
		",z",
		function()
			-- NOTE: requires pandoc and zathura
			if vim.bo.filetype ~= "markdown" then
				print("Not a Markdown file.")
				return
			end
			local file_path = vim.fn.expand("%:p")
			local pdf_path = vim.fn.tempname() .. ".pdf"
			local ok = vim.fn.system({
				"pandoc",
				"-V",
				"geometry:margin=1in",
				"-i",
				file_path,
				"-o",
				pdf_path,
			})
			if vim.v.shell_error ~= 0 then
				print("Error generating PDF with pandoc.")
				return
			end
			vim.fn.jobstart({ "zathura", pdf_path }, { detach = true })
		end,
		desc = "Open with zathura",
		nowait = true,
		remap = false,
	},
	{ "-", "<cmd>silent Oil<CR>", desc = "Current directory", nowait = true, remap = false },
	{ ";", group = "Quick", nowait = true, remap = false },
	{ ";1", "<cmd>BufferLineGoToBuffer 1<CR>", desc = "Go to 1st buffer", nowait = true, remap = false },
	{ ";2", "<cmd>BufferLineGoToBuffer 2<CR>", desc = "Go to 2nd buffer", nowait = true, remap = false },
	{ ";3", "<cmd>BufferLineGoToBuffer 3<CR>", desc = "Go to 3rd buffer", nowait = true, remap = false },
	{ ";4", "<cmd>BufferLineGoToBuffer 4<CR>", desc = "Go to 4th buffer", nowait = true, remap = false },
	{ ";5", "<cmd>BufferLineGoToBuffer 5<CR>", desc = "Go to 5th buffer", nowait = true, remap = false },
	{ ";6", "<cmd>BufferLineGoToBuffer 6<CR>", desc = "Go to 6th buffer", nowait = true, remap = false },
	{ ";7", "<cmd>BufferLineGoToBuffer 7<CR>", desc = "Go to 7th buffer", nowait = true, remap = false },
	{ ";8", "<cmd>BufferLineGoToBuffer 8<CR>", desc = "Go to 8th buffer", nowait = true, remap = false },
	{ ";9", "<cmd>BufferLineGoToBuffer 9<CR>", desc = "Go to 9th buffer", nowait = true, remap = false },
	{
		";;",
		"<cmd>lua Snacks.bufdelete()<CR>",
		desc = "Delete current buffer",
		nowait = true,
		remap = false,
	},
	{ ";<space>", "<cmd>lua Snacks.picker()<CR>", desc = "Picker", nowait = true, remap = false },
	{
		";A",
		function()
			local url = "https://www.chatgpt.com/"
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
		end,
		desc = "Ask ChatGPT",
		nowait = true,
		remap = false,
	},
	{
		";a",
		function()
			local status, query = pcall(vim.fn.input, "Enter search query: ")
			if not status then
				print("Search canceled.")
				return
			end
			if query == "" then
				print("Search canceled.")
				return
			end
			local encoded_query = query
				:gsub("([^%w _%-%.~])", function(c)
					return string.format("%%%02X", string.byte(c))
				end)
				:gsub(" ", "+") -- Replace spaces with '+'

			local url = "https://www.google.com/search?q=" .. encoded_query
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
		end,
		desc = "Ask Google",
		nowait = true,
		remap = false,
	},
	{
		";b",
		"<cmd>lua Snacks.picker.buffers()<CR>",
		desc = "List open buffers",
		nowait = true,
		remap = false,
	},
	{
		";c",
		"<cmd>lua Snacks.picker.colorschemes()<CR>",
		desc = "List available color schemes",
		nowait = true,
		remap = false,
	},
	{ ";D", "<cmd>Lspsaga show_line_diagnostics<CR>", desc = "Show line diagnostics", nowait = true, remap = false },
	{
		";d",
		"<cmd>silent lua Snacks.picker.diagnostics()<CR>",
		desc = "List diagnostics",
		nowait = true,
		remap = false,
	},
	{ ";e", ":e ", desc = "Edit file", nowait = true, remap = false, silent = false },
	{
		";F",
		"<cmd>lua Snacks.picker.git_files()<CR>",
		desc = "Fuzzy search for files tracked by Git",
		nowait = true,
		remap = false,
	},
	{ ";f", "<cmd>lua Snacks.picker.files()<CR>", desc = "Find files", nowait = true, remap = false },
	{
		";G",
		"<cmd>lua Snacks.picker.grep_word()<CR>",
		desc = "Grep string under the cursor",
		nowait = true,
		remap = false,
	},
	{ ";g", "<cmd>lua Snacks.picker.grep()<CR>", desc = "Live grep", nowait = true, remap = false },
	{ ";H", ":Man ", desc = "Show man pages", nowait = true, remap = false, silent = false },
	{
		";h",
		":h ",
		desc = "Help",
		nowait = true,
		remap = false,
		silent = false,
	},
	{
		";i",
		"<cmd>lua Snacks.picker.icons()<cr>",
		desc = "Icons",
		nowait = true,
		remap = false,
		silent = true,
	},
	{
		";l",
		"<cmd>lua Snacks.picker.lsp_symbols()<CR>",
		desc = "Show LSP document symbols",
		nowait = true,
		remap = false,
	},
	{
		";m",
		"<cmd>make<CR>",
		desc = "Make vim",
		nowait = true,
		remap = false,
	},
	{
		";M",
		function()
			vim.cmd('1TermExec cmd="make"')
			vim.defer_fn(function()
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true), "n", true)
			end, 50)
		end,
		desc = "Make command",
		nowait = true,
		remap = false,
	},
	{
		";n",
		[[:call ToggleNetrw() | :sil! /<C-R>=expand("%:t")<CR><CR> :nohlsearch<CR>]],
		-- "<cmd>topleft 40vsplit | Oil<CR>",
		desc = "Netrw",
		nowait = true,
		remap = false,
	},
	{ ";O", "<cmd>silent !xdg-open %:p:h<CR>", desc = "Open the current directory", nowait = true, remap = false },
	{ ";o", "<cmd>silent !xdg-open %<CR>", desc = "Open the current file", nowait = true, remap = false },
	{ ";P", "<cmd>silent lua Snacks.picker.zoxide()<CR>", desc = "Projects (zoxide)", nowait = true, remap = false },
	{ ";p", "<cmd>silent lua Snacks.picker.projects()<CR>", desc = "Projects", nowait = true, remap = false },
	{ ";Q", vim.cmd.qall, desc = "Close all windows", nowait = true, remap = false },
	{ ";q", vim.cmd.q, desc = "Close current window", nowait = true, remap = false },
	{
		";r",
		"<cmd>lua Snacks.picker.recent()<CR>",
		desc = "Show recently opened files",
		nowait = true,
		remap = false,
	},
	{
		";S",
		":%S/<C-r><C-w>//g<Left><left>",
		desc = "Change the word under the cursor in the whole file",
		nowait = true,
		remap = false,
		silent = false,
	},
	{
		";s",
		":S/<C-r><C-w>//g<Left><left>",
		desc = "Change the word under the cursor in the line",
		nowait = true,
		remap = false,
		silent = false,
	},
	-- { ";T", "<cmd>Telescope tags<CR>", desc = "tags", nowait = true, remap = false },
	{ ";t", "<cmd>lua Snacks.picker.todo_comments()<CR>", desc = "See notes/todos...", nowait = true, remap = false },
	{ ";U", "<cmd>e!<CR>", desc = "Undo all changes to the file", nowait = true, remap = false },
	{ ";u", vim.cmd.UndotreeToggle, desc = "Toggle Undotree", nowait = true, remap = false },
	{
		";x",
		"<cmd>silent ToggleTermSendCurrentLine<CR>",
		desc = "Execute the current line in terminal",
		nowait = true,
		remap = false,
	},
	{ ";z", "<cmd>lua Snacks.zen()<CR>", desc = "Toggle Zen Mode", nowait = true, remap = false },
	{ ";Z", "<cmd>lua Snacks.zen.zoom()<CR>", desc = "Maximize the window", nowait = true, remap = false },
	{ "<C-s>", "<cmd>silent update<CR>", desc = "Save buffer", nowait = true, remap = false },
	{ "<M-Down>", "<cmd>resize +1<CR>", desc = "Decrease window height", nowait = true, remap = false },
	{ "<M-Left>", "<cmd>vertical resize -1<CR>", desc = "Increase window width", nowait = true, remap = false },
	{ "<M-Right>", "<cmd>vertical resize +1<CR>", desc = "Decrease window width", nowait = true, remap = false },
	{ "<M-Up>", "<cmd>resize -1<CR>", desc = "Increase window height", nowait = true, remap = false },
	{ "<M-h>", "<CMD>silent NavigatorLeft<CR>", desc = "Go to the left window", nowait = true, remap = false },
	{ "<M-j>", "<CMD>silent NavigatorDown<CR>", desc = "Go to the down window", nowait = true, remap = false },
	{ "<M-k>", "<CMD>silent NavigatorUp<CR>", desc = "Go to the up window", nowait = true, remap = false },
	{ "<M-l>", "<CMD>silent NavigatorRight<CR>", desc = "Go to the right window", nowait = true, remap = false },
	{ "<M-p>", "<CMD>silent NavigatorPrevious<CR>", desc = "Go to the down window", nowait = true, remap = false },
	{ "<M-s>", "<cmd>wall<CR>", desc = "Save all buffers", nowait = true, remap = false },
	{
		"<M-t>",
		function()
			vim.cmd("ToggleTerm")
		end,
		desc = "Toggle terminal",
		nowait = true,
		remap = false,
	},
	{ "K", "<cmd>Lspsaga hover_doc<CR>", desc = "Hover info", nowait = true, remap = false },
	{
		"]E",
		function()
			require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
		end,
		desc = "Jump to the next error",
		nowait = true,
		remap = false,
	},
	{
		"]e",
		"<cmd>Lspsaga diagnostic_jump_next<CR>",
		desc = "Jump to the next diagnostic",
		nowait = true,
		remap = false,
	},
	{
		"[E",
		function()
			require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
		end,
		desc = "Jump to the previous error",
		nowait = true,
		remap = false,
	},
	{
		"[e",
		"<cmd>Lspsaga diagnostic_jump_prev<CR>",
		desc = "Jump to the previous diagnostic",
		nowait = true,
		remap = false,
	},
	{
		"]F",
		function()
			vim.cmd.colorscheme(flavors[#flavors])
			vim.notify(flavors[#flavors])
		end,
		desc = "Last flavor",
		nowait = true,
		remap = false,
	},
	{
		"]f",
		function()
			local index = 1
			for i, f in ipairs(flavors) do
				if vim.g.colors_name == f then
					index = i + 1
					break
				end
			end
			if index > #flavors then
				index = 1
			end
			vim.cmd.colorscheme(flavors[index])
			vim.notify(flavors[index])
		end,
		desc = "Next flavor",
		nowait = true,
		remap = false,
	},
	{
		"[F",
		function()
			vim.cmd.colorscheme(flavors[1])
			vim.notify(flavors[1])
		end,
		desc = "First flavor",
		nowait = true,
		remap = false,
	},
	{
		"[f",
		function()
			local index = #flavors
			for i = #flavors, 1, -1 do
				if vim.g.colors_name == flavors[i] then
					index = i - 1
					break
				end
			end
			if index < 1 then
				index = #flavors
			end
			vim.cmd.colorscheme(flavors[index])
			vim.notify(flavors[index])
		end,
		desc = "Previous flavor",
		nowait = true,
		remap = false,
	},
	{ "]h", "<cmd>silent Gitsigns next_hunk<CR>", desc = "Jump to the next hunk", nowait = true, remap = false },
	{ "[h", "<cmd>silent Gitsigns prev_hunk<CR>", desc = "Jump to the previous hunk", nowait = true, remap = false },
	{ "]p", "<cmd>pu<CR>", desc = "Paste below current line", nowait = true, remap = false },
	{ "[p", "<cmd>pu!<CR>", desc = "Paste above current line", nowait = true, remap = false },
	{
		"]t",
		function()
			require("todo-comments").jump_next()
		end,
		desc = "Next todo comment",
		nowait = true,
		remap = false,
	},
	{
		"[t",
		function()
			require("todo-comments").jump_prev()
		end,
		desc = "Previous todo comment",
		nowait = true,
		remap = false,
	},
	{
		"]x",
		"<cmd>BufferLineCloseRight<CR>",
		desc = "Close all the buffers to the right",
		nowait = true,
		remap = false,
	},
	{ "[x", "<cmd>BufferLineCloseLeft<CR>", desc = "Close all the buffers to the left", nowait = true, remap = false },
	{
		"_",
		function()
			vim.cmd("ToggleTerm direction=horizontal")
		end,
		desc = "Horizontal",
		nowait = true,
		remap = false,
	},
	{
		"dm",
		function()
			local mark = get_char(" ")
			if mark == "" then
				return
			end
			if mark == "!" then
				vim.cmd("delmarks!")
			else
				vim.cmd("delmarks " .. mark)
			end
		end,
		desc = "Delete marks",
		silent = false,
		nowait = true,
		remap = false,
	},
	{ "g?", "<cmd>WhichKey<CR>", desc = "WhichKey", nowait = true, remap = false },
	{ "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", desc = "Go to declaration", nowait = true, remap = false },
	{ "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", desc = "Go to definition", nowait = true, remap = false },
	{ "gF", "<c-w>vgf", desc = "Edit the file in a vertical split", nowait = true, remap = false },
	{ "gP", "<cmd>Lspsaga peek_type_definition<CR>", desc = "Peek type definition", nowait = true, remap = false },
	{ "gp", "<cmd>Lspsaga peek_definition<CR>", desc = "Show the definition", nowait = true, remap = false },
	{ "gra", "<cmd>Lspsaga code_action<CR>", desc = "Code actions", nowait = true, remap = false },
	{
		"grl",
		"<cmd>Lspsaga finder def+ref+imp<CR>",
		desc = "Show the definition, reference, implementation...",
		nowait = true,
		remap = false,
	},
	{
		"grR",
		function()
			vim.lsp.stop_client(vim.lsp.get_clients())
			vim.cmd("e")
		end,
		desc = "Restart LSP",
		nowait = true,
		remap = false,
	},
	{
		"grs",
		":lua vim.lsp.stop_client(vim.lsp.get_clients())<CR>",
		desc = "Stop LSP",
		nowait = true,
		remap = false,
	},
	{ "grn", "<cmd>Lspsaga rename<CR>", desc = "Rename the symbol", nowait = true, remap = false },
	{
		"gs",
		function()
			require("lsp_signature").toggle_float_win()
		end,
		desc = "Show signature",
		nowait = true,
		remap = false,
	},
	{
		"gy",
		"<cmd>lua vim.lsp.buf.type_definition()<CR>",
		desc = "Go to type definition",
		nowait = true,
		remap = false,
	},
	{
		"|",
		function()
			local size = vim.o.columns / 2
			vim.cmd("ToggleTerm size=" .. size .. " direction=vertical")
		end,
		desc = "Vertical",
		nowait = true,
		remap = false,
	},
	{ "<space>", group = "Groups", nowait = true, remap = false },
	{ "<space>1", "<cmd>tabn 1<CR>", desc = "Go to 1st tab", nowait = true, remap = false },
	{ "<space>2", "<cmd>tabn 2<CR>", desc = "Go to 2nd tab", nowait = true, remap = false },
	{ "<space>3", "<cmd>tabn 3<CR>", desc = "Go to 3rd tab", nowait = true, remap = false },
	{ "<space>4", "<cmd>tabn 4<CR>", desc = "Go to 4th tab", nowait = true, remap = false },
	{ "<space>5", "<cmd>tabn 5<CR>", desc = "Go to 5th tab", nowait = true, remap = false },
	{ "<space>6", "<cmd>tabn 6<CR>", desc = "Go to 6th tab", nowait = true, remap = false },
	{ "<space>7", "<cmd>tabn 7<CR>", desc = "Go to 7th tab", nowait = true, remap = false },
	{ "<space>8", "<cmd>tabn 8<CR>", desc = "Go to 8th tab", nowait = true, remap = false },
	{ "<space>9", "<cmd>tabn 9<CR>", desc = "Go to 9th tab", nowait = true, remap = false },
	{
		"<space><space>",
		function()
			require("toggleterm")
			if vim.fn.winwidth(0) > vim.g.big_screen_size then
				local size = vim.o.columns / 2
				vim.cmd(
					'execute "99ToggleTerm size=' .. size .. " direction=vertical dir=" .. vim.fn.expand("%:p:h") .. '"'
				)
			else
				vim.cmd('execute "99ToggleTerm dir=' .. vim.fn.expand("%:p:h") .. '"')
			end
		end,
		desc = "Open ToggleTerm in current file directory",
		nowait = true,
		remap = false,
	},
	{ "<space>b", group = "Buffer", nowait = true, remap = false },
	{ "<space>bO", "<cmd>silent %bd|e#|bd#<CR>|'\"", desc = "Close other buffers", nowait = true, remap = false },
	{
		"<space>bo",
		"<cmd>lua Snacks.bufdelete.other()<CR>",
		desc = "Close other buffers",
		nowait = true,
		remap = false,
	},
	{ "<space>bP", "<cmd>BufferLineTogglePin<CR>", desc = "Pin buffer", nowait = true, remap = false },
	{ "<space>ba", "<cmd>bufdo bd<CR>", desc = "Close all buffers", nowait = true, remap = false },
	{ "<space>bd", "<cmd>silent bd<CR>", desc = "Close this buffer", nowait = true, remap = false },
	{
		"<space>be",
		function()
			local current_buffer = vim.api.nvim_get_current_buf()
			local buffers = vim.api.nvim_list_bufs()

			for _, buf in ipairs(buffers) do
				if buf ~= current_buffer and vim.api.nvim_buf_is_valid(buf) then
					local buf_name = vim.api.nvim_buf_get_name(buf)
					local buf_loaded = vim.api.nvim_buf_is_loaded(buf)
					local buf_empty = buf_loaded and vim.api.nvim_buf_line_count(buf) <= 1

					if buf_empty and buf_name == "" then
						vim.api.nvim_buf_delete(buf, { force = true })
					end
				end
			end
			require("bufferline.ui").refresh()
		end,
		desc = "Close empty buffers (not current one)",
		nowait = true,
		remap = false,
	},
	{
		"<space>bh",
		"<cmd>BufferLineMovePrev<CR>",
		desc = "Move the buffer to the previous position",
		nowait = true,
		remap = false,
	},
	{
		"<space>bl",
		"<cmd>BufferLineMoveNext<CR>",
		desc = "Move the buffer to the next position",
		nowait = true,
		remap = false,
	},
	{
		"<space>bm",
		":ScopeMoveBuf ",
		desc = "Move current buffer to the specified tab",
		nowait = true,
		remap = false,
		silent = false,
	},
	{ "<space>bp", "<cmd>BufferLinePick<CR>", desc = "Pick a Buffer", nowait = true, remap = false },
	{ "<space>c", group = "Calendar", nowait = true, remap = false, icon = " " },
	{ "<space>cD", "<cmd>Calendar -view=days<CR>", desc = "View Days", nowait = true, remap = false },
	{
		"<space>cO",
		"<cmd>silent !open https://calendar.google.com/calendar/u/0/r/tasks<CR>",
		desc = "Open Google Tasks",
		nowait = true,
		remap = false,
	},
	{ "<space>cc", "<cmd>Calendar<CR>", desc = "Main Calendar (view month)", nowait = true, remap = false },
	{ "<space>cd", "<cmd>Calendar -view=day<CR>", desc = "View Day", nowait = true, remap = false },
	{ "<space>cg", ":Calendar ", desc = "Go to date (mm dd yyyy)", nowait = true, remap = false, silent = false },
	{
		"<space>co",
		"<cmd>silent !open https://calendar.google.com/calendar/u/0/r<CR>",
		desc = "Open Google Calendar",
		nowait = true,
		remap = false,
	},
	{ "<space>ct", "<cmd>Calendar -view=clock<CR>", desc = "View Clock", nowait = true, remap = false },
	{ "<space>cw", "<cmd>Calendar -view=week<CR>", desc = "View Week", nowait = true, remap = false },
	{ "<space>cy", "<cmd>Calendar -view=year<CR>", desc = "View Year", nowait = true, remap = false },
	{ "<space>d", group = "Debugger", nowait = true, remap = false },
	{
		"<space>dA",
		"<cmd>call TermDebugSendCommand('layout regs asm')<CR>",
		desc = "GDB: disassembly and registers",
		nowait = true,
		remap = false,
	},
	{
		"<space>dB",
		function()
			if vim.g.termdebug_running then
				vim.cmd("silent call TermDebugSendCommand('delete')")
			else
				require("dap").clear_breakpoints()
			end
		end,
		desc = "Delete all breakpoints",
		nowait = true,
		remap = false,
	},
	{
		"<space>dC",
		function()
			if vim.g.termdebug_running then
				vim.cmd("silent Until")
			else
				require("dap").run_to_cursor()
			end
		end,
		desc = "Run to cursor",
		nowait = true,
		remap = false,
	},
	{
		"<space>dN",
		function()
			if vim.g.termdebug_running then
				vim.cmd("silent call TermDebugSendCommand('reverse-step')")
			else
				require("dap").step_back()
			end
		end,
		desc = "Step back",
		nowait = true,
		remap = false,
	},
	{ "<space>dR", vim.cmd.DapToggleRepl, desc = "Toggle repl", nowait = true, remap = false },
	{ "<space>da", "<cmd>silent Asm<CR>", desc = "GDB: Disassembly", nowait = true, remap = false },
	{
		"<space>db",
		function()
			if vim.g.termdebug_running then
				vim.cmd("silent Break")
			else
				vim.cmd.DapToggleBreakpoint()
			end
		end,
		desc = "Break",
		nowait = true,
		remap = false,
	},
	{
		"<space>dc",
		function()
			if vim.g.termdebug_running then
				vim.cmd("silent call TermDebugSendCommand('c')")
			else
				vim.cmd.DapContinue()
			end
		end,
		desc = "Continue",
		nowait = true,
		remap = false,
	},
	{
		"<space>du",
		function()
			if vim.g.termdebug_running then
				vim.cmd("silent call TermDebugSendCommand('down 1')")
			else
				require("dap").down()
			end
		end,
		desc = "Go up in current stacktrace without stepping",
		nowait = true,
		remap = false,
	},
	{
		"<space>de",
		function()
			if vim.g.termdebug_running then
				vim.cmd("silent Evaluate")
			else
				require("dapui").eval(nil, { enter = true })
			end
		end,
		desc = "Evaluate expression",
		nowait = true,
		remap = false,
	},
	{
		"<space>df",
		function()
			if vim.g.termdebug_running then
				vim.cmd("silent Finish")
			else
				vim.cmd.DapStepOut()
			end
		end,
		desc = "Step out (finish)",
		nowait = true,
		remap = false,
	},
	{ "<space>dg", group = "Go programming language", nowait = true, remap = false },
	{
		"<space>dgl",
		function()
			require("dap-go").debug_last()
		end,
		desc = "Debug last go test",
		nowait = true,
		remap = false,
	},
	{
		"<space>dgt",
		function()
			require("dap-go").debug_test()
		end,
		desc = "Debug go test",
		nowait = true,
		remap = false,
	},
	{
		"<space>dh",
		function()
			require("dap.ui.widgets").hover()
		end,
		desc = "Hover",
		nowait = true,
		remap = false,
	},
	{
		"<space>dj",
		function()
			require("dap").goto_()
		end,
		desc = "Jump to a specific line or line under cursor",
		nowait = true,
		remap = false,
	},
	{
		"<space>dl",
		function()
			if vim.g.termdebug_running then
				vim.cmd("silent call TermDebugSendCommand('info locals')")
			else
				require("dap.ui.widgets").sidebar(require("dap.ui.widgets").scopes).open()
			end
		end,
		desc = "Locals",
		nowait = true,
		remap = false,
	},
	{
		"<space>dn",
		function()
			if vim.g.termdebug_running then
				vim.cmd("silent Over")
			else
				vim.cmd.DapStepOver()
			end
		end,
		desc = "Step over",
		nowait = true,
		remap = false,
	},
	{
		"<space>dp",
		function()
			require("dap").pause()
		end,
		desc = "Pause the thread",
		nowait = true,
		remap = false,
	},
	{
		"<space>dq",
		function()
			if vim.g.termdebug_running then
				vim.cmd("silent call TermDebugSendCommand('quit')")
			else
				vim.cmd.DapTerminate()
			end
		end,
		desc = "Stop/Terminate",
		nowait = true,
		remap = false,
	},
	{
		"<space>dr",
		function()
			if vim.g.termdebug_running then
				vim.cmd("silent call TermDebugSendCommand('start')")
			else
				require("dap").restart()
			end
		end,
		desc = "Restart",
		nowait = true,
		remap = false,
	},
	{
		"<space>ds",
		function()
			if vim.g.termdebug_running then
				vim.cmd("silent Step")
			else
				vim.cmd.DapStepInto()
			end
		end,
		desc = "Step into",
		nowait = true,
		remap = false,
	},
	{ "<space>dt", "<cmd>call TermDebugSendCommand('bt')<CR>", desc = "GDB: Bracktrace", nowait = true, remap = false },
	{
		"<space>dd",
		function()
			if vim.g.termdebug_running then
				vim.cmd("silent call TermDebugSendCommand('up 1')")
			else
				require("dap").up()
			end
		end,
		desc = "Go down in current stacktrace without stepping",
		nowait = true,
		remap = false,
	},
	{ "<space>dv", "<cmd>DapVirtualTextToggle<CR>", desc = "Dap virtual text", nowait = true, remap = false },
	{
		"<space>dw",
		function()
			require("dapui").elements.watches.add(nil)
		end,
		desc = "Watch the word under cursor",
		nowait = true,
		remap = false,
	},
	{ "<space>g", group = "Git", nowait = true, remap = false },
	{ "<space>gA", "<cmd>silent G restore --staged %<CR>", desc = "Unstage the file", nowait = true, remap = false },
	{ "<space>ga", "<cmd>silent G add %<CR>", desc = "Stage the file", nowait = true, remap = false },
	-- { "<space>gB", "<cmd>Gitsigns blame_line<CR>", desc = "Blame on the current line", nowait = true, remap = false },
	{ "<space>gB", "<cmd>silent G blame<CR>", desc = "Blame on the current file", nowait = true, remap = false },
	{
		"<space>gb",
		"<cmd>Gitsigns toggle_current_line_blame<CR>",
		desc = "git line blame",
		nowait = true,
		remap = false,
	},
	{ "<space>gC", ":silent G checkout ", desc = "Checkout", nowait = true, remap = false, silent = false },
	{
		"<space>gc",
		function()
			if vim.fn.winwidth(0) > vim.g.big_screen_size then
				vim.cmd("silent vertical G commit")
			else
				vim.cmd("silent G commit")
			end
		end,
		desc = "Commit",
		nowait = true,
		remap = false,
	},
	{
		"<space>gD",
		function()
			if vim.fn.winwidth(0) > vim.g.big_screen_size then
				vim.cmd("silent Gvdiffsplit! HEAD~")
			else
				vim.cmd("silent Gdiffsplit! HEAD~")
			end
		end,
		desc = "Diff with previous commit",
		nowait = true,
		remap = false,
	},
	{
		"<space>gd",
		function()
			if vim.fn.winwidth(0) > vim.g.big_screen_size then
				vim.cmd("silent Gvdiffsplit!")
			else
				vim.cmd("silent Gdiffsplit!")
			end
		end,
		desc = "Diff against the file",
		nowait = true,
		remap = false,
	},
	{
		"<space>gE",
		function()
			if vim.fn.winwidth(0) > vim.g.big_screen_size then
				vim.cmd("silent vertical G commit --amend")
			else
				vim.cmd("silent G commit --amend")
			end
		end,
		desc = "Amend (edit) commit with staged changes",
		nowait = true,
		remap = false,
	},
	{
		"<space>gl",
		function()
			if vim.fn.winwidth(0) > 96 then
				vim.cmd("silent vertical G log --decorate --graph --abbrev-commit | set filetype=git")
			else
				vim.cmd("silent G log --decorate --graph --abbrev-commit | set filetype=git")
			end
			vim.wo.listchars = "nbsp:.,precedes:❮,extends:❯,tab:  "
		end,
		desc = "Log",
		nowait = true,
		remap = false,
	},
	{ "<space>gP", "<cmd>silent G push<CR>", desc = "Push", nowait = true, remap = false },
	{ "<space>gR", "<cmd>silent G checkout HEAD -- %<CR>", desc = "Reset the file", nowait = true, remap = false },
	{ "<space>gS", ":silent G switch ", desc = "Switch", nowait = true, remap = false, silent = false },
	{
		"<space>gs",
		function()
			if vim.fn.winwidth(0) > vim.g.big_screen_size then
				vim.cmd("silent vertical Git")
			else
				vim.cmd("silent Git")
			end
		end,
		desc = "Status",
		nowait = true,
		remap = false,
	},
	{
		"<space>gT",
		"<cmd>Gitsigns toggle_current_line_blame<CR>",
		desc = "Toggle current line blame",
		nowait = true,
		remap = false,
	},
	{
		"<space>g[",
		function()
			git_previous()
			-- vim.cmd("G log -1 --stat")
		end,
		desc = "Checkout previous commit",
		nowait = true,
		remap = false,
	},
	{
		"<space>g]",
		function()
			git_next()
			-- vim.cmd("G log -1 --stat")
		end,
		desc = "checkout next commit",
		nowait = true,
		remap = false,
	},
	{ "<space>gf", "<cmd>silent G fetch<CR>", desc = "Fetch", nowait = true, remap = false },
	{ "<space>gG", ":Ggrep! -q ", desc = "Grep", nowait = true, remap = false, silent = false },
	{
		"<space>gg",
		"<cmd>call OpenLazyGit()<CR>",
		desc = "LazyGit",
		remap = false,
		silent = true,
		nowait = true,
	},
	{ "<space>gh", get_git_hash, desc = "copy current git hash to g register", nowait = true, remap = false },
	{
		"<space>gN",
		"<cmd>silent !xdg-open https://github.com/new<CR>",
		desc = "Create a new Respository",
		nowait = true,
		remap = false,
	},
	{
		"<space>gn",
		"<cmd>silent G! difftool HEAD~1 | cfirst <CR>",
		desc = "changed files since last commit",
		nowait = true,
		remap = false,
	},
	{
		"<space>gO",
		"<cmd>silent !xdg-open https://github.com/MAXIIIMVS<CR>",
		desc = "Open my github profile",
		nowait = true,
		remap = false,
	},
	{
		"<space>go",
		"<cmd>silent lua Snacks.gitbrowse()<CR>",
		desc = "Open in the browser",
		nowait = true,
		remap = false,
	},
	{ "<space>gp", "<cmd>silent G pull<CR>", desc = "Pull", nowait = true, remap = false },
	{
		"<space>gr",
		"<cmd>Gitsigns reset_hunk<CR>",
		desc = "Reset the hunk",
		nowait = true,
		remap = false,
	},
	{ "<space>gt", "<cmd>GitTimeLaps<CR>", desc = "Show time lapse of the file", nowait = true, remap = false },
	{ "<space>gw", group = "worktree", nowait = true, remap = false },
	{ "<space>gwL", ":G worktree lock ", desc = "Lock", nowait = true, remap = false, silent = false },
	{ "<space>gwR", ":G worktree repair ", desc = "Repair", nowait = true, remap = false, silent = false },
	{ "<space>gwa", ":G worktree add ", desc = "add", nowait = true, remap = false, silent = false },
	{ "<space>gwl", "<cmd>G worktree list<CR>", desc = "List", nowait = true, remap = false },
	{ "<space>gwm", ":G worktree move ", desc = "Move", nowait = true, remap = false, silent = false },
	{ "<space>gwp", "<cmd>G worktree prune<CR>", desc = "prune", nowait = true, remap = false },
	{ "<space>gwr", ":G worktree remove ", desc = "remove", nowait = true, remap = false, silent = false },
	{ "<space>gwu", ":G worktree unlock ", desc = "Unlock", nowait = true, remap = false, silent = false },
	{ "<space>s", group = "Session", nowait = true, remap = false },
	{
		"<space>sd",
		function()
			require("resession").delete(vim.fn.getcwd(), { dir = "dirsession", notify = true })
		end,
		desc = "Delete the session",
		nowait = true,
		remap = false,
	},
	{
		"<space>sl",
		function()
			require("resession").load(vim.fn.getcwd(), { dir = "dirsession", notify = false })
		end,
		desc = "Load the session",
		nowait = true,
		remap = false,
	},
	{
		"<space>ss",
		function()
			require("resession").save(vim.fn.getcwd(), { dir = "dirsession", notify = true })
		end,
		desc = "Save the session",
		nowait = true,
		remap = false,
	},
	{
		"<space>r",
		function()
			local reg = get_char("Enter the register name: ")
			if reg == "" then
				return
			end
			vim.cmd('1TermExec cmd="' .. vim.fn.getreg(reg) .. '"')
			vim.defer_fn(function()
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true), "n", true)
			end, 50)
		end,
		desc = "Run the command in register",
		silent = false,
		nowait = true,
		remap = false,
		icon = " ",
	},
	{ "<space>t", group = "Toggle", nowait = true, remap = false },
	{
		"<space>tb",
		function()
			vim.o.background = vim.o.background == "dark" and "light" or "dark"
		end,
		desc = "Background color (Light/dark)",
		nowait = true,
		remap = false,
	},
	{ "<space>tC", "<cmd>ColorizerToggle<CR>", desc = "Colorizer", nowait = true, remap = false },
	{
		"<space>tc",
		function()
			vim.wo.colorcolumn = vim.wo.colorcolumn == "" and "80" or ""
		end,
		desc = "Color column",
		nowait = true,
		remap = false,
	},
	{
		"<space>tD",
		function()
			vim.g.is_diff_on = not vim.g.is_diff_on
			vim.cmd("windo " .. (vim.g.is_diff_on and "diffthis" or "diffoff"))
		end,
		desc = "Difference between all windows",
		nowait = true,
		remap = false,
	},
	{ "<space>td", "<cmd>silent DBUIToggle<CR>", desc = "DB UI", nowait = true, remap = false },
	{ "<space>tH", "<cmd>TSToggle highlight<CR>", desc = "Treesitter highlight", nowait = true, remap = false },
	{
		"<space>th",
		function()
			vim.opt.cmdheight = vim.opt.cmdheight:get() == 0 and 1 or 0
		end,
		desc = "cmdheight",
		nowait = true,
		remap = false,
	},
	{
		"<space>ti",
		function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
		end,
		desc = "Inlay Hints",
		nowait = true,
		remap = false,
	},
	{
		"<space>tl",
		function()
			vim.g.show_cursorline = not vim.g.show_cursorline
			if not vim.g.show_cursorline then
				vim.o.cursorlineopt = "number,line"
			else
				vim.o.cursorlineopt = "number"
			end
		end,
		desc = "Cursor line",
		nowait = true,
		remap = false,
	},
	{
		"<space>tN",
		function()
			require("noice").cmd(vim.g.noice_enabled and "disable" or "enable")
			vim.g.noice_enabled = not vim.g.noice_enabled
		end,
		desc = "Noice",
		nowait = true,
		remap = false,
	},
	{
		"<space>tn",
		"<cmd>lua Snacks.notifier.show_history()<CR>",
		desc = "Notifier history",
		nowait = true,
		remap = false,
	},
	{ "<space>to", "<cmd>Lspsaga outline<CR>", desc = "Outline", nowait = true, remap = false },
	{
		"<space>tq",
		function()
			local qf_exists = false
			for _, win in pairs(vim.fn.getwininfo()) do
				if win["quickfix"] == 1 then
					qf_exists = true
				end
			end
			if qf_exists == true then
				vim.cmd("cclose")
				return
			end
			if not vim.tbl_isempty(vim.fn.getqflist()) then
				vim.cmd("copen")
			end
		end,
		desc = "Quick fix",
		nowait = true,
		remap = false,
	},
	{
		"<space>tr",
		function()
			vim.wo.relativenumber = not vim.wo.relativenumber
		end,
		desc = "Relative number",
		nowait = true,
		remap = false,
	},
	-- { "<space>tS", "<cmd>silent Sleuth<CR>", desc = "sleuth", nowait = true, remap = false },
	-- {
	-- 	"<space>tS",
	-- 	function()
	-- 		if vim.o.statusline == "" then
	-- 			require("lualine").hide({ unhide = true })
	-- 		else
	-- 			require("lualine").hide({ unhide = false })
	-- 			vim.o.statusline = "" -- "" is same as "%t %m"
	-- 		end
	-- 	end,
	-- 	desc = "Statusline/lualine",
	-- 	nowait = true,
	-- 	remap = false,
	-- },
	{
		"<space>tS",
		function()
			local cmd = "windo set scrollbind" .. (vim.wo.scrollbind and "!" or "")
			vim.wo.scrollbind = not vim.wo.scrollbind
			vim.cmd(cmd)
		end,
		desc = "Scrollbind",
		nowait = true,
		remap = false,
	},
	{
		"<space>ts",
		function()
			vim.wo.spell = not vim.wo.spell
		end,
		desc = "Spell",
		nowait = true,
		remap = false,
	},
	{
		"<space>tt",
		function()
			local found = false
			for _, f in ipairs(flavors) do
				if vim.g.colors_name == f then
					found = true
					break
				end
			end
			if not found then
				return
			end
			vim.g.is_transparent = not vim.g.is_transparent
			local osaka_options = require("solarized-osaka.config").options
			osaka_options.styles = {
				floats = vim.g.is_transparent and "transparent" or "normal",
				sidebars = vim.g.is_transparent and "transparent" or "normal",
			}
			osaka_options.transparent = vim.g.is_transparent
			local catppuccin = require("catppuccin")
			catppuccin.options.transparent_background = vim.g.is_transparent
			local nightfox = require("nightfox.config")
			nightfox.options.transparent = vim.g.is_transparent
			catppuccin.compile()
			vim.cmd("NightfoxCompile")
			vim.cmd.colorscheme(vim.g.colors_name)
		end,
		desc = "Transparency",
		nowait = true,
		remap = false,
	},
	{ "<space>tv", "<cmd>silent lua ToggleDiagnostics()<CR>", desc = "Virtual Text", nowait = true, remap = false },
	{ "<space>tw", "<cmd>silent e ~/notes/wiki/index.md<CR>", desc = "Wiki", nowait = true, remap = false },
	{
		"<space>w",
		function()
			-- NOTE: you need to install porsmo using cargo
			local command = get_char("<command> [(S)topwatch, (T)imer, (P)omodoro]: ")
			if command ~= "s" and command ~= "t" and command ~= "p" then
				print("invalid input")
				return
			end
			if command == "s" then
				vim.cmd('2TermExec name="Stopwatch" cmd="porsmo s"')
			elseif command == "t" then
				local time = vim.fn.input("Enter the time: ")
				vim.cmd('3TermExec name="Timer" cmd="porsmo t ' .. time .. '"')
			elseif command == "p" then
				local option = get_char("<duration> [(S)hort, (L)ong, (C)ustom]: ")
				if option ~= "s" and option ~= "l" and option ~= "c" then
					print("invalid input")
					return
				end
				if option == "c" then
					local time = vim.fn.input("Enter the time: ")
					vim.cmd('4TermExec name="Pomodoro" cmd="porsmo p c ' .. time .. '"')
				elseif option == "s" then
					vim.cmd('5TermExec name="Pomodoro" cmd="porsmo p s"')
				else
					vim.cmd('6TermExec name="Pomodoro"  cmd="porsmo p l"')
				end
			end
		end,
		desc = "Work (pomodoro, timer, stopwatch)",
		nowait = true,
		remap = false,
		icon = "󱎫 ",
	},
	{
		"<leader><leader>",
		function()
			vim.cmd("ToggleTerm direction=tab dir=%:p:h")
		end,
		desc = "Terminal in Tab",
		nowait = true,
		remap = false,
	},
	{ "<leader>c", "<cmd>silent CatppuccinCompile<CR>", desc = "Recompile Catppuccin", nowait = true, remap = false },
	{ "<leader>d", group = "DevDocs", nowait = true, remap = false },
	{ "<leader>dd", ":DevDocs delete ", desc = "Delete devdocs for ...", nowait = true, remap = false, silent = false },
	{ "<leader>df", "<cmd>DevDocs fetch<CR>", desc = "Fetch DevDocs", nowait = true, remap = false },
	{ "<leader>dg", ":DevDocs get ", desc = "Get devdocs for ...", nowait = true, remap = false, silent = false },
	{ "<leader>di", "<cmd>DevDocs install<CR>", desc = "Install DevDocs", nowait = true, remap = false },
	{ "<leader>h", group = "Hex", nowait = true, remap = false },
	{ "<leader>hr", "<cmd>%!xxd<CR> :set filetype=xxd<CR>", desc = "Show", nowait = true, remap = false },
	{
		"<leader>hw",
		"<cmd>%!xxd -r<CR> :set binary<CR> :set filetype=<CR>",
		desc = "Revert",
		nowait = true,
		remap = false,
	},
	{ "<leader>n", "<cmd>silent noa w<CR>", desc = "Save with no actions", nowait = true, remap = false },
	{
		"<leader>q",
		"<cmd>silent call CloseTabAndBuffers()<CR>",
		desc = "Close tab and buffers",
		nowait = true,
		remap = false,
	},
	{ "<leader>s", "<cmd>silent so %<CR>", desc = "Source the file", nowait = true, remap = false },
	{ "<leader>t", "<cmd>tabnew<CR>", desc = "Create a new tab", nowait = true, remap = false },
	{ "<leader>w", group = "VimWiki", nowait = true, remap = false },
	{
		"<leader>wl",
		"<cmd>VimwikiTOC<CR>",
		desc = "Create or update the Table of Contents for the current wiki file",
		nowait = true,
		remap = false,
	},
	{
		"<leader>x",
		"<cmd>silent !chmod u+x %<CR>",
		desc = "Make the file executable for the (u)ser , don't change (g)roup and (o)ther permissions",
		nowait = true,
		remap = false,
	},
	{
		mode = { "i" },
		{ "<C-k>", "<C-o>C", desc = "Delete to the end of the line", nowait = false, remap = false },
		{
			"<c-k><c-k>",
			"<cmd>lua Snacks.picker.icons()<cr>",
			desc = "Icons",
			nowait = true,
			remap = false,
			silent = true,
		},
		{ "<C-s>", "<ESC><ESC><cmd>silent update<CR>", desc = "Save buffer", nowait = true, remap = false }, -- not default
		{ "<C-x>", group = "Insert expand", nowait = true, remap = false },
		{ "<C-x><C-D>", desc = "Complete defined identifiers", nowait = true, remap = false },
		{ "<C-x><C-E>", desc = "Scroll up", nowait = true, remap = false },
		{ "<C-x><C-F>", desc = "Complete file names", nowait = true, remap = false },
		{ "<C-x><C-I>", desc = "Complete identifiers", nowait = true, remap = false },
		{ "<C-x><C-K>", desc = "Complete identifiers from dictionary", nowait = true, remap = false },
		{ "<C-x><C-L>", desc = "Complete whole lines", nowait = true, remap = false },
		{ "<C-x><C-N>", desc = "Next completion", nowait = true, remap = false },
		{ "<C-x><C-O>", desc = "Omni completion", nowait = true, remap = false },
		{ "<C-x><C-P>", desc = "Previous completion", nowait = true, remap = false },
		{ "<C-x><C-S>", desc = "Spelling suggestions", nowait = true, remap = false },
		{ "<C-x><C-T>", desc = "Complete identifiers from thesaurus", nowait = true, remap = false },
		{ "<C-x><C-U>", desc = "Complete with 'completefunc'", nowait = true, remap = false },
		{ "<C-x><C-V>", desc = "Complete like in : command line", nowait = true, remap = false },
		{ "<C-x><C-Y>", desc = "Scroll down", nowait = true, remap = false },
		{ "<C-x><C-Z>", desc = "Stop completion, keeping the text as-is", nowait = true, remap = false },
		{ "<C-x><C-]>", desc = "Complete tags", nowait = true, remap = false },
		{ "<C-x>s", desc = "Spelling suggestions", nowait = true, remap = false },
		{ "<M-h>", "<ESC><CMD>silent NavigatorLeft<CR>", desc = "Go to the left window", nowait = true, remap = false },
		{ "<M-j>", "<ESC><CMD>silent NavigatorDown<CR>", desc = "Go to the down window", nowait = true, remap = false },
		{ "<M-k>", "<ESC><CMD>silent NavigatorUp<CR>", desc = "Go to the up window", nowait = true, remap = false },
		{
			"<M-l>",
			"<ESC><CMD>silent NavigatorRight<CR>",
			desc = "Go to the right window",
			nowait = true,
			remap = false,
		},
		{ "<M-s>", "<ESC><cmd>wall<CR>", desc = "Save all buffers", nowait = true, remap = false },
	},
	{
		mode = { "v" },
		{ "<c-t>", ":Tabularize /", desc = "Tabularize", silent = false, nowait = true, remap = false },
		{ "<leader>m", [[ygvs<C-r>=<C-r>"<CR>]], desc = "Math Result", nowait = true, remap = false },
		{ ";", group = "Quick", nowait = true, remap = false },
		{ ";q", "<cmd>q<CR>", desc = "quit", nowait = true, remap = false },
		{
			";S",
			'y:%S/<C-r>"/<C-r>"/g<LEFT><LEFT>',
			desc = "Change the selection in whole document",
			nowait = true,
			remap = false,
			silent = false,
		},
		{
			";s",
			'y:S/<C-r>"/<C-r>"/g<LEFT><LEFT>',
			desc = "Change the selection in this line",
			nowait = true,
			remap = false,
			silent = false,
		},
		{
			";X",
			"<cmd>ToggleTermSendVisualSelection<CR>",
			desc = "Execute the selection in terminal",
			nowait = true,
			remap = false,
		},
		{
			";x",
			"<cmd>ToggleTermSendVisualLines<CR>",
			desc = "Execute the visual lines in terminal",
			nowait = true,
			remap = false,
		},
		{ "<", "<gv", desc = "Indent left", nowait = true, remap = false },
		{ ">", ">gv", desc = "Indent right", nowait = true, remap = false },
		{ "<C-s>", "<ESC><cmd>silent update<CR>", desc = "Save buffer", nowait = true, remap = false },
		{ "<M-s>", "<ESC><cmd>wall<CR>", desc = "Save all buffers", nowait = true, remap = false },
		{ "<space>g", group = "Git", nowait = true, remap = false },
		{ "<space>gW", "<cmd>Gitsigns undo_stage_hunk<CR>", desc = "Undo stage hunk", nowait = true, remap = false },
		{ "<space>gw", "<cmd>Gitsigns stage_hunk<CR>", desc = "Stage hunk", nowait = true, remap = false },
	},
	{
		mode = { "s" },
		{ "f", "f", desc = "f", nowait = true, remap = false },
		{ "F", "F", desc = "F", nowait = true, remap = false },
		{ "t", "t", desc = "t", nowait = true, remap = false },
		{ "T", "T", desc = "T", nowait = true, remap = false },
		{ "<C-a>", "<ESC>I", desc = "Go to the beginning of line", nowait = true, remap = false },
		{ "<C-e>", "<ESC>A", desc = "Go to the end of line", nowait = true, remap = false },
		{ "<C-d>", "<Delete>i", desc = "delete selection", nowait = true, remap = false },
		{ "<C-s>", "<ESC><cmd>silent update<CR>", desc = "Save buffer", nowait = true, remap = false },
		{ "<M-b>", "<ESC>bi", desc = "Move back", nowait = true, remap = false },
		{ "<M-d>", "<ESC>dei", desc = "Delete the next word", nowait = true, remap = false },
		{ "<M-f>", "<ESC>ei", desc = "Move forward", nowait = true, remap = false },
		{ "<M-s>", "<ESC><cmd>wall<CR>", desc = "Save all buffers", nowait = true, remap = false },
	},
	{
		mode = { "t" },
		{ "<Esc>", "<C-\\><C-n>", desc = "Quit insert mode", nowait = true, remap = false },
		{ "<M-Down>", "<cmd>resize -1<CR>", desc = "Increase window height", nowait = true, remap = false },
		{ "<M-Left>", "<cmd>vertical resize +2<CR>", desc = "Increase window width", nowait = true, remap = false },
		{ "<M-Right>", "<cmd>vertical resize -1<CR>", desc = "Decrease window width", nowait = true, remap = false },
		{ "<M-Up>", "<cmd>resize +1<CR>", desc = "Decrease window height", nowait = true, remap = false },
		{ "<M-h>", "<CMD>silent NavigatorLeft<CR>", desc = "Go to the left window", nowait = true, remap = false },
		{ "<M-j>", "<CMD>silent NavigatorDown<CR>", desc = "Go to the down window", nowait = true, remap = false },
		{ "<M-k>", "<CMD>silent NavigatorUp<CR>", desc = "Go to the up window", nowait = true, remap = false },
		{ "<M-l>", "<CMD>silent NavigatorRight<CR>", desc = "Go to the right window", nowait = true, remap = false },
	},
	{
		mode = { "n", "v" },
		{
			",C",
			function()
				vim.cmd("silent ! gnome-calculator &")
			end,
			desc = "Gnome Calculator",
			nowait = true,
			remap = false,
			silent = true,
		},
		{
			",c",
			function()
				local box_position = get_char("Enter the position of the box [(L)eft, (C)enter, (R)ight]: ")
				if box_position == "" then
					return
				end
				local text_justification = get_char("Enter text justification [(L)eft, (C)enter, (R)ight, (A)dapter]: ")
				if text_justification == "" then
					return
				end
				local box_or_line = get_char("(B)ox or (L)ine: ")
				if box_or_line == "" then
					return
				end
				if box_or_line == "l" then
					box_or_line = "line"
				else
					box_or_line = "box"
				end
				require("comment-box")
				vim.cmd("CB" .. box_position .. text_justification .. box_or_line)
			end,
			desc = "Comment Box",
			silent = false,
			nowait = true,
			remap = false,
		},
	},
	{
		mode = { "n", "t", "v", "s" },
		{
			"<leader>f",
			function()
				vim.lsp.buf.format({ async = true })
			end,
			desc = "Format buffer/range",
			nowait = true,
			remap = false,
		},
	},
	{
		mode = { "i", "n", "t", "v" },
		{ "<M-S-T>", "<cmd>ToggleTermToggleAll<CR>", desc = "Toggle All terminals", nowait = true, remap = false },
		{ "<F4>", term_debug, desc = "Start GDB", nowait = true, remap = false },
		{
			"<F5>",
			function()
				if vim.g.termdebug_running then
					vim.cmd("silent Break")
					vim.cmd("silent call TermDebugSendCommand('c')")
				else
					require("dap").clear_breakpoints()
					vim.cmd.DapToggleBreakpoint()
					vim.cmd.DapContinue()
				end
			end,
			desc = "Break and Continue/Start DAP",
			nowait = true,
			remap = false,
		},
		{
			"<F7>",
			function()
				if vim.g.termdebug_running then
					vim.cmd("silent call TermDebugSendCommand('up 1')")
				else
					require("dap").up()
				end
			end,
			desc = "Go down in current stacktrace without stepping",
			nowait = true,
			remap = false,
		},
		{
			"<S-F7>",
			function()
				if vim.g.termdebug_running then
					vim.cmd("silent call TermDebugSendCommand('down 1')")
				else
					require("dap").down()
				end
			end,
			desc = "Go up in current stacktrace without stepping",
			nowait = true,
			remap = false,
		},
		{
			"<F19>",
			function()
				if vim.g.termdebug_running then
					vim.cmd("silent call TermDebugSendCommand('down 1')")
				else
					require("dap").down()
				end
			end,
			desc = "Go up in current stacktrace without stepping",
			nowait = true,
			remap = false,
		},
		{
			"<F8>",
			function()
				if vim.g.termdebug_running then
					vim.cmd("silent call TermDebugSendCommand('c')")
				else
					require("dap")
					vim.cmd.DapContinue()
				end
			end,
			desc = "Continue/Start DAP",
			nowait = true,
			remap = false,
		},
		{
			"<F9>",
			function()
				if vim.g.termdebug_running then
					vim.cmd("silent Break")
				else
					require("dap")
					vim.cmd.DapToggleBreakpoint()
				end
			end,
			desc = "Break",
			nowait = true,
			remap = false,
		},
		{
			"<F10>",
			function()
				if vim.g.termdebug_running then
					vim.cmd("silent Over")
				else
					vim.cmd.DapStepOver()
				end
			end,
			desc = "Step over",
			nowait = true,
			remap = false,
		},
		{
			"<F11>",
			function()
				if vim.g.termdebug_running then
					vim.cmd("silent Step")
				else
					vim.cmd.DapStepInto()
				end
			end,
			desc = "Step into",
			nowait = true,
			remap = false,
		},
		{
			"<F12>",
			function()
				if vim.g.termdebug_running then
					vim.cmd("silent Evaluate")
				else
					require("dapui").eval(nil, { enter = true })
				end
			end,
			desc = "Evaluate",
			nowait = true,
			remap = false,
		},
		{
			"<S-F5>",
			function()
				if vim.g.termdebug_running then
					vim.cmd("silent call TermDebugSendCommand('quit')")
				else
					vim.cmd.DapTerminate()
				end
			end,
			desc = "Stop/Terminate",
			nowait = true,
			remap = false,
		},
		{
			"<F17>",
			function()
				if vim.g.termdebug_running then
					vim.cmd("silent call TermDebugSendCommand('quit')")
				else
					vim.cmd.DapTerminate()
				end
			end,
			desc = "Stop/Terminate",
			nowait = true,
			remap = false,
		},
		{
			"<S-F11>",
			function()
				if vim.g.termdebug_running then
					vim.cmd("silent Finish")
				else
					vim.cmd.DapStepOut()
				end
			end,
			desc = "Step out",
			nowait = true,
			remap = false,
		},
		{
			"<F23>",
			function()
				if vim.g.termdebug_running then
					vim.cmd("silent Finish")
				else
					vim.cmd.DapStepOut()
				end
			end,
			desc = "Step out",
			nowait = true,
			remap = false,
		},
		{
			"<C-F5>",
			function()
				vim.cmd('1TermExec cmd="' .. vim.fn.getreg("r") .. '"')
			end,
			desc = "Start without debugging",
			nowait = true,
			remap = false,
		},
		{
			"<F29>",
			function()
				vim.cmd('1TermExec cmd="' .. vim.fn.getreg("r") .. '"')
			end,
			desc = "Start without debugging",
			nowait = true,
			remap = false,
		},
		{
			"<C-F9>",
			function()
				if vim.g.termdebug_running then
					vim.cmd("silent call TermDebugSendCommand('delete')")
				else
					require("dap").clear_breakpoints()
				end
			end,
			desc = "Delete all breakpoints",
			nowait = true,
			remap = false,
		},
		{
			"<F33>",
			function()
				if vim.g.termdebug_running then
					vim.cmd("silent call TermDebugSendCommand('delete')")
				else
					require("dap").clear_breakpoints()
				end
			end,
			desc = "Delete all breakpoints",
			nowait = true,
			remap = false,
		},
		{
			"<C-F10>",
			function()
				if vim.g.termdebug_running then
					vim.cmd("silent Until")
				else
					require("dap").run_to_cursor()
				end
			end,
			desc = "Run to cursor",
			nowait = true,
			remap = false,
		},
		{
			"<F34>",
			function()
				if vim.g.termdebug_running then
					vim.cmd("silent Until")
				else
					require("dap").run_to_cursor()
				end
			end,
			desc = "Run to cursor",
			nowait = true,
			remap = false,
		},
		{
			"<C-S-F5>",
			function()
				if vim.g.termdebug_running then
					vim.cmd("silent call TermDebugSendCommand('start')")
				else
					require("dap").restart()
				end
			end,
			desc = "Restart",
			nowait = true,
			remap = false,
		},
		{
			"<F41>",
			function()
				if vim.g.termdebug_running then
					vim.cmd("silent call TermDebugSendCommand('start')")
				else
					require("dap").restart()
				end
			end,
			desc = "Restart",
			nowait = true,
			remap = false,
		},
	},
	-- {
	-- 	mode = { "i", "n", "v" },
	-- 	{ "<c-e>", "<Plug>(VM-Select-All)", desc = "Select all", nowait = true, remap = false },
	-- },
})

function toggle_todo_window(todo_file)
	if vim.g.is_todo_open then
		vim.cmd("q")
		return
	end

	if vim.fn.filereadable(todo_file) == 0 then
		local default_content = {
			"# [Project Name]",
			"",
			"## Doing",
			"",
			"",
			"## Tasks",
			"",
			"",
		}
		vim.fn.writefile(default_content, todo_file)
	end

	local buf = vim.api.nvim_create_buf(false, false)
	vim.api.nvim_buf_set_name(buf, todo_file)

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
	})
	vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
	vim.g.is_todo_open = true
	vim.api.nvim_win_set_option(win, "spell", true)
	vim.api.nvim_buf_set_keymap(buf, "n", "q", "<cmd>q<CR>", { noremap = true, silent = true })
	vim.api.nvim_buf_set_keymap(buf, "n", "<C-c>", "<cmd>q<CR>", { noremap = true, silent = true })
	vim.api.nvim_buf_set_keymap(buf, "n", ";;", "<cmd>q<CR>", { noremap = true, silent = true })
	vim.api.nvim_buf_set_keymap(
		buf,
		"n",
		"<leader>p",
		"<cmd>w | RclonePush " .. todo_file .. "<CR>",
		{ noremap = true, silent = true, desc = "Push changes to gdrive" }
	)

	vim.api.nvim_create_autocmd("WinClosed", {
		pattern = tostring(win),
		once = true, -- Ensure it only runs once per window lifetime
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

			local function save_file()
				vim.fn.writefile(lines, todo_file)
			end

			if is_empty then
				vim.ui.input({ prompt = "File is empty. Save anyway? (y/n): " }, function(input)
					if input and input:lower() == "y" then
						save_file()
					end
					-- Silently delete the buffer via API (does not trigger Neovim exit)
					pcall(vim.api.nvim_buf_delete, buf, { force = true })
				end)
			else
				save_file()
				pcall(vim.api.nvim_buf_delete, buf, { force = true })
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
	local todo_file = vim.fn.expand(os.getenv("HOME") .. "/.todo.md")
	toggle_todo_window(todo_file)
end

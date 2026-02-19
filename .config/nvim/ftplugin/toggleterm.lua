vim.keymap.set("n", "gf", function()
	local cfile = vim.fn.expand("<cfile>")
	local cword = vim.fn.expand("<cWORD>")

	-- 1. Find the file (recursive search)
	local f = vim.fn.findfile(cfile, "**")
	if f == "" then
		vim.notify("No file under cursor", vim.log.levels.WARN)
		return
	end

	-- 2. Extract coordinates (C# or Standard formats)
	local line, col
	-- Try C# style: (line,col)
	line, col = cword:match("%((%d+),(%d+)%)")

	-- If not C#, try standard: :line:col or :line
	if not line then
		line, col = cword:match(":(%d+):(%d+)")
		if not line then
			line = cword:match(":(%d+)")
		end
	end

	-- 3. Close terminal and jump to file
	vim.cmd("ToggleTerm")
	vim.schedule(function()
		vim.cmd("e " .. f)

		if line then
			local l = tonumber(line)
			local c = tonumber(col) or 1
			-- Set cursor (API uses 0-indexed columns)
			pcall(vim.api.nvim_win_set_cursor, 0, { l, c - 1 })
			vim.cmd("normal! zz") -- Center screen
		end
	end)
end, { buffer = true, desc = "Go to file (line/col)", nowait = true })

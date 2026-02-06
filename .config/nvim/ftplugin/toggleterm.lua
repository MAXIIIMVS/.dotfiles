vim.keymap.set("n", "gf", function()
	local f = vim.fn.findfile(vim.fn.expand("<cfile>"), "**")
	if f == "" then
		vim.cmd("lua vim.notify('No file under cursor', vim.log.levels.WARN, nil)")
	else
		vim.cmd("ToggleTerm") -- hide terminal (avoid opening the file in toggleterm window)
		vim.schedule(function()
			vim.cmd("e " .. f)
		end)
	end
end, { buffer = true, desc = "Go to file", nowait = true })

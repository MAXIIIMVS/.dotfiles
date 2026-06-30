function OpenLazyGit()
	if vim.g.zen_mode then
		vim.cmd("lua Snacks.zen()")
		vim.g.restore_zen_mode = true
	end
	-- Save the buffer we came from
	vim.g.lazygit_source_buf = vim.api.nvim_get_current_buf()

	-- set notermguicolors " uncomment this if you're not using a theme for lazygit
	vim.cmd("terminal lazygit")
	-- terminal lazygit --use-config-file=\"$HOME/.config/lazygit/config.yml,$HOME/.config/lazygit/themes/catppuccin/themes-mergable/mocha/peach.yml\""
	vim.api.nvim_buf_set_keymap(0, "t", "<ESC>", "<ESC>", { noremap = true, silent = true })
	vim.cmd("startinsert")
	vim.cmd("redraw!")

	local lazygit_group = vim.api.nvim_create_augroup("LazyGit", { clear = true })
	vim.api.nvim_create_autocmd("WinResized", {
		group = lazygit_group,
		buffer = 0,
		callback = function()
			vim.cmd("redraw")
		end,
	})

	vim.api.nvim_create_autocmd("TermClose", {
		group = lazygit_group,
		buffer = 0,
		callback = function()
			OnLazyGitClose()
		end,
	})

	-- autocmd TermClose * set termguicolors " uncomment this if you're not using a theme for lazygit
end

function OnLazyGitClose()
	vim.cmd("lua Snacks.bufdelete()")

	if vim.g.lazygit_source_buf and vim.api.nvim_buf_is_valid(vim.g.lazygit_source_buf) then
		vim.cmd("buffer " .. vim.g.lazygit_source_buf)
		vim.cmd("silent! Gitsigns refresh")
	end
	if vim.g.restore_zen_mode then
		vim.g.restore_zen_mode = false
		vim.cmd("lua Snacks.zen()")
	end
end

vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		-- NOTE: requires https://github.com/catppuccin/lazygit
		local base = vim.fn.expand("$HOME/.config/lazygit/")
		local theme = vim.o.background == "dark" and "themes/catppuccin/themes-mergable/mocha/peach.yml"
			or "themes/catppuccin/themes-mergable/latte/red.yml"
		vim.env.LG_CONFIG_FILE = base .. "config.yml," .. base .. theme
	end,
})

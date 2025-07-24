vim.g.is_transparent = false
vim.g.termdebug_running = false
vim.g.show_cursorline = true
vim.g.is_diff_on = false
vim.g.is_todo_open = false
vim.g.big_screen_size = 150

if vim.loader then
	vim.loader.enable()
end

require("user")

vim.o.secure = true
vim.cmd.colorscheme("catppuccin")

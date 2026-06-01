vim.g.termdebug_running = false
vim.g.show_cursorline = true
vim.g.is_diff_on = false
vim.g.is_todo_open = false
vim.g.big_screen_size = 120
vim.g.zen_mode = false

if vim.loader then
	vim.loader.enable()
end

require("user")

vim.o.secure = true
vim.g.is_transparent = get_transparency()
vim.cmd.colorscheme("retrobox")

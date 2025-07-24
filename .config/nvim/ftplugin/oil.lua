local function open_project_root()
	local root = vim.fn["FindRootDirectory"]()
	vim.cmd("Oil " .. vim.fn.fnameescape(root))
end

vim.keymap.set("n", "gr", open_project_root, { buffer = true, silent = true, desc = "Go to project root" })

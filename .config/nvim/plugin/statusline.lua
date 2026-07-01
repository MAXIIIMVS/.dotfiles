local mode_names = {
	n = "NORMAL",
	i = "INSERT",
	v = "VISUAL",
	V = "V-LINE",
	[""] = "V-BLOCK",
	c = "COMMAND",
	no = "OP-PENDING",
	s = "SELECT",
	S = "S-LINE",
	[""] = "S-BLOCK",
	ic = "INS-COMP",
	R = "REPLACE",
	Rv = "V-REPLACE",
	cv = "VIM-EX",
	ce = "EX",
	r = "PROMPT",
	rm = "MORE",
	["r?"] = "CONFIRM",
	["!"] = "SHELL",
	t = "TERMINAL",
}

local mode_hl_map = {
	n = "StatuslineMode_n",
	i = "StatuslineMode_i",
	v = "StatuslineMode_v",
	V = "StatuslineMode_V",
	[""] = "StatuslineMode_vB",
	c = "StatuslineMode_c",
	no = "StatuslineMode_no",
	s = "StatuslineMode_s",
	S = "StatuslineMode_S",
	[""] = "StatuslineMode_sB",
	ic = "StatuslineMode_ic",
	R = "StatuslineMode_R",
	Rv = "StatuslineMode_Rv",
	cv = "StatuslineMode_cv",
	ce = "StatuslineMode_ce",
	r = "StatuslineMode_r",
	rm = "StatuslineMode_rm",
	["r?"] = "StatuslineMode_r_q",
	["!"] = "StatuslineMode_bang",
	t = "StatuslineMode_t",
}

local mode_cache = {}
for mode, hl in pairs(mode_hl_map) do
	mode_cache[mode] = {
		left = "%#" .. hl .. "#▊ %*",
		tag = "%#" .. hl .. "#" .. (mode_names[mode] or "NORMAL") .. "%*",
		right = "%#" .. hl .. "#▊%*",
	}
end

local PATH_LINE = " %#StatuslineDefault#%f%*"
local MODIFIED = " %#StatuslineMacro#%m%*"
local LINE_COL = " %#StatuslinePercentage#%l:%c%*"
local MIDDLE_GAP = "%#StatuslineFill#%=%*"
local PERCENTAGE = "%#StatuslinePercentage# %p%% %*"

local function show_macro_recording()
	local recording_register = vim.fn.reg_recording()
	if recording_register == "" then
		return ""
	end
	return "%#StatuslineMacro# REC @" .. recording_register .. " %*"
end

local function search_count()
	if vim.v.hlsearch == 0 then
		return ""
	end
	local ok, result = pcall(vim.fn.searchcount, { maxcount = 999, timeout = 250 })
	if not ok or next(result) == nil or result.total == 0 then
		return ""
	end
	return "%#StatuslineSearchCount#[" .. result.current .. "/" .. result.total .. "] %*"
end

local function selection_count(mode)
	if not (mode == "v" or mode == "V" or mode == "") then
		return ""
	end

	local starts = vim.fn.getpos("v")
	local ends = vim.fn.getpos(".")
	local line_count = math.abs(ends[2] - starts[2]) + 1

	if mode == "V" then
		return "%#StatuslineSelection# " .. line_count .. "L %*"
	elseif mode == "v" then
		local char_count = math.abs(ends[3] - starts[3]) + 1
		if line_count == 1 then
			return "%#StatuslineSelection# " .. char_count .. "C %*"
		else
			return "%#StatuslineSelection# " .. line_count .. "L " .. char_count .. "C %*"
		end
	elseif mode == "" then
		local char_count = math.abs(ends[3] - starts[3]) + 1
		return "%#StatuslineSelection# " .. line_count .. "x" .. char_count .. " %*"
	end
	return ""
end

local lsp_cache = {}

local function update_lsp_cache(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	if not vim.api.nvim_buf_is_valid(bufnr) then
		return
	end

	local clients = vim.lsp.get_clients({ bufnr = bufnr })
	if #clients == 0 then
		lsp_cache[bufnr] = ""
		return
	end

	local seen = {}
	local names = {}
	for _, client in ipairs(clients) do
		if not seen[client.name] then
			seen[client.name] = true
			names[#names + 1] = client.name
		end
	end

	lsp_cache[bufnr] = #names > 0 and ("[" .. table.concat(names, ", ") .. "] ") or ""
end

vim.api.nvim_create_autocmd({ "LspAttach", "LspDetach", "BufEnter" }, {
	callback = function(args)
		vim.schedule(function()
			update_lsp_cache(args.buf)
		end)
	end,
})

local function get_lsp_clients()
	return lsp_cache[vim.api.nvim_get_current_buf()] or ""
end

_G.native_statusline = function()
	local mode = vim.fn.mode()
	local cached = mode_cache[mode] or mode_cache.n

	local left_bar = cached.left
	local mode_tag = cached.tag
	local s_count = search_count()
	local v_count = selection_count(mode)
	local macro_status = show_macro_recording()

	local lsp = get_lsp_clients()
	local lsp_status = lsp ~= "" and ("%#StatuslineLSP#" .. lsp .. "%*") or ""
	local right_bar = cached.right

	return table.concat({
		left_bar,
		mode_tag,
		PATH_LINE,
		LINE_COL,
		PERCENTAGE,
		MODIFIED,
		MIDDLE_GAP,
		s_count,
		v_count,
		macro_status,
		lsp_status,
		right_bar,
	})
end

local function is_tmux_running()
	return vim.env.TMUX ~= nil and vim.env.TMUX ~= ""
end

local function set_tmux_window_bg(color)
	if not is_tmux_running() then
		return
	end

	local args = (color == "default") and { "set-option", "-wu", "@nvim_bg" }
		or { "set-option", "-w", "@nvim_bg", color }

	-- Run the initial tmux setting asynchronously
	vim.loop.spawn("tmux", { args = args }, function(code)
		if code == 0 then
			-- Once set, queue the refresh-client call asynchronously on the main loop
			vim.schedule(function()
				vim.loop.spawn("tmux", { args = { "refresh-client", "-S" } }, function() end)
			end)
		end
	end)
end

local function sync_statusline_with_tmux()
	local normal_hl = vim.api.nvim_get_hl(0, { name = "Normal" })
	local current_background = normal_hl.bg and string.format("#%06x", normal_hl.bg) or "default"

	vim.api.nvim_set_hl(0, "StatusLine", { bg = current_background == "default" and "NONE" or "bg" })
	set_tmux_window_bg(current_background)
end

function tmux_nv()
	if vim.env.TMUX then
		local val = vim.fn.system("tmux show-environment -g NVIM_TRANSPARENT 2>/dev/null")
		return val:match("NVIM_TRANSPARENT=(%d)") == "1"
	end
	return false
end

-- Force instant UI refreshes when entering or leaving macro recordings
vim.api.nvim_create_autocmd("RecordingEnter", {
	pattern = "*",
	callback = function()
		vim.cmd("redrawstatus")
	end,
})
vim.api.nvim_create_autocmd("RecordingLeave", {
	pattern = "*",
	callback = function()
		vim.cmd("redrawstatus")
	end,
})

vim.api.nvim_create_autocmd("BufWinLeave", {
	pattern = "*",
	callback = function()
		if vim.o.laststatus ~= 3 then
			vim.o.laststatus = 3
		end
	end,
})

local tmux_group = vim.api.nvim_create_augroup("sync_tmux", { clear = true })

vim.api.nvim_create_autocmd("ColorScheme", {
	group = tmux_group,
	callback = function()
		vim.schedule(sync_statusline_with_tmux)
	end,
})

vim.api.nvim_create_autocmd("VimLeave", {
	group = tmux_group,
	callback = function()
		set_tmux_window_bg("default")
	end,
})

vim.o.laststatus = 3
vim.o.statusline = "%!v:lua.native_statusline()"

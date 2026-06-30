-- =========================================================================
-- 1. Mode Layout Translators & Mapping Matrix
-- =========================================================================
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

-- =========================================================================
-- 2. Hyper-Optimized Dynamic Components
-- =========================================================================
local function show_macro_recording()
	local recording_register = vim.fn.reg_recording()
	if recording_register == "" then
		return ""
	end
	return string.format("%%#StatuslineMacro# REC @%s %%*", recording_register)
end

local function search_count()
	if vim.v.hlsearch == 0 then
		return ""
	end
	-- Timeout and maxcount protect performance on massive files
	local ok, result = pcall(vim.fn.searchcount, { maxcount = 999, timeout = 250 })
	if not ok or next(result) == nil or result.total == 0 then
		return ""
	end
	return string.format("%%#StatuslineSearchCount#[%d/%d] %%*", result.current, result.total)
end

local function selection_count()
	local mode = vim.fn.mode()
	if not (mode == "v" or mode == "V" or mode == "") then
		return ""
	end

	local starts = vim.fn.getpos("v")
	local ends = vim.fn.getpos(".")
	local line_count = math.abs(ends[2] - starts[2]) + 1

	if mode == "V" then
		return string.format("%%#StatuslineSelection# %dL %%*", line_count)
	elseif mode == "v" then
		local char_count = math.abs(ends[3] - starts[3]) + 1
		if line_count == 1 then
			return string.format("%%#StatuslineSelection# %dC %%*", char_count)
		else
			return string.format("%%#StatuslineSelection# %dL %dC %%*", line_count, char_count)
		end
	elseif mode == "" then
		local char_count = math.abs(ends[3] - starts[3]) + 1
		return string.format("%%#StatuslineSelection# %dx%d %%*", line_count, char_count)
	end
	return ""
end

-- Cache LSP string per buffer to avoid querying active clients on every keypress
local lsp_cache = {}

local function update_lsp_cache(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	if not vim.api.nvim_buf_is_valid(bufnr) then
		return
	end

	local buf_ft = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
	local clients = vim.lsp.get_clients({ bufnr = bufnr })

	if next(clients) == nil then
		lsp_cache[bufnr] = ""
		return
	end

	local unique_names = {}
	for _, client in ipairs(clients) do
		if not vim.tbl_contains(unique_names, client.name) then
			table.insert(unique_names, client.name)
		end
	end

	if #unique_names == 0 then
		lsp_cache[bufnr] = ""
	else
		lsp_cache[bufnr] = "[" .. table.concat(unique_names, ", ") .. "]"
	end
end

-- Refresh cache only on LSP state changes or buffer swaps.
-- vim.schedule prevents ghosting when stopping/disabling an LSP.
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

-- =========================================================================
-- 3. Core Statusline Engine Methods
-- =========================================================================
_G.native_statusline = function()
	local mode = vim.fn.mode()
	local mode_hl = mode_hl_map[mode] or "StatuslineMode_n"
	local mode_str = mode_names[mode] or "NORMAL"

	local left_bar = string.format("%%#%s#▊ %%*", mode_hl)
	local mode_tag = string.format("%%#%s#%s%%*", mode_hl, mode_str)
	local path = " %#StatuslineDefault#%f%*"
	local line_col = " %#StatuslinePercentage#%l:%c%*"

	local middle_gap = "%#StatuslineFill#%=%*"

	local s_count = search_count()
	local v_count = selection_count()
	local macro_status = show_macro_recording()
	local lsp_status = "%#StatuslineLSP#" .. get_lsp_clients() .. "%*"
	local percentage = "%#StatuslinePercentage# %p%% %*"
	local right_bar = string.format("%%#%s#▊%%*", mode_hl)

	return table.concat({
		left_bar,
		mode_tag,
		path,
		line_col,
		middle_gap,
		s_count,
		v_count,
		macro_status,
		lsp_status,
		percentage,
		right_bar,
	})
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

vim.o.laststatus = 3
vim.o.statusline = "%!v:lua.native_statusline()"

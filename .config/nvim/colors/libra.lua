-- Name:         Libra.nvim
-- Description:  Yoinked from retrobox and catppuccin; Designed by Mustafa Hayati.

local hl = vim.api.nvim_set_hl

-- Reset existing highlights to prevent bleeding from previous themes
vim.cmd("hi clear")
if vim.fn.exists("syntax_on") == 1 then
	vim.cmd("syntax reset")
end
vim.g.colors_name = "libra"

local retro_dark = {
	bg0 = "#282828",
	bg1 = "#3c3836",
	bg2 = "#504945",
	bg3 = "#665c54",
	bg4 = "#0e0b16",
	fg0 = "#fbf1c7",
	fg1 = "#ebdbb2",
	fg2 = "#d5c4a1",
	fg3 = "#bdae93",
	fg4 = "#a89984",
	red = "#fb4934",
	green = "#b8bb26",
	yellow = "#fabd2f",
	blue = "#83a598",
	purple = "#d3869b",
	aqua = "#8ec07c",
	orange = "#fe8019",
	grey = "#928374",
	sign_bg = "#282828",
	visual_bg = "#404945",
	search_bg = "#766c34",
	normal = "#1A1528",
	border = "#554d80",
	changed = "#8CF8F7",
	text = "#CDD6F5",
	float_bg = "#181826",
	cursor_line_bg = "#29283B",
	string_fg = "#D7AF5F",
	non_text = "#9ca0b1",
	whitespace = "#444444",
	visual_selection = "#45475b",
	constant_custom = "#D19407",
	match_paren_bg = "#504945",
	diag_error = "#ff5f5f",
	diag_warn = "#ffaf00",
	diag_info = "#5fafff",
	diag_hint = "#5fffaf",
	float_sel_bg = "#45475b", -- same as visual_selection
	color_column_bg = "#313245",
	split_lines = "#5f5f5f",
	tab_fill = "#130F1E",
	qf_line_bg = "#38384C",
	diff_add_bg = "#2a332d",
	diff_change_bg = "#3a2e36",
	diff_delete_bg = "#3e2d2e",
	diff_text_bg = "#575268",
	text_muted = "#a0a0b0",
	text_subtle = "#8f8f99",
}

local retro_light = {
	bg0 = "#fbf1c7",
	bg1 = "#ebdbb2",
	bg2 = "#d5c4a1",
	bg3 = "#bdae93",
	bg4 = "#a89984",
	fg0 = "#282828",
	fg1 = "#3c3836",
	fg2 = "#504945",
	fg3 = "#665c54",
	fg4 = "#7c6f64",
	red = "#cc241d",
	green = "#98971a",
	yellow = "#d79921",
	blue = "#458588",
	purple = "#b16286",
	aqua = "#689d6a",
	orange = "#d65d0e",
	grey = "#928374",
	sign_bg = "#fbf1c7",
	visual_bg = "#eaeda3",
	search_bg = "#bdae93",
	text = "#4c4f69",
	float_bg = "#ECECF0",
	cursor_line_bg = "#e9ebf1",
	string_fg = "#40a02b",
	non_text = "#9ca0b0",
	whitespace = "#787575",
	visual_selection = "#bcc0cc",
	constant_custom = "#fe640b",
	match_paren_bg = "NONE",
	diag_error = "#cc241d",
	diag_warn = "#d79921",
	diag_info = "#458588",
	diag_hint = "#689d6a",
	float_sel_bg = "#ccd0da",
	color_column_bg = "#e6e9ef",
	split_lines = "#dce0e8",
	tab_fill = "#e6e9ef",
	qf_line_bg = "#d0baf3",
	diff_add_bg = "#d0e2d1",
	diff_change_bg = "#e0e7f5",
	diff_delete_bg = "#eac8d3",
	diff_text_bg = "#b0c7f5",
	text_muted = "#7c7f93",
	text_subtle = "#8f8f99",
}

local function apply_highlights()
	local bg = vim.o.background
	local p = (bg == "dark") and retro_dark or retro_light
	local is_transparent = vim.g.is_transparent or false

	local groups = {
		Normal = { fg = p.fg1, bg = p.bg0 },
		NormalFloat = { fg = p.fg1, bg = p.bg1 },

		CursorLine = { bg = p.bg1 },
		CursorLineNr = { fg = p.yellow, bg = p.bg1 },
		LineNr = { fg = p.bg3 },
		SignColumn = { bg = p.sign_bg },
		FoldColumn = { fg = p.grey, bg = p.sign_bg },
		VertSplit = { fg = p.bg3, bg = "NONE" },
		WinSeparator = { fg = p.bg3, bg = "NONE" },
		ColorColumn = { bg = p.bg1 },

		Visual = { bg = p.visual_bg },
		VisualNOS = { bg = p.visual_bg },
		Search = { bg = p.search_bg, fg = "NONE" },
		IncSearch = { bg = p.orange, fg = p.bg0 },

		Comment = { fg = p.grey },
		NonText = { fg = p.bg2 },
		Whitespace = { fg = p.bg2 },
		SpecialKey = { fg = p.bg2 },
		Todo = { fg = p.fg0, bg = p.bg0, bold = true },

		Constant = { fg = p.purple },
		Character = { fg = p.purple },
		Number = { fg = p.purple },
		Boolean = { fg = p.purple },
		Float = { fg = p.purple },

		Identifier = { fg = p.blue },
		Function = { fg = p.green, bold = true },
		Title = { fg = p.green, bold = true },

		Statement = { fg = p.red },
		Conditional = { fg = p.red },
		Repeat = { fg = p.red },
		Label = { fg = p.red },
		Operator = { fg = p.fg1 },
		Keyword = { fg = p.red },
		Exception = { fg = p.red },

		PreProc = { fg = p.aqua },
		Include = { fg = p.aqua },
		Define = { fg = p.aqua },
		Macro = { fg = p.aqua },
		PreCondit = { fg = p.aqua },

		Type = { fg = p.yellow },
		StorageClass = { fg = p.orange },
		Structure = { fg = p.aqua },
		Typedef = { fg = p.yellow },

		Special = { fg = p.orange },
		SpecialChar = { fg = p.red },
		Tag = { fg = p.aqua },
		Delimiter = { fg = p.orange },
		SpecialComment = { fg = p.grey },
		Debug = { fg = p.red },

		StatusLine = { fg = p.fg1, bg = p.bg4, reverse = true },
		StatusLineNC = { fg = p.bg2, bg = p.fg4, reverse = true },
		TabLine = { fg = p.fg4, bg = "#130f1e" },
		TabLineFill = { fg = p.fg4, bg = p.bg4 },
		TabLineSel = { fg = p.green, bg = p.normal },

		Pmenu = { fg = p.fg1, bg = p.bg2 },
		PmenuSel = { fg = p.bg0, bg = p.blue },
		PmenuSbar = { bg = p.bg2 },
		PmenuThumb = { bg = p.border },

		DiagnosticError = { fg = p.red },
		DiagnosticWarn = { fg = p.yellow },
		DiagnosticInfo = { fg = p.blue },
		DiagnosticHint = { fg = p.aqua },
		DiagnosticUnderlineError = { underline = true, sp = p.red },
		DiagnosticUnderlineWarn = { underline = true, sp = p.yellow },
		DiagnosticUnderlineInfo = { underline = true, sp = p.blue },
		DiagnosticUnderlineHint = { underline = true, sp = p.aqua },
	}

	if bg == "dark" then
		groups.Normal = { fg = p.text, bg = p.normal }
		groups.NormalFloat = { fg = p.text, bg = p.float_bg }
		groups.CursorLine = { bg = p.cursor_line_bg }
		groups.Function = { fg = p.green, bold = false }
		groups.Title = { fg = p.green, bold = false }
		groups.String = { fg = p.string_fg }
		groups.NonText = { fg = p.non_text }
		groups.Whitespace = { fg = p.whitespace }
		groups.Visual = { bg = p.visual_selection, fg = "NONE" }
		groups.VisualNOS = { bg = p.visual_selection, fg = "NONE" }

		groups.Constant = { fg = p.constant_custom }
		-- groups.Character = { fg = dark_constant }
		-- groups.Number = { fg = dark_constant }
		-- groups.Boolean = { fg = dark_constant }
		-- groups.Float = { fg = dark_constant }
		groups["@type.builtin"] = { link = "Type" }

		groups.Operator = { fg = p.orange }
		groups.Delimiter = { fg = p.orange }
		groups["@operator"] = { fg = p.orange }
		groups["@punctuation"] = { fg = p.orange }
		groups["@punctuation.delimiter"] = { fg = p.orange }
		groups["@punctuation.bracket"] = { fg = p.orange }
		groups["@punctuation.special"] = { fg = p.orange }

		groups.PreProc = { fg = p.aqua }
		groups.Define = { fg = p.aqua }
		groups.Macro = { fg = p.aqua }
		groups["@macro"] = { fg = p.aqua, bold = true }
		groups["@keyword.directive"] = { fg = p.aqua }

		groups.MatchParen = { bg = p.match_paren_bg, fg = "NONE", bold = true, underline = true, sp = p.fg3 }
		groups.Underlined = { fg = p.blue, underline = true, sp = p.blue }

		groups.DiagnosticError = { fg = p.diag_error }
		groups.DiagnosticWarn = { fg = p.diag_warn }
		groups.DiagnosticInfo = { fg = p.diag_info }
		groups.DiagnosticHint = { fg = p.diag_hint }
		groups.DiagnosticUnderlineError = { underline = true, sp = p.diag_error }
		groups.DiagnosticUnderlineWarn = { underline = true, sp = p.diag_warn }
		groups.DiagnosticUnderlineInfo = { underline = true, sp = p.diag_info }
		groups.DiagnosticUnderlineHint = { underline = true, sp = p.diag_hint }

		groups.Pmenu = { fg = p.text, bg = p.float_bg }
		groups.PmenuSel = { fg = p.text, bg = p.float_sel_bg }
		groups.FloatBorder = { fg = p.border, bg = p.float_bg }

		groups.SignColumn = { bg = p.normal, fg = p.text }
		groups.FoldColumn = { bg = p.normal }
		groups.CursorLineNr = { bg = p.normal, fg = p.diag_warn, bold = true }
		groups.ColorColumn = { bg = p.color_column_bg }
		groups.WinSeparator = { fg = p.border }
		groups.VertSplit = { fg = p.split_lines }
		groups.TabLineFill = { bg = p.tab_fill }
		groups.TabLineSel = { fg = p.yellow, bg = p.normal }
		groups.TabLinePomodoro = { fg = p.yellow }

		groups.QuickFixLine = { bg = p.qf_line_bg, bold = true }
		groups.Search = { bg = p.float_sel_bg, fg = "NONE" }
		groups.IncSearch = { bg = p.orange, fg = p.normal, bold = true }
		groups.CurSearch = { bg = p.yellow, fg = p.normal, bold = true }
		groups.ErrorMsg = { bg = "NONE" }
		groups.debugPC = { bg = p.visual_selection }
		groups.SnacksIndent = { fg = p.whitespace }

		groups.DiffAdd = { bg = p.diff_add_bg, fg = "NONE" }
		groups.DiffChange = { bg = p.diff_change_bg, fg = "NONE" }
		groups.DiffDelete = { bg = p.diff_delete_bg, fg = "NONE" }
		groups.DiffText = { bg = p.diff_text_bg, fg = "NONE" }

		groups["@variable"] = { fg = p.blue }
		groups["@variable.member"] = { fg = p.blue }
		groups["@property"] = { fg = p.blue }

		groups.SpellBad = { undercurl = true, sp = p.diag_error }
		groups.SpellCap = { undercurl = true, sp = p.diag_info }
		groups.SpellRare = { undercurl = true, sp = p.diag_hint }
		groups.SpellLocal = { undercurl = true, sp = p.diag_warn }

		groups.CmpItemAbbr = { fg = p.text_muted }
		groups.CmpItemAbbrMatch = { fg = p.diag_warn, bold = true }
		groups.CmpItemAbbrMatchFuzzy = { fg = p.diag_warn }
		groups.CmpItemKind = { fg = "#7fafff", bg = p.float_bg }
		groups.CmpItemMenu = { fg = p.text_subtle, bg = p.float_bg, italic = true }

		groups.BlinkCmpMenu = { fg = p.text, bg = p.float_bg }
		groups.BlinkCmpMenuBorder = { fg = p.border, bg = p.float_bg }
		groups.BlinkCmpMenuSelection = { fg = "NONE", bg = p.float_sel_bg, bold = true }
		groups.BlinkCmpLabel = { fg = p.text_muted }
		groups.BlinkCmpLabelMatch = { fg = p.diag_warn, bold = true }
		groups.BlinkCmpKind = { fg = "#7fafff", bg = p.float_bg }
		groups.BlinkCmpSource = { fg = p.text_subtle, bg = p.float_bg, italic = true }
		groups.BlinkCmpDoc = { fg = p.text, bg = p.float_bg }
		groups.BlinkCmpDocBorder = { fg = p.border, bg = p.float_bg }
		groups.BlinkCmpSignatureHelp = { fg = p.text, bg = p.float_bg }
		groups.BlinkCmpSignatureHelpBorder = { fg = p.border, bg = p.float_bg }

		if is_transparent then
			local transparent_border = p.split_lines
			groups.Normal = { fg = p.text, bg = "NONE" }
			groups.NormalFloat = { fg = p.text, bg = "NONE" }
			groups.SignColumn = { bg = "NONE" }
			groups.FoldColumn = { bg = "NONE" }
			groups.CursorLineNr = { bg = "NONE", fg = "NONE" }
			groups.FloatBorder = { fg = transparent_border, bg = "NONE" }
			groups.VertSplit = { bg = "NONE", fg = transparent_border }
			groups.Pmenu = { fg = "#d0d0d0", bg = "NONE" }
			groups.TabLine = { bg = "NONE", fg = transparent_border }
			groups.TabLineFill = { bg = "NONE", fg = "NONE" }
			groups.TabLineSel = { fg = p.yellow, bg = "NONE" }
			groups.Search = { bg = "#5f431f", fg = "NONE" }
			groups.IncSearch = { bg = "#5f431f", fg = "NONE" }
			groups.CurSearch = { bg = "#5f431f", fg = "NONE" }
			groups.SnacksIndent = { fg = p.bg2 }
			groups.CmpItemKind = { fg = "#7fafff", bg = "NONE" }
			groups.CmpItemMenu = { fg = p.text_subtle, bg = "NONE", italic = true }

			groups.BlinkCmpMenu = { fg = "#d0d0d0", bg = "NONE" }
			groups.BlinkCmpMenuBorder = { fg = transparent_border, bg = "NONE" }
			groups.BlinkCmpKind = { fg = "#7fafff", bg = "NONE" }
			groups.BlinkCmpSource = { fg = p.text_subtle, bg = "NONE", italic = true }
			groups.BlinkCmpDoc = { fg = p.text, bg = "NONE" }
			groups.BlinkCmpDocBorder = { fg = transparent_border, bg = "NONE" }
			groups.BlinkCmpSignatureHelp = { fg = p.text, bg = "NONE" }
			groups.BlinkCmpSignatureHelpBorder = { fg = transparent_border, bg = "NONE" }

			groups.DiagnosticError = { fg = p.diag_error, bold = true }
			groups.DiagnosticWarn = { fg = p.diag_warn, bold = true }
		end
	else
		groups.Normal = { fg = p.text, bg = is_transparent and "NONE" or "#eff1f5" }
		groups.NormalFloat = { fg = p.text, bg = is_transparent and "NONE" or p.float_bg }
		groups.CursorLine = { fg = "NONE", bg = p.cursor_line_bg }
		groups.CursorLineNr = { fg = "#7287fd", bg = "NONE" }
		groups.LineNr = { fg = p.visual_selection, bg = "NONE" }
		groups.Comment = { fg = p.text_muted, bg = "NONE" }
		groups.NonText = { fg = p.non_text, bg = "NONE" }
		groups.Whitespace = { fg = p.whitespace }
		groups["@type.builtin"] = { link = "Type" }

		groups.Operator = { fg = p.text }
		groups.Delimiter = { fg = p.text }
		groups["@operator"] = { fg = p.text }
		groups["@punctuation"] = { fg = p.text }
		groups["@punctuation.delimiter"] = { fg = p.text }
		groups["@punctuation.bracket"] = { fg = p.text }
		groups["@punctuation.special"] = { fg = p.text }

		groups.MatchParen = { fg = p.constant_custom, bg = "NONE", underline = true, sp = p.constant_custom }
		groups.Underlined = { fg = "#1e66f5", underline = true, sp = "#1e66f5" }

		groups.SignColumn = { fg = p.visual_selection, bg = "NONE" }
		groups.FoldColumn = { fg = p.non_text, bg = "NONE" }
		groups.FloatBorder = { fg = "#1e66f5", bg = p.float_bg }
		groups.ColorColumn = { fg = "NONE", bg = p.color_column_bg }
		groups.WinSeparator = { fg = p.split_lines, bg = "NONE" }
		groups.CursorColumn = { fg = "NONE", bg = p.color_column_bg }

		groups.Visual = { fg = "NONE", bg = p.visual_selection }
		groups.VisualNOS = { fg = "NONE", bg = p.visual_selection }
		groups.Search = { fg = p.text, bg = "#a8daf0" }
		groups.CurSearch = { fg = "NONE", bg = "#fc8fc3" }

		groups.Function = { fg = "#1e66f5", bg = "NONE" }
		groups.Title = { fg = "#1e66f5", bg = "NONE" }
		groups.String = { fg = p.string_fg, bg = "NONE" }
		groups.Keyword = { fg = "#8839ef", bg = "NONE" }
		groups.Statement = { fg = "#8839ef", bg = "NONE" }
		groups.Conditional = { fg = "#8839ef", bg = "NONE" }
		groups.Repeat = { fg = "#8839ef", bg = "NONE" }
		groups.Exception = { fg = "#8839ef", bg = "NONE" }
		groups.Include = { fg = "#8839ef", bg = "NONE" }
		groups.Macro = { fg = "#8839ef", bg = "NONE" }
		groups.Constant = { fg = p.constant_custom, bg = "NONE" }
		groups.Identifier = { fg = "#dd7878", bg = "NONE" }
		groups.Type = { fg = "#df8e1d", bg = "NONE" }
		groups.StorageClass = { fg = "#df8e1d", bg = "NONE" }
		groups.Structure = { fg = "#df8e1d", bg = "NONE" }
		groups.Special = { fg = "#ea76cb", bg = "NONE" }
		groups.PreProc = { fg = "#ea76cb", bg = "NONE" }
		groups.Character = { fg = "#179299", bg = "NONE" }
		groups.Label = { fg = "#209fb5", bg = "NONE" }
		groups["@macro"] = { fg = "#8839ef", bold = true }
		groups["@keyword.directive"] = { fg = "#8839ef" }

		groups["@variable"] = { fg = p.blue }
		groups["@variable.member"] = { fg = p.blue }
		groups["@property"] = { fg = p.blue }

		groups.DiagnosticError = { fg = p.diag_error, bold = true }
		groups.DiagnosticWarn = { fg = p.diag_warn }
		groups.DiagnosticInfo = { fg = p.diag_info }
		groups.DiagnosticHint = { fg = p.diag_hint }
		groups.DiagnosticUnderlineError = { underline = true, sp = p.diag_error }
		groups.DiagnosticUnderlineWarn = { underline = true, sp = p.diag_warn }
		groups.DiagnosticUnderlineInfo = { underline = true, sp = p.diag_info }
		groups.DiagnosticUnderlineHint = { underline = true, sp = p.diag_hint }
		groups.Error = { fg = "#d20f39", bg = "NONE" }
		groups.ErrorMsg = { fg = "#d20f39", bg = "NONE" }
		groups.WarningMsg = { fg = "#df8e1d", bg = "NONE" }

		groups.TabLine = { fg = p.non_text, bg = p.split_lines }
		groups.TabLineFill = { fg = "NONE", bg = is_transparent and "NONE" or p.tab_fill }
		groups.TabLineSel = { fg = p.text, bg = is_transparent and "NONE" or "#eff1f5" }

		groups.Pmenu = { fg = p.text_muted, bg = is_transparent and "NONE" or p.tab_fill }
		groups.PmenuSel = { fg = "NONE", bg = p.float_sel_bg }
		groups.PmenuSbar = { fg = "NONE", bg = p.float_sel_bg }
		groups.PmenuThumb = { fg = "NONE", bg = p.non_text }
		groups.PmenuExtra = { fg = p.non_text, bg = p.tab_fill }
		groups.PmenuExtraSel = { fg = p.non_text, bg = p.float_sel_bg }
		groups.PmenuMatch = { fg = p.text, bg = "NONE" }
		groups.PmenuMatchSel = { fg = "NONE", bg = "NONE" }

		groups.CmpItemAbbr = { fg = p.text_muted }
		groups.CmpItemAbbrMatch = { fg = "#1e66f5", bold = true }
		groups.CmpItemAbbrMatchFuzzy = { fg = "#1e66f5" }
		groups.CmpItemKind = { fg = "#1e66f5", bg = "NONE" }
		groups.CmpItemMenu = { fg = p.text_subtle, bg = "NONE", italic = true }

		groups.BlinkCmpMenu = { fg = p.text_muted, bg = is_transparent and "NONE" or p.tab_fill }
		groups.BlinkCmpMenuBorder = { fg = "#1e66f5", bg = is_transparent and "NONE" or p.float_bg }
		groups.BlinkCmpMenuSelection = { fg = "NONE", bg = p.float_sel_bg, bold = true }
		groups.BlinkCmpLabel = { fg = p.text_muted }
		groups.BlinkCmpLabelMatch = { fg = "#1e66f5", bold = true }
		groups.BlinkCmpKind = { fg = "#1e66f5", bg = "NONE" }
		groups.BlinkCmpSource = { fg = p.text_subtle, bg = "NONE", italic = true }
		groups.BlinkCmpDoc = { fg = p.text, bg = is_transparent and "NONE" or p.float_bg }
		groups.BlinkCmpDocBorder = { fg = "#1e66f5", bg = is_transparent and "NONE" or p.float_bg }
		groups.BlinkCmpSignatureHelp = { fg = p.text, bg = is_transparent and "NONE" or p.float_bg }
		groups.BlinkCmpSignatureHelpBorder = { fg = "#1e66f5", bg = is_transparent and "NONE" or p.float_bg }

		groups.SpellBad = { undercurl = true, sp = p.diag_error }
		groups.SpellCap = { undercurl = true, sp = p.diag_info }
		groups.SpellRare = { undercurl = true, sp = p.diag_hint }
		groups.SpellLocal = { undercurl = true, sp = p.diag_warn }

		groups.QuickFixLine = { fg = "NONE", bg = p.qf_line_bg }
		groups.DiffAdd = { fg = "NONE", bg = p.diff_add_bg }
		groups.DiffChange = { fg = "NONE", bg = p.diff_change_bg }
		groups.DiffDelete = { fg = "NONE", bg = p.diff_delete_bg }
		groups.DiffText = { fg = "NONE", bg = p.diff_text_bg }
		groups.debugPC = { fg = "NONE", bg = p.split_lines }
		groups.debugBreakpoint = { fg = p.non_text, bg = "#eff1f5" }
	end

	local target_bg = groups.Normal.bg or "NONE"

	local colors = {
		fg = "#bbc2cf",
		yellow = "#ECBE7B",
		cyan = "#008080",
		darkblue = "#081633",
		green = "#98be65",
		orange = "#FF8800",
		violet = "#a9a1e1",
		magenta = "#c678dd",
		blue = "#51afef",
		red = "#ec5f67",
		tmux = "#E9AD0C",
	}

	groups.StatusLine = { fg = colors.fg, bg = target_bg }
	groups.StatusLineNC = { fg = colors.fg, bg = target_bg }
	groups.StatusLineTerm = { fg = colors.fg, bg = target_bg }
	groups.StatusLineTermNC = { fg = colors.fg, bg = target_bg }

	groups.StatuslineDefault = { fg = colors.magenta, bg = target_bg, bold = true }
	groups.StatuslinePercentage = { fg = colors.cyan, bg = target_bg, bold = true }
	groups.StatuslineLSP = { fg = colors.yellow, bg = target_bg, bold = true }
	groups.StatuslineFill = { fg = "NONE", bg = target_bg }

	groups.StatuslineMacro = { fg = colors.red, bg = target_bg, bold = true }
	groups.StatuslineSearchCount = { fg = colors.orange, bg = target_bg, bold = true }
	groups.StatuslineSelection = { fg = colors.violet, bg = target_bg, bold = true }

	groups.StatuslineMode_n = { fg = colors.tmux, bg = target_bg, bold = true }
	groups.StatuslineMode_i = { fg = colors.green, bg = target_bg, bold = true }
	groups.StatuslineMode_v = { fg = colors.blue, bg = target_bg, bold = true }
	groups.StatuslineMode_V = { fg = colors.blue, bg = target_bg, bold = true }
	groups.StatuslineMode_vB = { fg = colors.blue, bg = target_bg, bold = true }
	groups.StatuslineMode_c = { fg = colors.magenta, bg = target_bg, bold = true }
	groups.StatuslineMode_no = { fg = colors.red, bg = target_bg, bold = true }
	groups.StatuslineMode_s = { fg = colors.orange, bg = target_bg, bold = true }
	groups.StatuslineMode_S = { fg = colors.orange, bg = target_bg, bold = true }
	groups.StatuslineMode_sB = { fg = colors.orange, bg = target_bg, bold = true }
	groups.StatuslineMode_ic = { fg = colors.yellow, bg = target_bg, bold = true }
	groups.StatuslineMode_R = { fg = colors.violet, bg = target_bg, bold = true }
	groups.StatuslineMode_Rv = { fg = colors.violet, bg = target_bg, bold = true }
	groups.StatuslineMode_cv = { fg = colors.red, bg = target_bg, bold = true }
	groups.StatuslineMode_ce = { fg = colors.red, bg = target_bg, bold = true }
	groups.StatuslineMode_r = { fg = colors.cyan, bg = target_bg, bold = true }
	groups.StatuslineMode_rm = { fg = colors.cyan, bg = target_bg, bold = true }
	groups.StatuslineMode_r_q = { fg = colors.cyan, bg = target_bg, bold = true }
	groups.StatuslineMode_bang = { fg = colors.red, bg = target_bg, bold = true }
	groups.StatuslineMode_t = { fg = colors.red, bg = target_bg, bold = true }

	for group, opts in pairs(groups) do
		hl(0, group, opts)
	end
end

apply_highlights()

return {
	apply = apply_highlights,
}

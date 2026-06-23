-- Name:         Libra.nvim
-- Description:  Yoinked from retrobox and catppuccin; Designed by Mustafa Hayati.

local hl = vim.api.nvim_set_hl

-- Reset existing highlights to prevent bleeding from previous themes
vim.cmd("hi clear")
if vim.fn.exists("syntax_on") == 1 then
	vim.cmd("syntax reset")
end
vim.g.colors_name = "libra"

-- 1. True Retrobox Palette Definitions (Upstream Base)
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
}

local function apply_highlights()
	local bg = vim.o.background
	local p = (bg == "dark") and retro_dark or retro_light
	local is_transparent = vim.g.is_transparent or false

	-- 2. Baseline Retrobox Structure
	local groups = {
		-- Normal Environment
		Normal = { fg = p.fg1, bg = p.bg0 },
		NormalFloat = { fg = p.fg1, bg = p.bg1 },

		-- UI Elements
		CursorLine = { bg = p.bg1 },
		CursorLineNr = { fg = p.yellow, bg = p.bg1 },
		LineNr = { fg = p.bg3 },
		SignColumn = { bg = p.sign_bg },
		FoldColumn = { fg = p.grey, bg = p.sign_bg },
		VertSplit = { fg = p.bg3, bg = "NONE" },
		WinSeparator = { fg = p.bg3, bg = "NONE" },
		ColorColumn = { bg = p.bg1 },

		-- Selection & Search
		Visual = { bg = p.visual_bg },
		VisualNOS = { bg = p.visual_bg },
		Search = { bg = p.search_bg, fg = "NONE" },
		IncSearch = { bg = p.orange, fg = p.bg0 },

		-- Text Elements
		Comment = { fg = p.grey },
		NonText = { fg = p.bg2 },
		Whitespace = { fg = p.bg2 },
		SpecialKey = { fg = p.bg2 },
		Todo = { fg = p.fg0, bg = p.bg0, bold = true },

		-- Syntax Highlighting
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

		-- Window Navigation / Tabs
		StatusLine = { fg = p.bg4, bg = p.fg1, reverse = true },
		StatusLineNC = { fg = p.bg2, bg = p.fg4, reverse = true },
		TabLine = { fg = p.fg4, bg = p.bg4 },
		TabLineFill = { fg = p.fg4, bg = p.bg4 },
		TabLineSel = { fg = p.green, bg = p.normal },

		-- Completion Menus
		Pmenu = { fg = p.fg1, bg = p.bg2 },
		PmenuSel = { fg = p.bg0, bg = p.blue },
		PmenuSbar = { bg = p.bg2 },
		PmenuThumb = { bg = p.border },

		-- Diagnostics
		DiagnosticError = { fg = p.red },
		DiagnosticWarn = { fg = p.yellow },
		DiagnosticInfo = { fg = p.blue },
		DiagnosticHint = { fg = p.aqua },
		DiagnosticUnderlineError = { underline = true, sp = p.red },
		DiagnosticUnderlineWarn = { underline = true, sp = p.yellow },
		DiagnosticUnderlineInfo = { underline = true, sp = p.blue },
		DiagnosticUnderlineHint = { underline = true, sp = p.aqua },
	}

	-- 3. Apply Your Precise Overrides (Takes Precedence)
	if bg == "dark" then
		-- Global Dark Base Overrides (Applied to both Opaque and Transparent Dark)
		local dark_text = "#CDD6F5"
		groups.Normal = { fg = dark_text, bg = p.normal }
		groups.NormalFloat = { fg = dark_text, bg = "#181826" }
		groups.CursorLine = { bg = "#29283B" }
		groups.Function = { fg = "#B8BB26", bold = false }
		groups.Title = { fg = "#B8BB26", bold = false }
		groups.String = { fg = "#D7AF5F" }
		groups.NonText = { fg = "#9ca0b1" }
		groups.Whitespace = { fg = "#444444" }
		groups.Visual = { bg = "#45475b", fg = "NONE" }
		groups.VisualNOS = { bg = "#45475b", fg = "NONE" }

		-- Constants, Literals, and Core Types
		local dark_constant = "#D19407"
		groups.Constant = { fg = dark_constant }
		-- groups.Character = { fg = dark_constant }
		-- groups.Number = { fg = dark_constant }
		-- groups.Boolean = { fg = dark_constant }
		-- groups.Float = { fg = dark_constant }
		groups["@type.builtin"] = { link = "Type" }

		-- Complete Punctuation & Operator Mapping for Dark Mode (Fixes white symbols)
		groups.Operator = { fg = p.orange }
		groups.Delimiter = { fg = p.orange }
		groups["@operator"] = { fg = p.orange }
		groups["@punctuation"] = { fg = p.orange }
		groups["@punctuation.delimiter"] = { fg = p.orange }
		groups["@punctuation.bracket"] = { fg = p.orange }
		groups["@punctuation.special"] = { fg = p.orange }

		-- Global Preprocessor and Macro Names (e.g., #define MAX_COUNT)
		local dark_macro = p.aqua
		groups.PreProc = { fg = dark_macro }
		groups.Define = { fg = dark_macro }
		groups.Macro = { fg = dark_macro }
		groups["@macro"] = { fg = dark_macro, bold = true }
		groups["@keyword.directive"] = { fg = dark_macro }

		-- MatchParen / Structural Marks
		groups.MatchParen = { bg = "#504945", fg = "NONE", bold = true, underline = true, sp = "#bdae93" }
		groups.Underlined = { fg = "#83a598", underline = true, sp = "#83a598" }

		-- Diagnostics & Correct Error Underline Color
		groups.DiagnosticError = { fg = "#ff5f5f" }
		groups.DiagnosticWarn = { fg = "#ffaf00" }
		groups.DiagnosticInfo = { fg = "#5fafff" }
		groups.DiagnosticHint = { fg = "#5fffaf" }
		groups.DiagnosticUnderlineError = { underline = true, sp = "#ff5f5f" }
		groups.DiagnosticUnderlineWarn = { underline = true, sp = "#ffaf00" }
		groups.DiagnosticUnderlineInfo = { underline = true, sp = "#5fafff" }
		groups.DiagnosticUnderlineHint = { underline = true, sp = "#5fffaf" }

		-- Completion / Floats
		groups.Pmenu = { fg = dark_text, bg = "#181826" }
		groups.PmenuSel = { fg = dark_text, bg = "#444444" }
		groups.FloatBorder = { fg = p.border, bg = "#181826" }

		-- Structure Layouts
		groups.SignColumn = { bg = p.normal, fg = dark_text }
		groups.FoldColumn = { bg = p.normal }
		groups.CursorLineNr = { bg = p.normal, fg = "#ffaf00", bold = true }
		groups.ColorColumn = { bg = "#313245" }
		groups.WinSeparator = { fg = p.border }
		groups.VertSplit = { fg = "#5f5f5f" }
		groups.TabLineFill = { bg = "#130F1E" }
		groups.TabLineSel = { fg = dark_text, bg = p.normal }

		-- Lists / Custom Search Highlights (#5f431f)
		groups.QuickFixLine = { bg = "#38384C", bold = true }
		groups.Search = { bg = "#2f4f75", fg = "NONE" }
		groups.IncSearch = { bg = "#fe8019", fg = p.normal, bold = true }
		groups.CurSearch = { bg = "#fabd2f", fg = p.normal, bold = true }
		groups.ErrorMsg = { bg = "NONE" }
		groups.debugPC = { bg = "#45475b" }
		groups.SnacksIndent = { fg = "#444444" }

		-- Diff Mode Handling
		groups.DiffAdd = { bg = "#2a332d", fg = "NONE" }
		groups.DiffChange = { bg = "#3a2e36", fg = "NONE" }
		groups.DiffDelete = { bg = "#3e2d2e", fg = "NONE" }
		groups.DiffText = { bg = "#575268", fg = "NONE" }

		-- Tree-sitter & LSP Semantic Token Mapping for Variables
		local dark_var_color = "#83a598"
		groups["@variable"] = { fg = dark_var_color }
		groups["@variable.member"] = { fg = dark_var_color }
		groups["@property"] = { fg = dark_var_color }

		-- Spell Checking Highlights (Dark Mode)
		groups.SpellBad = { undercurl = true, sp = "#ff5f5f" }
		groups.SpellCap = { undercurl = true, sp = "#5fafff" }
		groups.SpellRare = { undercurl = true, sp = "#5fffaf" }
		groups.SpellLocal = { undercurl = true, sp = "#ffaf00" }

		-- Cmp Menu Specifics
		groups.CmpItemAbbr = { fg = "#a0a0b0" }
		groups.CmpItemAbbrMatch = { fg = "#ffaf00", bold = true }
		groups.CmpItemAbbrMatchFuzzy = { fg = "#ffaf00" }
		groups.CmpItemKind = { fg = "#7fafff", bg = "#181826" }
		groups.CmpItemMenu = { fg = "#8f8f99", bg = "#181826", italic = true }

		-- Conditional Transparent Modifications
		if is_transparent then
			groups.Normal = { fg = dark_text, bg = "NONE" }
			groups.NormalFloat = { fg = dark_text, bg = "NONE" }
			groups.SignColumn = { bg = "NONE" }
			groups.FoldColumn = { bg = "NONE" }
			groups.CursorLineNr = { bg = "NONE", fg = "NONE" }
			groups.FloatBorder = { fg = "#5f5f5f", bg = "NONE" }
			groups.VertSplit = { bg = "NONE", fg = "#5f5f5f" }
			groups.Pmenu = { fg = "#d0d0d0", bg = "NONE" }
			groups.TabLine = { bg = "NONE", fg = "#5f5f5f" }
			groups.TabLineFill = { bg = "NONE", fg = "NONE" }
			groups.TabLineSel = { fg = dark_text, bg = "NONE" }
			groups.StatusLine = { bg = "NONE", fg = "NONE" }
			groups.StatusLineNC = { bg = "NONE", fg = "NONE" }
			groups.StatusLineTerm = { bg = "NONE", fg = "NONE" }
			groups.StatusLineTermNC = { bg = "NONE", fg = "NONE" }
			groups.Search = { bg = "#5f431f", fg = "NONE" }
			groups.IncSearch = { bg = "#5f431f", fg = "NONE" }
			groups.CurSearch = { bg = "#5f431f", fg = "NONE" }
			groups.SnacksIndent = { fg = "#504945" }
			groups.CmpItemKind = { fg = "#7fafff", bg = "NONE" }
			groups.CmpItemMenu = { fg = "#8f8f99", bg = "NONE", italic = true }

			groups.DiagnosticError = { fg = "#ff5f5f", bold = true }
			groups.DiagnosticWarn = { fg = "#ffaf00", bold = true }
		end
	else
		-- 4. Light Mode Overrides
		local light_text = "#4c4f69"
		groups.Normal = { fg = light_text, bg = is_transparent and "NONE" or "#eff1f5" }
		groups.NormalFloat = { fg = light_text, bg = is_transparent and "NONE" or "#ECECF0" }
		groups.CursorLine = { fg = "NONE", bg = "#e9ebf1" }
		groups.CursorLineNr = { fg = "#7287fd", bg = "NONE" }
		groups.LineNr = { fg = "#bcc0cc", bg = "NONE" }
		groups.Comment = { fg = "#7c7f93", bg = "NONE" }
		groups.NonText = { fg = "#9ca0b0", bg = "NONE" }
		groups.Whitespace = { fg = "#787575" }
		groups["@type.builtin"] = { link = "Type" }

		-- Complete Punctuation & Operator Mapping for Light Mode
		groups.Operator = { fg = light_text }
		groups.Delimiter = { fg = light_text }
		groups["@operator"] = { fg = light_text }
		groups["@punctuation"] = { fg = light_text }
		groups["@punctuation.delimiter"] = { fg = light_text }
		groups["@punctuation.bracket"] = { fg = light_text }
		groups["@punctuation.special"] = { fg = light_text }

		-- Fix Light Underline Colors
		groups.MatchParen = { fg = "#fe640b", bg = "NONE", underline = true, sp = "#fe640b" }
		groups.Underlined = { fg = "#1e66f5", underline = true, sp = "#1e66f5" }

		-- Structure & Layout Borders
		groups.SignColumn = { fg = "#bcc0cc", bg = "NONE" }
		groups.FoldColumn = { fg = "#9ca0b0", bg = "NONE" }
		groups.FloatBorder = { fg = "#1e66f5", bg = "#ECECF0" }
		groups.ColorColumn = { fg = "NONE", bg = "#e6e9ef" }
		groups.VertSplit = { fg = "#dce0e8", bg = "NONE" }
		groups.CursorColumn = { fg = "NONE", bg = "#e6e9ef" }

		-- Selection / Search
		groups.Visual = { fg = "NONE", bg = "#bcc0cc" }
		groups.VisualNOS = { fg = "NONE", bg = "#bcc0cc" }
		groups.Search = { fg = light_text, bg = "#a8daf0" }
		groups.CurSearch = { fg = "NONE", bg = "#fc8fc3" }

		-- Core Syntax Structure
		groups.Function = { fg = "#1e66f5", bg = "NONE" }
		groups.Title = { fg = "#1e66f5", bg = "NONE" }
		groups.String = { fg = "#40a02b", bg = "NONE" }
		groups.Keyword = { fg = "#8839ef", bg = "NONE" }
		groups.Statement = { fg = "#8839ef", bg = "NONE" }
		groups.Conditional = { fg = "#8839ef", bg = "NONE" }
		groups.Repeat = { fg = "#8839ef", bg = "NONE" }
		groups.Exception = { fg = "#8839ef", bg = "NONE" }
		groups.Include = { fg = "#8839ef", bg = "NONE" }
		groups.Macro = { fg = "#8839ef", bg = "NONE" }
		groups.Constant = { fg = "#fe640b", bg = "NONE" }
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

		-- Tree-sitter & LSP Semantic Token Mapping for Variables
		local light_var_color = "#458588"
		groups["@variable"] = { fg = light_var_color }
		groups["@variable.member"] = { fg = light_var_color }
		groups["@property"] = { fg = light_var_color }

		-- Diagnostics & Light Underline Colors
		groups.DiagnosticError = { fg = "#cc241d", bold = true }
		groups.DiagnosticWarn = { fg = "#d79921" }
		groups.DiagnosticInfo = { fg = "#458588" }
		groups.DiagnosticHint = { fg = "#689d6a" }
		groups.DiagnosticUnderlineError = { underline = true, sp = "#cc241d" }
		groups.DiagnosticUnderlineWarn = { underline = true, sp = "#d79921" }
		groups.DiagnosticUnderlineInfo = { underline = true, sp = "#458588" }
		groups.DiagnosticUnderlineHint = { underline = true, sp = "#689d6a" }
		groups.Error = { fg = "#d20f39", bg = "NONE" }
		groups.ErrorMsg = { fg = "#d20f39", bg = "NONE" }
		groups.WarningMsg = { fg = "#df8e1d", bg = "NONE" }

		-- Navigation Layout UI
		groups.StatusLine = { fg = light_text, bg = is_transparent and "NONE" or "#dce0e8" }
		groups.StatusLineNC = { fg = "#bcc0cc", bg = is_transparent and "NONE" or "#e6e9ef" }
		groups.TabLine = { fg = "#9ca0b0", bg = "#dce0e8" }
		groups.TabLineFill = { fg = "NONE", bg = is_transparent and "NONE" or "#e6e9ef" }
		groups.TabLineSel = { fg = light_text, bg = is_transparent and "NONE" or "#eff1f5" }

		-- Popup Completion Menus
		groups.Pmenu = { fg = "#7c7f93", bg = is_transparent and "NONE" or "#e6e9ef" }
		groups.PmenuSel = { fg = "NONE", bg = "#ccd0da" }
		groups.PmenuSbar = { fg = "NONE", bg = "#ccd0da" }
		groups.PmenuThumb = { fg = "NONE", bg = "#9ca0b0" }
		groups.PmenuExtra = { fg = "#9ca0b0", bg = "#e6e9ef" }
		groups.PmenuExtraSel = { fg = "#9ca0b0", bg = "#ccd0da" }
		groups.PmenuMatch = { fg = light_text, bg = "NONE" }
		groups.PmenuMatchSel = { fg = "NONE", bg = "NONE" }

		-- Autocomplete Engine Targets
		groups.CmpItemAbbr = { fg = "#7c7f93" }
		groups.CmpItemAbbrMatch = { fg = "#1e66f5", bold = true }
		groups.CmpItemAbbrMatchFuzzy = { fg = "#1e66f5" }
		groups.CmpItemKind = { fg = "#1e66f5", bg = "NONE" }
		groups.CmpItemMenu = { fg = "#8f8f99", bg = "NONE", italic = true }

		-- Spell Checking Highlights (Light Mode)
		groups.SpellBad = { undercurl = true, sp = "#cc241d" }
		groups.SpellCap = { undercurl = true, sp = "#458588" }
		groups.SpellRare = { undercurl = true, sp = "#689d6a" }
		groups.SpellLocal = { undercurl = true, sp = "#d79921" }

		-- Misc Targets
		groups.QuickFixLine = { fg = "NONE", bg = "#d0baf3" }
		groups.DiffAdd = { fg = "NONE", bg = "#d0e2d1" }
		groups.DiffChange = { fg = "NONE", bg = "#e0e7f5" }
		groups.DiffDelete = { fg = "NONE", bg = "#eac8d3" }
		groups.DiffText = { fg = "NONE", bg = "#b0c7f5" }
		groups.debugPC = { fg = "NONE", bg = "#dce0e8" }
		groups.debugBreakpoint = { fg = "#9ca0b0", bg = "#eff1f5" }
	end

	-- Apply the exact compiled colors
	for group, opts in pairs(groups) do
		hl(0, group, opts)
	end
end

apply_highlights()

return {
	apply = apply_highlights,
}

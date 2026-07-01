local function my_tab_label(tabnr)
	local buflist = vim.fn.tabpagebuflist(tabnr)
	local winnr = vim.fn.tabpagewinnr(tabnr)
	if not buflist or #buflist == 0 then
		return "[No Name]"
	end

	-- OPTIMIZED: Use getbufvar instead of vim.bo to prevent object allocation thrashing.
	-- This checks if ANY active window buffer in this tab is modified.
	local is_tab_modified = false
	for _, b in ipairs(buflist) do
		if vim.fn.getbufvar(b, "&modified") == 1 then
			is_tab_modified = true
			break
		end
	end

	local bufnr = buflist[winnr] or buflist[1]
	local win_id = vim.fn.win_getid(winnr, tabnr)
	if win_id and win_id > 0 then
		local win_config = vim.api.nvim_win_get_config(win_id)
		if win_config.relative and win_config.relative ~= "" then
			for _, b in ipairs(buflist) do
				-- OPTIMIZED: getbufvar used here as well for buftype
				if vim.fn.getbufvar(b, "&buftype") == "" and vim.fn.bufname(b) ~= "" then
					bufnr = b
					break
				end
			end
		end
	end

	local bufname = vim.fn.bufname(bufnr)
	local mod_suffix = is_tab_modified and " ●" or ""

	if bufname == "" then
		return "[No Name]" .. mod_suffix
	end

	-- OPTIMIZED: getbufvar used here instead of vim.bo
	local buftype = vim.fn.getbufvar(bufnr, "&buftype")
	if buftype == "terminal" then
		return " Terminal" .. mod_suffix
	elseif buftype == "help" then
		return "󰘥 Help" .. mod_suffix
	end

	return vim.fn.fnamemodify(bufname, ":t") .. mod_suffix
end

-- 1. Check executables EXACTLY ONCE on startup
local has_pomodoro = vim.fn.executable("gnome-pomodoro") == 1 and vim.fn.executable("gdbus") == 1
local pomodoro_text = ""

-- 2. Only run the background monitoring loops if the tools exist
if has_pomodoro then
	local state = nil
	local duration = 0
	local elapsed = 0
	local paused = false

	local function update_display()
		local remaining = math.max(duration - elapsed, 0)
		local minutes = math.floor(remaining / 60)
		local seconds = math.floor(remaining % 60)

		local icon = ""
		if paused then
			icon = ""
		elseif state == "pomodoro" then
			icon = ""
		elseif state == "short-break" or state == "long-break" then
			icon = " "
		end

		if state then
			pomodoro_text = string.format("%s %02d:%02d", icon, minutes, seconds)
		else
			pomodoro_text = icon
		end
	end

	local function refresh_ui()
		update_display()
		vim.schedule(function()
			vim.cmd("redrawtabline") -- Triggers tabline redraw only when the timer actually changes
		end)
	end

	local function parse_dbus_output(output)
		if not output then
			return
		end
		local changed = false

		local new_elapsed = output:match("'Elapsed': <([%d%.]+)>")
		if new_elapsed then
			elapsed = tonumber(new_elapsed)
			changed = true
		end

		local new_paused = output:match("'IsPaused': <(%a+)>")
		if new_paused then
			paused = (new_paused == "true")
			changed = true
		end

		local new_state = output:match("'State': <'([^']+)'>")
		if new_state then
			state = new_state
			changed = true
		end

		local new_duration = output:match("'StateDuration': <([%d%.]+)>")
		if new_duration then
			duration = tonumber(new_duration)
			changed = true
		end

		if changed then
			refresh_ui()
		end
	end

	local monitor = vim.system({
		"gdbus",
		"monitor",
		"--session",
		"--dest",
		"org.gnome.Pomodoro",
		"--object-path",
		"/org/gnome/Pomodoro",
	}, {
		stdout = function(_, data)
			if data then
				parse_dbus_output(data)
			end
		end,
	})

	vim.system({
		"gdbus",
		"call",
		"--session",
		"--dest",
		"org.gnome.Pomodoro",
		"--object-path",
		"/org/gnome/Pomodoro",
		"--method",
		"org.freedesktop.DBus.Properties.GetAll",
		"org.gnome.Pomodoro",
	}, { text = true }, function(obj)
		if obj.code == 0 and obj.stdout then
			parse_dbus_output(obj.stdout)
		end
	end)

	vim.api.nvim_create_autocmd("VimLeavePre", {
		callback = function()
			if monitor then
				monitor:kill()
			end
		end,
	})
end

-- 3. The Tabline function stays blazing fast because it only reads a pre-calculated string
function _G.MyTabLine()
	local s = ""
	local total_tabs = vim.fn.tabpagenr("$")
	local current_tab = vim.fn.tabpagenr()

	for i = 1, total_tabs do
		if i == current_tab then
			s = s .. "%#TabLineSel#"
		else
			s = s .. "%#TabLine#"
		end
		s = s .. "%" .. i .. "T"
		s = s .. "▍ " .. i .. ". " .. my_tab_label(i) .. " "
	end

	s = s .. "%#TabLineFill#%T"

	-- No extra logic here; just checking a variable. Blazing fast.
	if pomodoro_text ~= "" then
		s = s .. "%="
		-- Apply the custom highlight group here, then clear it back to TabLineFill
		s = s .. "%#TabLinePomodoro# " .. pomodoro_text .. " %#TabLineFill#"
	end

	return s
end

vim.o.tabline = "%!v:lua.MyTabLine()"
vim.o.showtabline = 2 -- show tabline even if only one tab is open

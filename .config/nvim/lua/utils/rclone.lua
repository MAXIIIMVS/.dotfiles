-- Rclone integration for Neovim - Google Drive sync utilities

local M = {}

-- Configuration
local GDRIVE_REMOTE = "gdrive" -- Change this if your remote has a different name
local DEFAULT_DEST = "" -- Empty string means root directory

-- Helper: Escape Lua pattern characters
local function escape_pattern(str)
	return (str:gsub("([%(%)%.%%%+%-%*%?%[%]%^%$])", "%%%1"))
end

-- Helper: Validate and expand file path
local function validate_file_path(file_path, should_exist)
	if not file_path or file_path == "" then
		return nil, "File path is required"
	end

	-- Crucial: Expand special Neovim symbols like "%" before using them
	local expanded = vim.fn.expand(file_path)

	-- Normalize path to absolute path
	expanded = vim.fn.fnamemodify(expanded, ":p")

	-- Check for invalid filenames
	local filename = vim.fn.fnamemodify(expanded, ":t")
	if filename == "" or filename == "." or filename == ".." then
		return nil, "Invalid filename"
	end

	if should_exist then
		if vim.fn.filereadable(expanded) == 0 then
			return nil, string.format("Cannot read file: %s (check permissions or existence)", expanded)
		end
	else
		-- For destination path, ensure parent directory exists
		local parent_dir = vim.fn.fnamemodify(expanded, ":h")

		if parent_dir ~= "" and parent_dir ~= "." then
			if vim.fn.isdirectory(parent_dir) == 0 then
				return nil, string.format("Parent directory does not exist: %s", parent_dir)
			end
		end
	end

	return expanded, nil
end

-- Helper: Format remote destination safely (removes double slashes)
local function format_destination(destination)
	local dest = destination or DEFAULT_DEST

	-- Trim whitespace
	dest = dest:match("^%s*(.-)%s*$") or ""

	-- Root
	if dest == "" or dest == "/" then
		return GDRIVE_REMOTE .. ":"
	end

	-- Remove leading/trailing slashes
	dest = dest:gsub("^/", ""):gsub("/$", "")

	return string.format("%s:%s", GDRIVE_REMOTE, dest)
end

-- Helper: Run rclone synchronously
local function run_rclone_sync(args)
	local result = vim.fn.system(args)
	local code = vim.v.shell_error
	return code, result
end

-- Helper: Notify
local function notify(msg, level, title, timeout)
	vim.notify(msg, level or vim.log.levels.INFO, {
		title = title or "rclone",
		timeout = timeout or 3000,
	})
end

-- Copy local file to Google Drive
function M.copy_to_gdrive(file_path, destination)
	local local_path, err = validate_file_path(file_path, true)

	if not local_path then
		notify(err, vim.log.levels.ERROR, "rclone copy", 5000)
		return false
	end

	local dest_path = format_destination(destination)
	local filename = vim.fn.fnamemodify(local_path, ":t")

	local args = {
		"rclone",
		"copyto", -- Using copyto handles explicit file destinations better than copy
		local_path,
		dest_path .. "/" .. filename,
		"--stats=0",
		"--log-level=ERROR",
		"--retries=3",
		"--low-level-retries=5",
		"--update",
	}

	vim.fn.jobstart(args, {
		detach = false,
		on_exit = function(_, code, _)
			if code == 0 then
				local dest_display = destination or "/"
				notify(
					string.format("✓ Copied '%s' to %s:%s", filename, GDRIVE_REMOTE, dest_display),
					vim.log.levels.INFO
				)
			else
				notify(
					string.format("✗ Failed to copy '%s' (exit code: %d)", filename, code),
					vim.log.levels.ERROR,
					"rclone copy",
					5000
				)
			end
		end,
	})

	return true
end

-- Pull file from Google Drive
function M.pull_from_gdrive(file_path, source)
	local local_path, err = validate_file_path(file_path, false)

	if not local_path then
		notify(err, vim.log.levels.ERROR, "rclone pull", 5000)
		return false
	end

	local filename = vim.fn.fnamemodify(local_path, ":t")
	local remote_dir = format_destination(source)
	local remote_file = remote_dir .. "/" .. filename

	-- Check if remote file exists
	local check_args = {
		"rclone",
		"lsf",
		remote_dir,
		"--files-only",
	}

	local check_code, check_stdout = run_rclone_sync(check_args)

	if check_code ~= 0 then
		notify(string.format("✗ Failed to access %s", remote_dir), vim.log.levels.ERROR, "rclone pull", 5000)
		return false
	end

	local escaped_filename = escape_pattern(filename)
	local file_found = false

	for line in check_stdout:gmatch("[^\r\n]+") do
		if line:match("^" .. escaped_filename .. "$") then
			file_found = true
			break
		end
	end

	if not file_found then
		notify(
			string.format("✗ File '%s' not found in %s", filename, remote_dir),
			vim.log.levels.ERROR,
			"rclone pull",
			5000
		)
		return false
	end

	-- Backup local file synchronously
	local backup_path = nil
	if vim.fn.filereadable(local_path) == 1 then
		backup_path = local_path .. ".backup"
		local backup_result = vim.fn.system({ "cp", local_path, backup_path })

		if vim.v.shell_error ~= 0 then
			notify(
				string.format("✗ Failed to create backup: %s", backup_result),
				vim.log.levels.ERROR,
				"rclone pull",
				5000
			)
			return false
		end
	end

	local args = {
		"rclone",
		"copyto",
		remote_file,
		local_path,
		"--stats=0",
		"--log-level=ERROR",
		"--retries=3",
		"--low-level-retries=5",
	}

	vim.fn.jobstart(args, {
		detach = false,
		on_exit = function(_, code, _)
			if code == 0 then
				notify(string.format("✓ Pulled '%s' from %s", filename, remote_dir))

				-- Reload file if currently open
				local bufnr = vim.fn.bufnr(local_path, false)
				if bufnr ~= -1 and vim.api.nvim_buf_is_loaded(bufnr) then
					vim.schedule(function()
						vim.cmd("checktime " .. vim.fn.fnameescape(local_path))
						notify("File reloaded in buffer", vim.log.levels.INFO)
					end)
				end

				-- Remove backup after success
				if backup_path and vim.fn.filereadable(backup_path) == 1 then
					vim.fn.delete(backup_path)
				end
			else
				notify(
					string.format("✗ Failed to pull '%s' (exit code: %d)", filename, code),
					vim.log.levels.ERROR,
					"rclone pull",
					5000
				)

				-- Restore backup
				if backup_path and vim.fn.filereadable(backup_path) == 1 then
					local restore_result = vim.fn.system({ "cp", backup_path, local_path })
					if vim.v.shell_error == 0 then
						notify("Local file restored from backup", vim.log.levels.WARN)
					else
						notify(
							string.format("✗ Failed to restore backup: %s", restore_result),
							vim.log.levels.ERROR,
							"rclone pull",
							5000
						)
					end
				end
			end
		end,
	})

	return true
end

-- User Commands Definition
if vim.api.nvim_create_user_command then
	vim.api.nvim_create_user_command("RcloneCopy", function(opts)
		local args = opts.fargs
		if #args < 1 or #args > 2 then
			notify("Usage: RcloneCopy <file_path> [destination]", vim.log.levels.ERROR)
			return
		end
		M.copy_to_gdrive(args[1], args[2] or "/")
	end, {
		nargs = "+",
		complete = "file",
		desc = "Copy file to Google Drive",
	})

	vim.api.nvim_create_user_command("RclonePull", function(opts)
		local args = opts.fargs
		if #args < 1 or #args > 2 then
			notify("Usage: RclonePull <file_path> [source_folder]", vim.log.levels.ERROR)
			return
		end
		M.pull_from_gdrive(args[1], args[2] or "/")
	end, {
		nargs = "+",
		complete = "file",
		desc = "Pull file from Google Drive",
	})
else
	-- Safe legacy fallback string interpolation for older Neovim versions
	vim.api.nvim_command("command! -nargs=+ RcloneCopy lua require('utils.rclone').copy_to_gdrive(<f-args>)")
	vim.api.nvim_command("command! -nargs=+ RclonePull lua require('utils.rclone').pull_from_gdrive(<f-args>)")
end

return M

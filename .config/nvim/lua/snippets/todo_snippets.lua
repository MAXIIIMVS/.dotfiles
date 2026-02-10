local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node

-- NOTE: name is optional and it's used for adding a name to the comment
local function comment_tag(tag, name)
	if name == nil then
		name = ""
	end
	return f(function()
		local cs = vim.bo.commentstring
		if cs == "" then
			return tag .. ": " .. name
		end
		return cs:gsub("%%s", tag .. ": " .. name)
	end)
end

return {
	s("todo", { comment_tag("TODO"), i(1) }),
	s("note", { comment_tag("NOTE"), i(1) }),
	s("warn", { comment_tag("WARN"), i(1) }),
	s("warning", { comment_tag("WARNING"), i(1) }),
	s("perf", { comment_tag("PERF"), i(1) }),
	s("fix", { comment_tag("FIX"), i(1) }),
	s("hack", { comment_tag("HACK"), i(1) }),
	s("test", { comment_tag("TEST"), i(1) }),
	s("review", { comment_tag("REVIEW"), i(1) }),
	s("debug", { comment_tag("DEBUG"), i(1) }),
	s("deprecated", { comment_tag("DEPRECATED"), i(1) }),
	s("important", { comment_tag("IMPORTANT"), i(1) }),
	s("idea", { comment_tag("IDEA"), i(1) }),

	s("mtodo", { comment_tag("TODO", "<Mustafa> "), i(1) }),
	s("mnote", { comment_tag("NOTE", "<Mustafa> "), i(1) }),
	s("mwarn", { comment_tag("WARN", "<Mustafa> "), i(1) }),
	s("mwarning", { comment_tag("WARNING", "<Mustafa> "), i(1) }),
	s("mperf", { comment_tag("PERF", "<Mustafa> "), i(1) }),
	s("mfix", { comment_tag("FIX", "<Mustafa> "), i(1) }),
	s("mhack", { comment_tag("HACK", "<Mustafa> "), i(1) }),
	s("mtest", { comment_tag("TEST", "<Mustafa> "), i(1) }),
	s("mreview", { comment_tag("REVIEW", "<Mustafa> "), i(1) }),
	s("mdebug", { comment_tag("DEBUG", "<Mustafa> "), i(1) }),
	s("mdeprecated", { comment_tag("DEPRECATED", "<Mustafa> "), i(1) }),
	s("mimportant", { comment_tag("IMPORTANT", "<Mustafa> "), i(1) }),
	s("midea", { comment_tag("IDEA", "<Mustafa> "), i(1) }),
}

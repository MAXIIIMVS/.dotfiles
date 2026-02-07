local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

local block_comment = s("/*", {
	t("/* "),
	i(1),
	t(" */"),
})

local doc_comment = s("/**", {
	t({ "/**", " * " }),
	i(1),
	t({ "", " */" }),
})

return {
	block_comment,
	doc_comment,
}

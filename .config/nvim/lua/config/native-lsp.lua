-- Checkout: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md

local M = {}

function M.setup(on_attach, capabilities)
	local mason_registry = require("mason-registry")
	local ensure_installed = {
		-- "asmfmt",
		-- "awk-language-server",
		-- "bash-language-server",
		-- "buf",
		"clangd",
		-- "codelldb",
		-- "cpptools",
		-- "csharp-language-server",
		-- "csharpier",
		"css-lsp",
		"delve",
		-- "deno",
		-- "docker-compose-language-service",
		-- "dockerfile-language-server",
		"emmet-ls",
		"eslint_d",
		-- "glsl_analyzer",
		-- "go-debug-adapter",
		"gopls",
		-- "html-lsp",
		-- "htmx-lsp",
		-- "intelephense",
		-- "jinja-lsp",
		-- "js-debug-adapter",
		-- "json-lsp",
		-- "lemminx",
		-- "lua-language-server",
		-- "neocmakelsp",
		-- "node-debug2-adapter",
		-- "phpactor",
		"prettierd",
		-- "prisma-language-server",
		"pyright",
		"rust-analyzer",
		"shfmt",
		"stylua",
		-- "templ",
		-- "texlab",
		"typescript-language-server",
		-- "vim-language-server",
		-- "yaml-language-server",
	}

	local servers = {
		awk_ls = {
			cmd = { "awk-language-server" },
			filetypes = { "awk" },
		},
		bashls = {
			cmd = { "bash-language-server", "start" },
			filetypes = { "bash", "sh" },
		},
		bufls = {
			cmd = { "bufls", "serve" },
			filetypes = { "proto" },
		},
		clangd = {
			cmd = { "clangd" },
			filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
			-- root_dir = <disabled by vim-rooter>
		},
		csharp_ls = {
			cmd = { "csharp-ls" },
			filetypes = { "cs" },
		},
		cssls = {
			cmd = { "vscode-css-language-server", "--stdio" },
			filetypes = { "css", "scss", "less" },
		},
		docker_compose_language_service = {
			cmd = { "docker-compose-langserver", "--stdio" },
			filetypes = { "yaml.docker-compose" },
		},
		dockerls = {
			cmd = { "docker-langserver", "--stdio" },
			filetypes = { "dockerfile" },
		},
		emmet_ls = {
			cmd = { "emmet-ls", "--stdio" },
			filetypes = {
				"astro",
				"css",
				"eruby",
				"html",
				"htmlangular",
				"htmldjango",
				"javascriptreact",
				"jsx",
				"less",
				"pug",
				"sass",
				"scss",
				"svelte",
				"templ",
				"tsx",
				"typescriptreact",
				"vue",
			},
		},
		glsl_analyzer = {
			cmd = { "glsl_analyzer" },
			filetypes = { "glsl", "vert", "tesc", "tese", "frag", "geom", "comp" },
		},
		gopls = {
			cmd = { "gopls", "serve" },
			filetypes = { "go", "gomod", "gowork", "gotmpl" },
			-- root_dir = <disabled by vim-rooter>
			settings = {
				gopls = {
					-- codelens = {
					-- 	generate = true, -- show codelens for `go generate`
					-- 	gc_details = true, -- show gc annotations
					-- 	test = true, -- show codelens for running tests
					-- 	tidy = true, -- show codelens for `go mod tidy`
					-- 	upgrade_dependency = true, -- show codelens for upgrading deps
					-- 	vendor = true, -- show codelens for `go mod vendor`
					-- },
					templateExtensions = { "tpl", "yaml", "tmpl", "tmpl.html" },
					experimentalPostfixCompletions = true,
					gofumpt = true,
					usePlaceholders = true,
					analyses = {
						nilness = true,
						unusedresult = true,
						unusedparams = true,
						unusedwrite = true,
						useany = true,
						unreachable = true,
					},
					hints = {
						assignVariableTypes = true,
						compositeLiteralFields = true,
						compositeLiteralTypes = true,
						constantValues = true,
						functionTypeParameters = true,
						parameterNames = true,
						rangeVariableTypes = true,
					},
					staticcheck = true,
				},
			},
		},
		html = {
			cmd = { "vscode-html-language-server", "--stdio" },
			filetypes = { "html", "htmldjango", "gohtml", "tmpl.html", "template" },
		},
		htmx = {
			cmd = { "htmx-lsp" },
			filetypes = {
				"aspnetcorerazor",
				"astro",
				"astro-markdown",
				"blade",
				"clojure",
				"django-html",
				"htmldjango",
				"edge",
				"eelixir",
				"elixir",
				"ejs",
				"erb",
				"eruby",
				"gohtml",
				"gohtmltmpl",
				"haml",
				"handlebars",
				"hbs",
				"html",
				"htmlangular",
				"html-eex",
				"heex",
				"jade",
				"leaf",
				"liquid",
				"markdown",
				"mdx",
				"mustache",
				"njk",
				"nunjucks",
				"php",
				"razor",
				"slim",
				"twig",
				"javascript",
				"javascriptreact",
				"reason",
				"rescript",
				"typescript",
				"typescriptreact",
				"vue",
				"svelte",
				"templ",
			},
		},
		intelephense = {
			cmd = { "intelephense", "--stdio" },
			filetypes = { "php" },
		},
		jinja_lsp = {
			cmd = { "jinja-lsp" },
			filetypes = { "jinja" },
			name = "jinja_lsp",
		},
		jsonls = {
			cmd = { "vscode-json-language-server", "--stdio" },
			filetypes = { "json", "jsonc" },
		},
		lemminx = {
			cmd = { "lemminx" },
			filetypes = { "xml", "xsd", "xsl", "xslt", "svg" },
		},
		-- lua_ls = {
		-- 	cmd = { "lua-language-server" },
		-- 	filetypes = { "lua" },
		-- },
		neocmake = {
			cmd = { "neocmakelsp", "--stdio" },
			filetypes = { "cmake" },
			-- root_dir = <disabled by vim-rooter>
		},
		-- omnisharp = {
		-- 	cmd = {
		-- 		vim.fn.executable("OmniSharp") == 1 and "OmniSharp" or "omnisharp",
		-- 		"-z", -- https://github.com/OmniSharp/omnisharp-vscode/pull/4300
		-- 		"--hostPID",
		-- 		tostring(vim.fn.getpid()),
		-- 		"DotNet:enablePackageRestore=false",
		-- 		"--encoding",
		-- 		"utf-8",
		-- 		"--languageserver",
		-- 	},
		-- 	filetypes = { "cs", "vb" },
		-- },
		phpactor = {
			cmd = { "phpactor", "language-server" },
			filetypes = { "php" },
		},
		prismals = {
			cmd = { "prisma-language-server", "--stdio" },
			filetypes = { "prisma" },
		},
		pyright = {
			cmd = { "pyright-langserver", "--stdio" },
			filetypes = { "python" },
			settings = {
				python = {
					analysis = {
						autoSearchPaths = true,
						diagnosticMode = "workspace",
						useLibraryCodeForTypes = true,
					},
				},
			},
		},
		rust_analyzer = {
			cmd = { "rust-analyzer" },
			filetypes = { "rust" },
			settings = {
				["rust-analyzer"] = {
					assist = {
						importGranularity = "module",
						importPrefix = "self",
					},
					cargo = { loadOutDirsFromCheck = true },
					procMacro = { enable = true },
					checkOnSave = { command = "clippy" },
				},
			},
		},
		templ = {
			cmd = { "templ", "lsp" },
			filetypes = { "templ" },
		},
		texlab = {
			cmd = { "texlab" },
			filetypes = { "tex", "plaintex", "bib" },
			settings = {
				texlab = {
					bibtexFormatter = "texlab",
					build = {
						args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
						executable = "latexmk",
						forwardSearchAfter = false,
						onSave = false,
					},
					chktex = {
						onEdit = false,
						onOpenAndSave = false,
					},
					diagnosticsDelay = 300,
					formatterLineLength = 80,
					forwardSearch = {
						args = {},
					},
					latexFormatter = "latexindent",
					latexindent = {
						modifyLineBreaks = false,
					},
				},
			},
		},
		ts_ls = {
			cmd = { "typescript-language-server", "--stdio" },
			filetypes = {
				"typescript.tsx",
				"javascript.jsx",
				"javascript",
				"typescript",
				"javascriptreact",
				"typescriptreact",
				"jsx",
				"tsx",
				"vue",
			},
			-- root_dir = <disabled by vim-rooter>
		},
		vimls = {
			cmd = { "vim-language-server", "--stdio" },
			filetypes = { "vim" },
		},
		yamlls = {
			cmd = { "yaml-language-server", "--stdio" },
			filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab", "yaml.helm-values" },
		},
	}

	for server, config in pairs(servers) do
		config.on_attach = function(client, bufnr)
			if server == "awk_ls" or server == "bashls" or server == "ts_ls" then
				client.server_capabilities.documentFormattingProvider = false
			end
			on_attach(client, bufnr)
		end
		config.capabilities = capabilities
		vim.lsp.config(server, config)
		vim.lsp.enable(server)
		table.insert(ensure_installed, server)
	end

	-- Automatically install missing servers with Mason
	for _, server in ipairs(ensure_installed) do
		if not mason_registry.is_installed(server) and mason_registry.has_package(server) then
			mason_registry.get_package(server):install()
		end
	end
end

return M

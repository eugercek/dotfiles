-- Teach lua_ls about the Neovim runtime.
vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			codeLens = {
				enable = false,
			},
			completion = {
				callSnippet = "Replace",
			},
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
})

-- Keep Go analysis useful without forcing gofumpt semantics.
vim.lsp.config("gopls", {
	settings = {
		gopls = {
			codelenses = {
				test = true,
			},
			gofumpt = false,
			staticcheck = true,
		},
	},
})

vim.lsp.config("bashls", {
	settings = {
		bashIde = {
			shellcheckPath = "shellcheck",
		},
	},
})

vim.lsp.config("yamlls", {
	settings = {
		yaml = {
			schemas = {
				kubernetes = "*.{yml,yaml}",
			},
		},
	},
})

-- Buffer-local LSP navigation keys.
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(event)
		nmap("gd", vim.lsp.buf.definition, { buffer = event.buf, desc = "Goto definition" })
		nmap("gD", vim.lsp.buf.declaration, { buffer = event.buf, desc = "Goto declaration" })
	end,
})

vim.lsp.codelens.enable()

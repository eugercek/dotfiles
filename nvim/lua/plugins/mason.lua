vim.pack.add({
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
})

require("mason").setup()

-- Install and auto-enable language servers we actually use.
require("mason-lspconfig").setup({
	ensure_installed = {
		"bashls",
		"clangd",
		"gopls",
		"lua_ls",
		"marksman",
		"pyright",
		"terraformls",
		"yamlls",
	},
	automatic_enable = true,
})

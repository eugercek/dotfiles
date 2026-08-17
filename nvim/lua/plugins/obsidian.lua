vim.pack.add({
	{ src = "https://github.com/obsidian-nvim/obsidian.nvim", version = vim.version.range("*") },
})

require("obsidian").setup({
	legacy_commands = false, -- use the new :Obsidian <sub> command
	workspaces = {
		{ name = "personal", path = "~/Desktop/Obsidian Vault" },
	},
	-- render-markdown.nvim already draws everything, so let it, not obsidian.
	ui = { enable = false },
	picker = { name = "telescope.nvim" },
	-- completion rides on the obsidian LSP; blink already has an lsp source
	footer = { enabled = false },
})

-- Notes (<leader>n). nn (find note) lives in telescope.lua, don't touch it.
nmap("<leader>nc", "<cmd>Obsidian new<cr>", { desc = "New note" })
nmap("<leader>ns", "<cmd>Obsidian search<cr>", { desc = "Search vault" })
nmap("<leader>nt", "<cmd>Obsidian tags<cr>", { desc = "Tags" })
nmap("<leader>nd", "<cmd>Obsidian today<cr>", { desc = "Daily note" })
nmap("<leader>nb", "<cmd>Obsidian backlinks<cr>", { desc = "Backlinks" })
nmap("<leader>nr", "<cmd>Obsidian rename<cr>", { desc = "Rename note" })

vim.pack.add({
	{ src = "https://github.com/folke/which-key.nvim" },
})

local wk = require("which-key")

wk.setup({
	delay = 300,
	preset = "modern",
})

wk.add({
	{ "<leader>b", group = "Buffer" },
	{ "<leader>c", group = "Code" },
	{ "<leader>f", group = "File" },
	{ "<leader>g", group = "Git" },
	{ "<leader>h", group = "Help" },
	{ "<leader>j", group = "Jump" },
	{ "<leader>o", group = "Open" },
	{ "<leader>q", group = "Quit" },
	{ "<leader>s", group = "Search" },
	{ "<leader>t", group = "Toggle" },
	{ "<leader>w", group = "Window" },
})

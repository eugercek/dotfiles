vim.pack.add({
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/folke/todo-comments.nvim" },
})

require("todo-comments").setup({
	highlight = {
		comments_only = false,
	},
	keywords = {
		-- I use these in markdown notes
		WRONG = { icon = " ", color = "error", alt = { "BAD", "INCORRECT" } },
		OK = { icon = " ", color = "ok", alt = { "CORRECT", "RIGHT" } },
		IMPORTANT = { icon = " ", color = "important", alt = { "KEY", "CRITICAL" } },
		DONE = { icon = " ", color = "ok", alt = { "FINISHED", "COMPLETE" } },
	},
	colors = {
		error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
		ok = { "DiagnosticOk", "String", "#10B981" },
		important = { "Statement", "Keyword", "#A855F7" },
	},
})

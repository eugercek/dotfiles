vim.pack.add({
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/folke/todo-comments.nvim" },
})

require("todo-comments").setup({
	highlight = {
		comments_only = false,
		-- solid badge for the keyword, rest of the line stays normal comment color.
		-- default was after = "fg" which painted the text DiagnosticHint = #D3D3D3, invisible
		keyword = "wide_bg",
		after = "",
	},
	keywords = {
		NOTE = { icon = " ", color = "info", alt = { "INFO", "TIP" } },
		-- I use these in markdown notes
		WRONG = { icon = " ", color = "error", alt = { "BAD", "INCORRECT" } },
		OK = { icon = " ", color = "ok", alt = { "CORRECT", "RIGHT" } },
		IMPORTANT = { icon = " ", color = "important", alt = { "KEY", "CRITICAL" } },
		DONE = { icon = " ", color = "ok", alt = { "FINISHED", "COMPLETE" } },
	},
	-- hex only, no highlight group fallbacks: lunaperche/retrobox both ship
	-- pastel Diagnostic* colors (lightgreen, lightblue, lightgrey) that wash out
	colors = {
		error = { "#DC2626" },
		warning = { "#D97706" },
		info = { "#0284C7" },
		hint = { "#0891B2" },
		default = { "#7C3AED" },
		test = { "#DB2777" },
		ok = { "#059669" },
		important = { "#7C3AED" },
	},
})

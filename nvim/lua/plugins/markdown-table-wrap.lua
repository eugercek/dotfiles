vim.pack.add({
	{ src = "https://github.com/ice345/markdown-table-wrap.nvim" },
})

-- Tables are the one thing render-markdown can't wrap: a long cell breaks the
-- whole source row and the borders stop lining up. This one parses the table
-- and wraps inside each cell instead. render-markdown's pipe_table is off.
require("markdown-table-wrap").setup({
	-- inline = render on top of the source buffer. The default "reader" mode
	-- throws you into a separate protected buffer, don't want that.
	preview_mode = "inline",
	inline_mode = "replace",
	-- markdown buffers set wrap=true for prose (see autocmds), so only drop wrap
	-- while the cursor is inside a table. "always" would unwrap the whole window.
	inline_wrap_scope = "cursor",
	highlight_preset = "auto", -- picks tokyonight/catppuccin/etc, falls back to plain hl groups
})

nmap("<leader>tt", "<cmd>MarkdownTableToggleInline<cr>", { desc = "Toggle table wrap" })

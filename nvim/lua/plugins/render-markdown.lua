vim.pack.add({
	"https://github.com/MeanderingProgrammer/render-markdown.nvim",
})

require("render-markdown").setup({
	render_modes = true,
	code = { enabled = false },
	-- markdown-table-wrap.nvim draws tables now, it wraps long cells
	pipe_table = { enabled = false },
})

nmap("<leader>tm", "<cmd>RenderMarkdown toggle<cr>", { desc = "Toggle render-markdown" })

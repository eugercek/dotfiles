vim.pack.add({
	"https://github.com/MeanderingProgrammer/render-markdown.nvim",
})

require("render-markdown").setup({
	render_modes = true,
	code = { enabled = false },
	-- a lone `-` under a list item is a valid setext h2 underline, which makes
	-- the parent line flash as a heading while typing nested bullets
	heading = { setext = false },
})

nmap("<leader>tm", "<cmd>RenderMarkdown toggle<cr>", { desc = "Toggle render-markdown" })

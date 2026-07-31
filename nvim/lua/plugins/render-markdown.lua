vim.pack.add({
	"https://github.com/MeanderingProgrammer/render-markdown.nvim",
})

require("render-markdown").setup({
	render_modes = true,
	-- paragraph = { left_margin = 0.5 },
	code = {
		sign = false,
		width = "block",
		left_pad = 1,
		right_pad = 1,
	},
})

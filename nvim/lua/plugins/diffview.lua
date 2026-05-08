vim.pack.add({
	{ src = "https://github.com/dlyongemallo/diffview.nvim" },
})

require("diffview").setup({
	enhanced_diff_hl = true,
	use_icons = vim.g.have_nerd_font,
	keymaps = {
		view = {
			{ "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } },
		},
		file_panel = {
			{ "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } },
		},
		file_history_panel = {
			{ "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } },
		},
	},
	view = {
		default = {
			layout = "diff2_horizontal",
		},
		file_history = {
			layout = "diff2_horizontal",
		},
		merge_tool = {
			layout = "diff3_horizontal",
		},
	},
	file_panel = {
		listing_style = "tree",
		tree_options = {
			flatten_dirs = false,
			folder_statuses = "only_folded",
		},
		win_config = {
			position = "left",
			width = 42,
		},
	},
	file_history_panel = {
		win_config = {
			position = "bottom",
			height = 16,
		},
	},
})

nmap("<leader>gd", "<cmd>DiffviewOpen<cr>", { desc = "Review changes" })
nmap("<leader>gD", "<cmd>DiffviewFileHistory %<cr>", { desc = "File history" })
nmap("<leader>gO", "<cmd>DiffviewFileHistory<cr>", { desc = "Repo history" })
nmap("<leader>gQ", "<cmd>DiffviewClose<cr>", { desc = "Close review" })
nmap("<leader>gv", "<cmd>DiffviewOpen --staged<cr>", { desc = "Review staged" })

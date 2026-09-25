vim.pack.add({
	{ src = "https://github.com/dlyongemallo/diffview-plus.nvim" },
})

local actions = require("diffview.actions")

-- File panel side, flipped at runtime by <leader>p (win_config is re-read on every open)
local panel_bottom = false
local function toggle_panel_side()
	panel_bottom = not panel_bottom
	actions.toggle_files()
	actions.toggle_files()
end

require("diffview").setup({
	enhanced_diff_hl = true,
	clean_up_buffers = true,
	persist_selections = { enabled = true },
	use_icons = vim.g.have_nerd_font,
	keymaps = {
		view = {
			{ "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } },
			{ "n", "<leader>r", actions.cycle_layout, { desc = "Rotate layout" } },
			{ "n", "<leader>p", toggle_panel_side, { desc = "Move file panel left / bottom" } },
		},
		file_panel = {
			{ "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } },
			{ "n", "<leader>r", actions.cycle_layout, { desc = "Rotate layout" } },
			{ "n", "<leader>p", toggle_panel_side, { desc = "Move file panel left / bottom" } },
		},
		file_history_panel = {
			{ "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } },
			{ "n", "<leader>r", actions.cycle_layout, { desc = "Rotate layout" } },
		},
	},
	view = {
		one_sided_layout = "raw",
		inline = { style = "overleaf", fold_unchanged = true },
		cycle_layouts = {
			default = { "diff2_horizontal", "diff1_inline", "diff2_vertical" },
		},
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
		show_branch_name = true,
		tree_options = {
			flatten_dirs = false,
			folder_statuses = "only_folded",
		},
		win_config = function()
			return panel_bottom and { position = "bottom", height = 16 } or { position = "left", width = 42 }
		end,
	},
	file_history_panel = {
		win_config = {
			position = "bottom",
			height = 16,
		},
	},
})

nmap("<leader>gd", "<cmd>DiffviewOpen<cr>", { desc = "Review changes" })
nmap("<leader>gf", "<cmd>DiffviewFileHistory %<cr>", { desc = "File history" })
nmap("<leader>gO", "<cmd>DiffviewFileHistory<cr>", { desc = "Repo history" })
nmap("<leader>gP", "<cmd>DiffviewFileHistory % --pin-local<cr>", { desc = "File history vs working tree" })
nmap("<leader>gD", "<cmd>DiffviewOpen -uno<cr>", { desc = "Review changes (no untracked)" })
nmap("<leader>gv", "<cmd>DiffviewOpen --staged<cr>", { desc = "Review staged" })
nmap("<leader>gm", "<cmd>DiffviewOpen origin/master... --imply-local<cr>", { desc = "Review branch changes" })

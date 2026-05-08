vim.pack.add({
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/MunifTanjim/nui.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/nvim-neo-tree/neo-tree.nvim" },
})

local utils = require("config.utils")

local function open_diffview_file_history(state)
	local node = state.tree:get_node()
	if not node or not node.path then
		return
	end

	vim.cmd("DiffviewFileHistory " .. vim.fn.fnameescape(node.path))
end

require("neo-tree").setup({
	close_if_last_window = true,
	enable_git_status = true,
	popup_border_style = "rounded",
	filesystem = {
		hijack_netrw_behavior = "disabled",
		filtered_items = {
			visible = true,
			hide_dotfiles = false,
			hide_gitignored = false,
		},
		follow_current_file = {
			enabled = true,
		},
		use_libuv_file_watcher = true,
		window = {
			mappings = {
				["gD"] = {
					open_diffview_file_history,
					desc = "Diffview file history",
				},
				["gp"] = {
					function(state)
						local node = state.tree:get_node()
						utils.live_grep_directory(node.path)
					end,
					desc = "Ripgrep directory",
				},
			},
		},
	},
	git_status = {
		window = {
			mappings = {
				["gD"] = {
					open_diffview_file_history,
					desc = "Diffview file history",
				},
			},
		},
	},
	window = {
		width = 30,
		mappings = {
			["<space>"] = "none",
		},
	},
})

nmap("<leader>of", "<cmd>Neotree toggle reveal filesystem left<cr>", { desc = "File explorer" })
nmap("<leader>og", "<cmd>Neotree toggle git_status left<cr>", { desc = "Git status tree" })

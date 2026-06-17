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
	sources = {
		"filesystem",
		-- "buffers",
		"git_status",
		"document_symbols",
	},
	document_symbols = {
		follow_cursor = true,
	},
	filesystem = {
		hijack_netrw_behavior = "disabled",
		filtered_items = {
			visible = false, -- press H in the tree to reveal hidden items
			hide_dotfiles = false,
			hide_gitignored = true,
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
			["<tab>"] = "toggle_node",
			-- Disable neo-tree's default bare `z` (close_all_nodes); its nowait fires
			-- instantly and swallows the second key, so z-prefixed combos never match.
			["z"] = "none",
			["za"] = "toggle_node",
			["zo"] = "toggle_node",
			["zc"] = "toggle_node",
			["zR"] = "expand_all_nodes",
			["zM"] = "close_all_nodes",
		},
	},
})

nmap("<leader>of", "<cmd>Neotree toggle reveal filesystem left<cr>", { desc = "File explorer" })
nmap(
	"<leader>oF",
	"<cmd>Neotree focus reveal filesystem left<cr>H",
	{ remap = true, desc = "File explorer (toggle hidden)" }
)
nmap("<leader>og", "<cmd>Neotree toggle git_status left<cr>", { desc = "Git status tree" })
nmap("<leader>os", "<cmd>Neotree toggle document_symbols left<cr>", { desc = "LSP symbols tree" })

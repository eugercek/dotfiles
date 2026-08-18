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
		renderers = {
			-- drop the right-aligned "String"/kind label, keep just icon + name
			symbol = {
				{ "indent", with_expanders = true },
				{ "kind_icon", default = "?" },
				{ "container", content = {
					{ "name", zindex = 10 },
				} },
			},
		},
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

-- Does: opened(neo-tree) ? close(neo-tree) : run(open_cmd)
local function neotree_open(open_cmd)
	return function()
		for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
			if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "neo-tree" then
				vim.cmd("Neotree close")
				return
			end
		end
		vim.cmd(open_cmd)
	end
end

nmap("<leader>of", neotree_open("Neotree reveal filesystem left"), { desc = "File explorer" })
nmap("<leader>og", neotree_open("Neotree git_status left"), { desc = "Git status tree" })
nmap("<leader>os", neotree_open("Neotree document_symbols left"), { desc = "LSP symbols tree" })

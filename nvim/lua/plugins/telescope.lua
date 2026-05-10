vim.pack.add({
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope-ui-select.nvim" },
})

local telescope = require("telescope")
local actions = require("telescope.actions")
local builtin = require("telescope.builtin")

telescope.setup({
	defaults = {
		-- Top-prompt horizontal layout feels closest to a command palette.
		layout_strategy = "horizontal",
		sorting_strategy = "ascending",
		layout_config = {
			prompt_position = "top",
			width = 0.92,
			height = 0.88,
			horizontal = {
				preview_width = 0.55,
			},
		},
		mappings = {
			i = {
				-- Close the picker immediately instead of dropping into Telescope normal mode.
				["<Esc>"] = actions.close,
				-- Keep picker navigation on home-row-friendly keys.
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
			},
		},
	},
	extensions = {
		["ui-select"] = require("telescope.themes").get_dropdown(),
	},
})

-- Extensions are optional; load them when present.
pcall(telescope.load_extension, "fzf")
pcall(telescope.load_extension, "ui-select")

nmap("<leader><leader>", "<cmd>Telescope find_files<cr>", { desc = "Find file" })
nmap("<leader>ff", "<cmd>Telescope find_files hidden=true no_ignore=true<cr>", { desc = "Find all files" })

nmap("<leader>,", "<cmd>Telescope buffers<cr>", { desc = "Switch buffer" })
nmap("<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Recent files" })

nmap("<leader>gC", "<cmd>Telescope git_bcommits<cr>", { desc = "Buffer commits" })
nmap("<leader>gc", "<cmd>Telescope git_commits<cr>", { desc = "Repo commits" })
nmap("<leader>gf", "<cmd>Telescope git_files<cr>", { desc = "Git files" })
nmap("<leader>gj", "<cmd>Telescope git_branches<cr>", { desc = "Branches" })
nmap("<leader>gs", "<cmd>Telescope git_status<cr>", { desc = "Dirty files (git)" })

nmap("<leader>hf", "<cmd>Telescope help_tags<cr>", { desc = "Help tags" })
nmap("<leader>hk", "<cmd>Telescope keymaps<cr>", { desc = "Describe key" })
nmap("<leader>hv", "<cmd>Telescope highlights<cr>", { desc = "Highlight groups" })

nmap("<leader>jl", "<cmd>Telescope current_buffer_fuzzy_find<cr>", { desc = "Jump line" })

nmap("<leader>ss", "<cmd>Telescope current_buffer_fuzzy_find<cr>", { desc = "Search buffer" })
nmap("<leader>sp", "<cmd>Telescope live_grep<cr>", { desc = "Ripgrep" })

-- To deal with AI slop documentations :(
nmap("<leader>sP", function()
	builtin.live_grep({
		additional_args = function()
			return { "--glob", "!*.md" }
		end,
	})
end, { desc = "Ripgrep no markdown" })
nmap("<leader>sd", "<cmd>Telescope diagnostics<cr>", { desc = "Search diagnostics" })
nmap("<leader>si", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Document symbols" })
nmap("<leader>sf", "<cmd>Telescope find_files<cr>", { desc = "Search files" })

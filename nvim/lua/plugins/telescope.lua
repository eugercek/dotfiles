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
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		},
		["ui-select"] = require("telescope.themes").get_dropdown(),
	},
})

-- fzf-native ships C that vim.pack won't build for us, so compile it on install/update.
vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local d = ev.data
		if d.spec and d.spec.name == "telescope-fzf-native.nvim" and d.kind ~= "delete" then
			vim.system({ "make" }, { cwd = d.path }):wait()
		end
	end,
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

nmap("<leader>hf", "<cmd>Telescope help_tags<cr>", { desc = "Help tags" })
nmap("<leader>hk", "<cmd>Telescope keymaps<cr>", { desc = "Describe key" })
nmap("<leader>hv", "<cmd>Telescope highlights<cr>", { desc = "Highlight groups" })

-- Browse markdown notes in the Obsidian vault, most-recently-modified first.
nmap("<leader>nn", function()
	local vault = vim.fn.expand("$HOME/Desktop/Obsidian Vault")
	local files = vim.fn.systemlist({ "rg", "--files", "--glob", "*.md", vault })
	table.sort(files, function(a, b)
		return vim.fn.getftime(a) > vim.fn.getftime(b)
	end)

	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local make_entry = require("telescope.make_entry")

	pickers
		.new({}, {
			prompt_title = "Obsidian Notes (recent)",
			finder = finders.new_table({
				results = files,
				entry_maker = make_entry.gen_from_file({ cwd = vault }),
			}),
			previewer = conf.file_previewer({}),
			sorter = conf.file_sorter({}),
		})
		:find()
end, { desc = "Find note" })

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
nmap("<leader>sI", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", { desc = "Workspace symbols" })
nmap("<leader>sf", "<cmd>Telescope find_files<cr>", { desc = "Search files" })

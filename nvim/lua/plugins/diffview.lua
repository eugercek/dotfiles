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
	enhanced_diff_hl = false,
	-- Remove unnecessary info it's like netrw banner
	show_help_hints = false,
	show_root_path = false,
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
		inline = { style = "unified", deletion_highlight = "full_width", fold_unchanged = true },
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
		show_branch_name = false,
		tree_options = {
			flatten_dirs = false,
			folder_statuses = "only_folded",
		},
		win_config = function()
			local c = panel_bottom and { position = "bottom", height = math.min(16, math.floor(vim.o.lines / 3)) }
				or { position = "left", width = 42 }
			c.win_opts = { statusline = "%{%v:lua.DiffviewStatusline()%}" }
			return c
		end,
	},
	file_history_panel = {
		win_config = {
			position = "bottom",
			height = 16,
			win_opts = { statusline = "%{%v:lua.DiffviewStatusline()%}" },
		},
	},
})

-- tmux split narrows nvim: side-by-side + left panel turns into confetti.
-- wide: diff2 + panel left | narrow: inline + panel bottom | tiny or short: inline, panel hidden
local function open(args)
	local cols, lines = vim.o.columns, vim.o.lines
	require("diffview.config").get_config().view.default.layout = cols < 140 and "diff1_inline" or "diff2_horizontal"
	panel_bottom = cols < 140
	vim.cmd("DiffviewOpen " .. args)
	if cols < 80 or lines < 40 then
		actions.toggle_files()
	end
end

nmap("<leader>gd", function()
	open("")
end, { desc = "Review changes" })
nmap("<leader>gf", "<cmd>DiffviewFileHistory %<cr>", { desc = "File history" })
nmap("<leader>gO", "<cmd>DiffviewFileHistory<cr>", { desc = "Repo history" })
nmap("<leader>gP", "<cmd>DiffviewFileHistory % --pin-local<cr>", { desc = "File history vs working tree" })
nmap("<leader>gD", function()
	open("-uno")
end, { desc = "Review changes (no untracked)" })
nmap("<leader>gv", function()
	open("--staged")
end, { desc = "Review staged" })
nmap("<leader>gm", function()
	open("origin/master... --imply-local")
end, { desc = "Review branch changes" })

function DiffviewStatusline()
	local view = require("diffview.lib").get_current_view()
	if not view or not view.panel then
		return ""
	end
	local a = view.panel.adapter
	-- get_branch_name() shells out to git, not allowed (textlock) and too slow in a statusline. Read HEAD instead.
	local head = (vim.fn.readfile(a.ctx.dir .. "/HEAD")[1] or ""):match("refs/heads/(.+)") or "detached"
	local parts = { vim.fn.fnamemodify(a.ctx.toplevel, ":~"), head }
	local n, add, del = 0, 0, 0
	for _, kind in ipairs({ "conflicting", "working", "staged" }) do
		for _, f in ipairs(view.panel.files and view.panel.files[kind] or {}) do
			n, add, del = n + 1, add + (f.stats and f.stats.additions or 0), del + (f.stats and f.stats.deletions or 0)
		end
	end
	if n > 0 then
		parts[#parts + 1] = string.format("%d files  %%#DiffAdd#+%d%%* %%#DiffDelete#-%d%%*", n, add, del)
	end
	return " " .. table.concat(parts, "  ")
end

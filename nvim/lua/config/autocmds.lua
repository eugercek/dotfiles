local group = vim.api.nvim_create_augroup("eugercek", { clear = true })

-- Briefly highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
	group = group,
	callback = function()
		vim.hl.on_yank({ timeout = 120 })
	end,
})

-- Writing-oriented buffers should wrap (spell off by default; toggle with <leader>ts)
vim.api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = { "markdown", "text", "gitcommit" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spelllang = { "tr", "en_us" }
		-- ,` wraps word under cursor in backticks, ,u uppercases it.
		-- treats foo-bar as word
		vim.keymap.set("o", "<Plug>(dash-word)", function()
			local isk = vim.bo.iskeyword
			vim.bo.iskeyword = isk .. ",-"
			vim.cmd("normal! viw")
			vim.bo.iskeyword = isk
		end, { buffer = true })
		vim.keymap.set(
			"n",
			"<localleader>`",
			"sa<Plug>(dash-word)`",
			{ buffer = true, remap = true, desc = "Wrap word in backticks" }
		)
		vim.keymap.set(
			"x",
			"<localleader>`",
			"sa`",
			{ buffer = true, remap = true, desc = "Wrap selection in backticks" }
		)
		vim.keymap.set(
			"n",
			"<localleader>u",
			"gU<Plug>(dash-word)",
			{ buffer = true, remap = true, desc = "Uppercase word" }
		)
		-- mini.surround: 8 is ** (shift-8 twice), so sd8 / sr*8 work too
		vim.b.minisurround_config = {
			custom_surroundings = { ["8"] = { input = { "%*%*().-()%*%*" }, output = { left = "**", right = "**" } } },
		}
		-- ,b / ,i on word, or on selection in visual
		vim.keymap.set(
			"n",
			"<localleader>b",
			"sa<Plug>(dash-word)8",
			{ buffer = true, remap = true, desc = "Bold word" }
		)
		vim.keymap.set("x", "<localleader>b", "sa8", { buffer = true, remap = true, desc = "Bold selection" })
		vim.keymap.set(
			"n",
			"<localleader>i",
			"sa<Plug>(dash-word)*",
			{ buffer = true, remap = true, desc = "Italic word" }
		)
		vim.keymap.set("x", "<localleader>i", "sa*", { buffer = true, remap = true, desc = "Italic selection" })
	end,
})

-- Go uses real tabs, unlike the global default
vim.api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = { "go" },
	callback = function()
		vim.opt_local.expandtab = false
		vim.opt_local.tabstop = 4
		vim.opt_local.shiftwidth = 4
		vim.opt_local.softtabstop = 4
	end,
})

-- Reload files changed outside of Neovim during tmux/agent workflows
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "TermClose", "TermLeave" }, {
	group = group,
	callback = function()
		-- skip q: window, checktime errors there
		if vim.bo.buftype ~= "nofile" and vim.fn.getcmdwintype() == "" then
			vim.cmd("checktime")
		end
	end,
})

-- Restore cursor to its last position when reopening a file.
vim.api.nvim_create_autocmd("BufReadPost", {
	group = group,
	command = [[silent! normal! g`"zv]],
})

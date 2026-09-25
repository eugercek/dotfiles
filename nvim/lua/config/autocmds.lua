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
		-- ,` wraps word under cursor in backticks, ,u uppercases it. - counts as part of the word
		local function on_word(keys)
			return function()
				local isk = vim.bo.iskeyword
				vim.bo.iskeyword = isk .. ",-"
				vim.cmd("normal! " .. keys)
				vim.bo.iskeyword = isk
			end
		end
		vim.keymap.set("n", "<localleader>`", on_word('ciw`\18"`'), { buffer = true, desc = "Wrap word in backticks" })
		vim.keymap.set("n", "<localleader>u", on_word("gUiw"), { buffer = true, desc = "Uppercase word" })
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

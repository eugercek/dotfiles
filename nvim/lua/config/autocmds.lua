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
		if vim.bo.buftype ~= "nofile" then
			vim.cmd("checktime")
		end
	end,
})

-- Restore cursor to its last position when reopening a file.
vim.api.nvim_create_autocmd("BufReadPost", {
	group = group,
	command = [[silent! normal! g`"zv]],
})

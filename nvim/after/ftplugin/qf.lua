-- Remove qf entries in [first, last] (1-based) and keep the cursor in place
local function remove(first, last)
	local items = vim.fn.getqflist()
	for _ = first, last do
		table.remove(items, first)
	end
	vim.fn.setqflist({}, "r", { items = items })
	vim.api.nvim_win_set_cursor(0, { math.max(1, math.min(first, #items)), 0 })
end

vim.keymap.set("n", "dd", function()
	remove(vim.fn.line("."), vim.fn.line(".") + vim.v.count1 - 1)
end, { buffer = true, desc = "Delete qf entry" })

vim.keymap.set("x", "d", function()
	local a, b = vim.fn.line("v"), vim.fn.line(".")
	vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "n", false)
	remove(math.min(a, b), math.max(a, b))
end, { buffer = true, desc = "Delete qf entries" })

-- Sort by filename, then line number
vim.api.nvim_buf_create_user_command(0, "Qsort", function()
	local items = vim.fn.getqflist()
	table.sort(items, function(x, y)
		local fx, fy = vim.fn.bufname(x.bufnr), vim.fn.bufname(y.bufnr)
		if fx ~= fy then
			return fx < fy
		end
		return x.lnum < y.lnum
	end)
	vim.fn.setqflist({}, "r", { items = items })
end, {})
vim.keymap.set("n", "<localleader>s", "<cmd>Qsort<cr>", { buffer = true, desc = "Sort qf by file/line" })

local ss = require("smart-splits")

nmap("<leader>wv", "<C-w>v", { desc = "Vertical split" })
nmap("<leader>ws", "<C-w>s", { desc = "Horizontal split" })
nmap("<leader>wd", "<C-w>c", { desc = "Delete window" })
nmap("<leader>ww", "<C-w>w", { desc = "Next window" })
map("<leader>wh", ss.move_cursor_left, { desc = "Window left" })
nmap("<leader>wj", ss.move_cursor_down, { desc = "Window down" })
nmap("<leader>wk", ss.move_cursor_up, { desc = "Window up" })
nmap("<leader>wl", ss.move_cursor_right, { desc = "Window right" })
nmap("<leader>w=", "<C-w>=", { desc = "Balance windows" })
nmap("<leader>w>", ss.resize_right, { desc = "Increase Width" })
nmap("<leader>w<", ss.resize_left, { desc = "Decrease Width" })

local maximized = false
nmap("<leader>wm", function()
	if maximized then
		vim.cmd("wincmd =")
	else
		vim.cmd("wincmd _ | wincmd |")
	end
	maximized = not maximized
end, { desc = "Maximize window" })

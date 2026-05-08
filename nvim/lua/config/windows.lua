nmap("<leader>wv", "<C-w>v", { desc = "Vertical split" })
nmap("<leader>ws", "<C-w>s", { desc = "Horizontal split" })
nmap("<leader>wd", "<C-w>c", { desc = "Delete window" })
nmap("<leader>ww", "<C-w>w", { desc = "Next window" })
nmap("<leader>wh", "<C-w>h", { desc = "Window left" })
nmap("<leader>wj", "<C-w>j", { desc = "Window down" })
nmap("<leader>wk", "<C-w>k", { desc = "Window up" })
nmap("<leader>wl", "<C-w>l", { desc = "Window right" })
nmap("<leader>w=", "<C-w>=", { desc = "Balance windows" })
nmap("<leader>w>", "<C-w>>", { desc = "Increase Width" })
nmap("<leader>w<", "<C-w><", { desc = "Decrease Width" })

local maximized = false
nmap("<leader>wm", function()
	if maximized then
		vim.cmd("wincmd =")
	else
		vim.cmd("wincmd _ | wincmd |")
	end
	maximized = not maximized
end, { desc = "Maximize window" })

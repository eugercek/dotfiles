local ss = require("smart-splits")

nmap("<leader>wv", "<C-w>v", { desc = "Vertical split" })
nmap("<leader>ws", "<C-w>s", { desc = "Horizontal split" })
nmap("<leader>wd", "<C-w>c", { desc = "Delete window" })
nmap("<leader>ww", "<C-w>w", { desc = "Next window" })
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

-- tab names: tabline shows t:name if set, else the file name. clear with :unlet t:name
local fn = vim.fn
function _G.MyTabline()
	local s = ""
	for i = 1, fn.tabpagenr("$") do
		local file = fn.fnamemodify(fn.bufname(fn.tabpagebuflist(i)[fn.tabpagewinnr(i)]), ":t")
		s = s .. (i == fn.tabpagenr() and "%#TabLineSel# " or "%#TabLine# ") .. fn.gettabvar(i, "name", file) .. " "
	end
	return s .. "%#TabLineFill#"
end
vim.o.tabline = "%!v:lua.MyTabline()"
nmap("<leader>wr", ":let t:name = ''<Left>", { desc = "Rename tab" })

-- terminal resize (tmux split, font change) only shrinks the last window, equalize instead
vim.api.nvim_create_autocmd("VimResized", {
	desc = "Balance windows on terminal resize",
	callback = function()
		vim.cmd(maximized and "wincmd _ | wincmd |" or "wincmd =")
	end,
})

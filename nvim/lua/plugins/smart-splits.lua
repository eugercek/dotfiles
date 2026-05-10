vim.pack.add({
	{ src = "https://github.com/mrjones2014/smart-splits.nvim" },
})

local ss = require("smart-splits")
ss.setup({ at_edge = "stop" })

nmap("<M-h>", ss.move_cursor_left, { desc = "Window left (tmux-aware)" })
nmap("<M-j>", ss.move_cursor_down, { desc = "Window down (tmux-aware)" })
nmap("<M-k>", ss.move_cursor_up, { desc = "Window up (tmux-aware)" })
nmap("<M-l>", ss.move_cursor_right, { desc = "Window right (tmux-aware)" })

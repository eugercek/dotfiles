vim.pack.add({
	{ src = "https://github.com/mrjones2014/smart-splits.nvim" },
	-- v3 core ships no backends, tmux lives in its own plugin now
	{ src = "https://github.com/smart-splits-nvim/backend-tmux" },
})

local ss = require("smart-splits")
-- backend sets @pane-is-vim on the tmux pane, my is_vim check in .tmux.conf still does its own thing
ss.setup({
	mux = { backend = "smart-splits-backend-tmux" },
	move = { at_edge = "stop" },
})

vim.keymap.set({ "n", "i", "t" }, "<M-h>", ss.move_cursor_left, { desc = "Window left (tmux-aware)" })
vim.keymap.set({ "n", "i", "t" }, "<M-j>", ss.move_cursor_down, { desc = "Window down (tmux-aware)" })
vim.keymap.set({ "n", "i", "t" }, "<M-k>", ss.move_cursor_up, { desc = "Window up (tmux-aware)" })
vim.keymap.set({ "n", "i", "t" }, "<M-l>", ss.move_cursor_right, { desc = "Window right (tmux-aware)" })

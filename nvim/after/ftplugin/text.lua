vim.opt_local.spell = true
-- word count at the far right of the default statusline
vim.opt_local.statusline = vim.go.statusline .. " %{wordcount().words}w"

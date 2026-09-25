vim.pack.add({
	{ src = "https://github.com/echasnovski/mini-git" },
})

-- Only used for committing: nvim can't be git's editor itself (no --remote-wait yet),
-- mini.git makes :Git commit open the message in this nvim (:wq commits, :q! aborts)
require("mini.git").setup()

nmap("<leader>gc", "<cmd>Git commit --verbose<cr>", { desc = "Commit" })

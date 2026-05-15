vim.pack.add({
	{ src = "https://github.com/linrongbin16/gitlinker.nvim" },
})

require("gitlinker").setup()

vim.keymap.set({ "n", "x" }, "<leader>gy", "<cmd>GitLink<cr>", { desc = "Copy GitHub link" })

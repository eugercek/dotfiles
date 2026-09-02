vim.pack.add({
	{ src = "https://github.com/jbyuki/venn.nvim" },
})

-- venn.nvim: draw ASCII diagrams (boxes, arrows, lines) with box-drawing chars.
-- Toggle draw-mode with <leader>v, then:
--   HJKL          -> draw a line/arrow in that direction
--   visual + f    -> draw a box around the selection
-- Toggle off again with <leader>v to restore normal HJKL.
function _G.Toggle_venn()
	local venn_enabled = vim.inspect(vim.b.venn_enabled)
	if venn_enabled == "nil" then
		vim.b.venn_enabled = true
		vim.cmd([[setlocal ve=all]]) -- virtualedit: move cursor anywhere
		local opts = { noremap = true, buffer = 0 }
		vim.keymap.set("n", "H", "<C-v>h:VBox<CR>", opts)
		vim.keymap.set("n", "J", "<C-v>j:VBox<CR>", opts)
		vim.keymap.set("n", "K", "<C-v>k:VBox<CR>", opts)
		vim.keymap.set("n", "L", "<C-v>l:VBox<CR>", opts)
		vim.keymap.set("v", "f", ":VBox<CR>", opts)
		vim.notify("venn: draw mode ON", vim.log.levels.INFO)
	else
		vim.cmd([[setlocal ve=]])
		vim.cmd([[mapclear <buffer>]])
		vim.b.venn_enabled = nil
		vim.notify("venn: draw mode OFF", vim.log.levels.INFO)
	end
end

nmap("<leader>v", "<Cmd>lua Toggle_venn()<CR>", { desc = "Toggle venn ASCII draw mode" })

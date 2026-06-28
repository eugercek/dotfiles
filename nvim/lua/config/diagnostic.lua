-- Diagnostic display: signs in the gutter, details in floats.
vim.diagnostic.config({
	virtual_text = false,
	underline = true,
	severity_sort = true,
	float = {
		border = "rounded",
		source = "if_many",
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "E",
			[vim.diagnostic.severity.WARN] = "W",
			[vim.diagnostic.severity.INFO] = "I",
			[vim.diagnostic.severity.HINT] = "H",
		},
	},
})

nmap("<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostics" })
nmap("[d", function()
	vim.diagnostic.jump({ count = -1 })
end, { desc = "Previous diagnostic" })
nmap("]d", function()
	vim.diagnostic.jump({ count = 1 })
end, { desc = "Next diagnostic" })

nmap("<leader>cd", vim.diagnostic.setloclist, { desc = "Buffer diagnostics" })

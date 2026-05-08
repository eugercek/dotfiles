vim.pack.add({
	{ src = "https://github.com/stevearc/conform.nvim" },
})

require("conform").setup({
	format_on_save = function(bufnr)
		if vim.bo[bufnr].filetype == "yaml" then
			return
		end

		return {
			timeout_ms = 500,
			lsp_format = "fallback",
		}
	end,
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "isort", "black" },
		rust = { "rustfmt", lsp_format = "fallback" },
		javascript = { "prettierd", "prettier", stop_after_first = true },
		go = { "goimports" },
	},
})

vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave" }, {
	callback = function(args)
		local buf = args.buf or vim.api.nvim_get_current_buf()

		if vim.fn.mode() ~= "n" or vim.bo[buf].buftype ~= "" or vim.api.nvim_buf_get_name(buf) == "" then
			return
		end

		if vim.bo[buf].filetype == "yaml" then
			return
		end

		vim.defer_fn(function()
			if vim.api.nvim_buf_is_valid(buf) then
				require("conform").format({ bufnr = buf, lsp_format = "fallback" })
			end
		end, 100)
	end,
})

nmap("<leader>cf", function()
	require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Format buffer" })

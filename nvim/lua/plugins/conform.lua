vim.pack.add({
	{ src = "https://github.com/stevearc/conform.nvim" },
})

-- Postgres is formatted by src/tools/pgindent/pgindent (run manually before
-- commit), not by clang-format/LSP. Auto-formatting C/Perl files inside the
-- postgres tree mangles the BSD-indent style, so we detect that case and
-- bail out everywhere autoformat would otherwise fire.
local function in_postgres_tree(bufnr)
	local name = vim.api.nvim_buf_get_name(bufnr)
	if name == "" then
		return false
	end
	local path = vim.fs.find(
		{ "src/tools/pgindent/pgindent" },
		{ upward = true, path = vim.fs.dirname(name), type = "file" }
	)
	return #path > 0
end

local function should_skip(bufnr)
	if vim.b[bufnr].disable_autoformat then
		return true
	end
	if vim.bo[bufnr].filetype == "yaml" then
		return true
	end
	return in_postgres_tree(bufnr)
end

require("conform").setup({
	format_on_save = function(bufnr)
		if should_skip(bufnr) then
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

		if should_skip(buf) then
			return
		end

		vim.defer_fn(function()
			if vim.api.nvim_buf_is_valid(buf) then
				require("conform").format({ bufnr = buf, lsp_format = "fallback" })
			end
		end, 100)
	end,
})

nmap("<leader>tf", function()
	local buf = vim.api.nvim_get_current_buf()
	vim.b[buf].disable_autoformat = not vim.b[buf].disable_autoformat
	vim.notify("Format on save " .. (vim.b[buf].disable_autoformat and "off" or "on"))
end, { desc = "Toggle format on save" })

nmap("<leader>cf", function()
	local buf = vim.api.nvim_get_current_buf()
	if in_postgres_tree(buf) then
		vim.cmd("Pgindent")
		return
	end
	require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Format buffer" })

-- :Pgindent on the current file using src/tools/pgindent/pgindent.
-- Walks up from the buffer to find the postgres root, runs pgindent on the
-- file path, then reloads the buffer.
vim.api.nvim_create_user_command("Pgindent", function()
	local buf = vim.api.nvim_get_current_buf()
	local file = vim.api.nvim_buf_get_name(buf)
	if file == "" then
		vim.notify("Pgindent: buffer has no file", vim.log.levels.WARN)
		return
	end
	local found = vim.fs.find(
		{ "src/tools/pgindent/pgindent" },
		{ upward = true, path = vim.fs.dirname(file), type = "file" }
	)
	if #found == 0 then
		vim.notify("Pgindent: not in a postgres tree", vim.log.levels.WARN)
		return
	end
	if vim.bo[buf].modified then
		vim.cmd("write")
	end
	local pgindent = found[1]
	vim.system({ pgindent, file }, { text = true }, function(out)
		vim.schedule(function()
			if out.code ~= 0 then
				vim.notify("pgindent failed: " .. (out.stderr or ""), vim.log.levels.ERROR)
				return
			end
			vim.cmd("checktime")
		end)
	end)
end, { desc = "Run src/tools/pgindent/pgindent on current file" })

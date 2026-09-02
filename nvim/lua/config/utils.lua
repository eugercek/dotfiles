local M = {}
function M.prompt_new_file()
	vim.ui.input({ prompt = "New file: ", completion = "file" }, function(input)
		if not input or vim.trim(input) == "" then
			return
		end

		vim.schedule(function()
			vim.cmd.edit(vim.fn.fnameescape(input))
		end)
	end)
end

function M.delete_file()
	local path = vim.fn.expand("%:p")
	if path == "" or vim.bo.buftype ~= "" then
		vim.notify("No file", vim.log.levels.WARN)
		return
	end
	-- confirm before nuking it off disk
	if vim.fn.confirm("Delete " .. vim.fn.expand("%:.") .. "?", "&Yes\n&No", 2) ~= 1 then
		return
	end
	local ok, err = pcall(vim.fn.delete, path)
	if ok and err == 0 then
		vim.api.nvim_buf_delete(0, { force = true })
		vim.notify("Deleted " .. path)
	else
		vim.notify("Delete failed: " .. tostring(err), vim.log.levels.ERROR)
	end
end

function M.rename_file()
	local old = vim.fn.expand("%:p")
	if old == "" or vim.bo.buftype ~= "" then
		vim.notify("No file", vim.log.levels.WARN)
		return
	end
	vim.ui.input({ prompt = "Rename to: ", default = old, completion = "file" }, function(input)
		if not input or vim.trim(input) == "" or input == old then
			return
		end
		vim.fn.mkdir(vim.fn.fnamemodify(input, ":h"), "p")
		local ok, err = pcall(vim.fn.rename, old, input)
		if ok and err == 0 then
			-- open the new path, wipe the stale buffer for the old one
			vim.cmd.edit(vim.fn.fnameescape(input))
			vim.cmd("bwipeout! #")
			vim.notify("Renamed to " .. input)
		else
			vim.notify("Rename failed: " .. tostring(err), vim.log.levels.ERROR)
		end
	end)
end

function M.live_grep_directory(path)
	local dir = vim.fs.normalize(path)
	if vim.fn.isdirectory(dir) == 0 then
		dir = vim.fs.dirname(dir)
	end

	require("telescope.builtin").live_grep({
		search_dirs = { dir },
	})
end

return M

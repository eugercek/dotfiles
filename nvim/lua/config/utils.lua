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

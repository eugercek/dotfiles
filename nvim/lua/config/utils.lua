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

-- box-drawing table (the kind AI spits out) -> markdown table, on the visual selection
-- rows that wrap over several lines get joined back into one cell
function M.box_table_to_markdown()
	local s, e = vim.fn.line("v"), vim.fn.line(".")
	if s > e then
		s, e = e, s
	end
	local lines = vim.api.nvim_buf_get_lines(0, s - 1, e, false)
	vim.api.nvim_feedkeys(vim.keycode("<esc>"), "nx", false)

	local rows, cur = {}, nil
	for _, line in ipairs(lines) do
		if line:find("│", 1, true) then
			local cells = vim.split(line, "│", { plain = true })
			table.remove(cells, 1) -- junk before the first │
			table.remove(cells) -- and after the last one
			cur = cur or {}
			for i, cell in ipairs(cells) do
				cell = vim.trim(cell):gsub("|", "\\|")
				cur[i] = cur[i] and vim.trim(cur[i] .. " " .. cell) or cell
			end
		elseif cur then
			-- any ├──┼──┤ / └──┴──┘ border closes the row we were collecting
			table.insert(rows, cur)
			cur = nil
		end
	end
	if cur then
		table.insert(rows, cur)
	end

	if #rows == 0 then
		vim.notify("No box table in selection", vim.log.levels.WARN)
		return
	end

	local ncols, width = 0, {}
	for _, row in ipairs(rows) do
		ncols = math.max(ncols, #row)
	end
	for _, row in ipairs(rows) do
		for i = 1, ncols do
			row[i] = row[i] or ""
			width[i] = math.max(width[i] or 3, vim.fn.strdisplaywidth(row[i]))
		end
	end

	local function render(row, fill)
		local out = {}
		for i = 1, ncols do
			out[i] = row[i] .. string.rep(fill or " ", width[i] - vim.fn.strdisplaywidth(row[i]))
		end
		return "| " .. table.concat(out, " | ") .. " |"
	end

	local sep = {}
	for i = 1, ncols do
		sep[i] = "---"
	end

	local out = { render(rows[1]), render(sep, "-") }
	for i = 2, #rows do
		table.insert(out, render(rows[i]))
	end
	vim.api.nvim_buf_set_lines(0, s - 1, e, false, out)
end

-- walk up to the nearest heading, open a new one below at its level + delta
-- (0 same, 1 deeper, -1 shallower). Clamped to ##..######, # is the note title.
function M.insert_heading(delta)
	local level = 1
	for l = vim.fn.line("."), 1, -1 do
		local hashes = vim.fn.getline(l):match("^(#+)%s")
		if hashes then
			level = #hashes
			break
		end
	end
	local prefix = string.rep("#", math.max(2, math.min(level + delta, 6))) .. " "
	vim.api.nvim_put({ prefix }, "l", true, false) -- new line below, cursor at end
	vim.cmd("startinsert!")
end

return M

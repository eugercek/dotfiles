-- annotate.lua — Take notes on code while reading a codebase.
--
-- All notes lives in REPO_ROOT/notes.md with this structure:
--
--   # File <relpath>
--
--   ## Location <relpath>:<line>            (or <relpath>:<start>-<end>)
--
--   ```<lang>
--   <selected code>
--   ```
--
--   ... your notes ...
--
-- Usage: select a range (or put the cursor on an annotated line) and run
-- :AnnotateCode. A markdown side panel opens with the captured code and any
-- existing notes. `:w` saves, and leaving the panel saves too.
--   :AnnotateCode   stays open until you close its window/buffer
--   :AnnotateCode!  also closes the panel the moment you leave it
--
-- notes.md is the ssot: an existing note is read from disk into the panel
-- verbatim, and on save only those exact lines are replaced, the rest of
-- the file is never rewritten. Annotated lines get a sign-column mark.
--

local M = {}

local ns = vim.api.nvim_create_namespace("annotate")

local function is_file(line)
	return line:match("^# File ")
end

local function is_heading(line)
	return is_file(line) or line:match("^## Location ")
end

local function note_path(buf)
	local root = vim.fs.root(buf, ".git") or vim.uv.cwd()
	return vim.fs.joinpath(root, "notes.md"), root
end

local function read_lines(path)
	local out = {}
	local f = io.open(path, "r")
	if f then
		for line in f:lines() do
			out[#out + 1] = line
		end
		f:close()
	end
	return out
end

local function write_lines(path, lines)
	local f = assert(io.open(path, "w"))
	f:write(table.concat(lines, "\n"), "\n")
	f:close()
end

-- Span (1-indexed, inclusive) of the lines from the line equal to `heading`
-- up to the next line matching `ends` (or EOF); nil if `heading` is absent.
local function span(lines, heading, ends)
	local s
	for i, line in ipairs(lines) do
		if s and ends(line) then
			return s, i - 1
		elseif line == heading then
			s = i
		end
	end
	if s then
		return s, #lines
	end
end

-- Every `## Location <name>:<s>(-<e>)` heading in `lines`, as a list of
-- { i = heading line index, s = first annotated line, e = last }.
local function locations(lines, name)
	local pat = "^## Location " .. vim.pesc(name) .. ":(%d+)%-?(%d*)$" -- pesc: '.' in filenames is pattern magic
	local out = {}
	for i, line in ipairs(lines) do
		local s, e = line:match(pat)
		if s then
			out[#out + 1] = { i = i, s = tonumber(s), e = tonumber(e) or tonumber(s) }
		end
	end
	return out
end

-- Splice `block` into notes.md, touching nothing else: replace the existing
-- block for `loc`, or append it to the file's section (created if missing).
local function save(path, name, loc, block)
	local lines = read_lines(path)
	local s, e = span(lines, "## Location " .. loc, is_heading)
	if not s then
		local _, fe = span(lines, "# File " .. name, is_file)
		if not fe then
			if #lines > 0 then
				lines[#lines + 1] = ""
			end
			vim.list_extend(lines, { "# File " .. name, "" })
			fe = #lines
		end
		s, e = fe + 1, fe -- empty span: replace nothing, insert after line fe
	end
	local out = vim.list_slice(lines, 1, s - 1)
	vim.list_extend(out, block)
	vim.list_extend(out, lines, e + 1, #lines)
	write_lines(path, out)
end

-- ===========================================================================
-- signs
-- ===========================================================================

local function place_signs(buf)
	local abs = vim.api.nvim_buf_get_name(buf)
	if not vim.api.nvim_buf_is_loaded(buf) or abs == "" or vim.bo[buf].buftype ~= "" then
		return
	end
	local path, root = note_path(buf)
	local name = vim.fs.relpath(root, abs)
	if not name then
		return
	end

	vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
	local last = vim.api.nvim_buf_line_count(buf)
	for _, l in ipairs(locations(read_lines(path), name)) do
		if l.s <= last then -- mark only the first line of the range
			vim.api.nvim_buf_set_extmark(buf, ns, l.s - 1, 0, { sign_text = "📝" })
		end
	end
end

local function refresh_all_signs()
	vim.tbl_map(place_signs, vim.api.nvim_list_bufs())
end

-- ===========================================================================
-- side panel
-- ===========================================================================

local function open_panel(src_buf, path, name, loc, block, auto_close)
	-- a panel for this loc may already be open (persistent mode leaves panels
	-- around); drop it so the new one reads fresh and the name can be reused
	local prev = vim.fn.bufnr("annotate://" .. loc)
	if prev ~= -1 then
		vim.api.nvim_buf_delete(prev, { force = true })
	end

	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_name(buf, "annotate://" .. loc)
	vim.bo[buf].filetype = "markdown"
	vim.bo[buf].buftype = "acwrite" -- no file behind this buffer: :w fires BufWriteCmd instead of writing
	vim.bo[buf].bufhidden = "wipe" -- discard the scratch buffer once its window is gone
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, block)
	vim.bo[buf].modified = false -- a panel left untouched must never write notes.md

	local function persist()
		save(path, name, loc, vim.api.nvim_buf_get_lines(buf, 0, -1, false))
		vim.bo[buf].modified = false
		-- notes.md may be open in a buffer; without checktime that buffer goes
		-- stale and saving it later would clobber what we just wrote.
		-- (scheduled: checktime is not allowed inside autocmd handlers)
		vim.schedule(function()
			pcall(vim.cmd.checktime)
		end)
		if vim.api.nvim_buf_is_valid(src_buf) then
			place_signs(src_buf)
		end
	end

	vim.api.nvim_create_autocmd("BufWriteCmd", { buffer = buf, callback = persist })
	-- save on any way out: BufLeave (moved away), BufWinLeave (window closed),
	-- QuitPre (`:q` — runs before Vim's "unsaved changes" guard, so an edited
	-- panel closes cleanly instead of erroring with E37)
	vim.api.nvim_create_autocmd({ "BufLeave", "BufWinLeave", "QuitPre" }, {
		buffer = buf,
		callback = function()
			if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].modified then
				persist()
			end
		end,
	})
	-- auto-close mode only: leaving the panel also closes it (the save above
	-- has already run). BufLeave fires in the middle of the window switch,
	-- where tearing down windows is not allowed — defer to the main loop.
	if auto_close then
		vim.api.nvim_create_autocmd("BufLeave", {
			buffer = buf,
			callback = function()
				vim.schedule(function()
					for _, w in ipairs(vim.fn.win_findbuf(buf)) do
						pcall(vim.api.nvim_win_close, w, true)
					end
					if vim.api.nvim_buf_is_valid(buf) then
						vim.api.nvim_buf_delete(buf, { force = true })
					end
				end)
			end,
		})
	end

	local win = vim.api.nvim_open_win(buf, true, { split = "right", win = 0 })
	vim.api.nvim_win_set_width(win, 70)
	vim.wo[win].wrap = true -- notes are prose in a narrow split: always wrap
	vim.wo[win].linebreak = true -- wrap at word boundaries, not mid-word
	vim.api.nvim_win_set_cursor(win, { vim.api.nvim_buf_line_count(buf), 0 })
end

-- ===========================================================================
-- command
-- ===========================================================================

local function annotate(opts)
	local buf_id = vim.api.nvim_get_current_buf()
	local abs_path = vim.api.nvim_buf_get_name(buf_id)
	if abs_path == "" or vim.bo[buf_id].buftype ~= "" then
		return vim.notify("annotate: current buffer is not a file", vim.log.levels.WARN)
	end

	local path, root = note_path(buf_id)
	local name = vim.fs.relpath(root, abs_path)
	if not name then
		-- an absolute-path heading would never match the relpath-based sign
		-- and reopen lookups, so refuse instead of writing a broken note
		return vim.notify("annotate: " .. abs_path .. " is outside " .. root, vim.log.levels.WARN)
	end
	local lines = read_lines(path)

	-- an existing annotation overlapping the range is reopened with its notes
	local loc
	for _, l in ipairs(locations(lines, name)) do
		if opts.line1 <= l.e and opts.line2 >= l.s then
			loc = lines[l.i]:match("^## Location (.+)$")
			break
		end
	end
	loc = loc or name .. ":" .. opts.line1 .. (opts.line2 > opts.line1 and "-" .. opts.line2 or "")

	local s, e = span(lines, "## Location " .. loc, is_heading)
	local block
	if s then
		block = vim.list_slice(lines, s, e)
	else
		block = { "## Location " .. loc, "", "```" .. vim.bo[buf_id].filetype }
		vim.list_extend(block, vim.api.nvim_buf_get_lines(buf_id, opts.line1 - 1, opts.line2, false))
		vim.list_extend(block, { "```", "", "" })
	end
	open_panel(buf_id, path, name, loc, block, opts.bang)
end

function M.setup()
	-- :AnnotateCode persists; :AnnotateCode! closes the panel on leave
	vim.api.nvim_create_user_command("AnnotateCode", annotate, { range = true, bang = true })

	local group = vim.api.nvim_create_augroup("annotate", { clear = true })
	vim.api.nvim_create_autocmd("BufReadPost", {
		group = group,
		callback = function(ev)
			place_signs(ev.buf)
		end,
	})
	-- notes.md edited by hand: re-place signs everywhere
	vim.api.nvim_create_autocmd("BufWritePost", {
		group = group,
		pattern = "notes.md",
		callback = refresh_all_signs,
	})

	refresh_all_signs()
end

return M

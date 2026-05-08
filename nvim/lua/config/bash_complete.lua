local M = {}

local function add_name(names, seen, name)
	if not name or seen[name] then
		return
	end

	seen[name] = true
	names[#names + 1] = name
end

local function add_matches(names, seen, text, pattern)
	for name in text:gmatch(pattern) do
		add_name(names, seen, name)
	end
end

local function collect_declared_names(line, names, seen)
	local prefix = line:match("^%s*local%s+(.+)$")
		or line:match("^%s*declare%s+(.+)$")
		or line:match("^%s*typeset%s+(.+)$")
		or line:match("^%s*readonly%s+(.+)$")
		or line:match("^%s*export%s+(.+)$")

	if not prefix then
		return
	end

	prefix = prefix:gsub("%s+#.*$", "")
	prefix = prefix:gsub("%s+[-][-%w]+", " ")
	add_matches(names, seen, prefix, "([%a_][%w_]*)%s*=?")
end

local function collect_names()
	local names, seen = {}, {}

	for _, line in ipairs(vim.api.nvim_buf_get_lines(0, 0, -1, false)) do
		line = line:gsub("%s+#.*$", "")
		collect_declared_names(line, names, seen)
		add_matches(names, seen, line, "^%s*([%a_][%w_]*)%s*=")
		add_matches(names, seen, line, "[({;|&]%s*([%a_][%w_]*)%s*=")
		add_matches(names, seen, line, "for%s+([%a_][%w_]*)%s+in")
		add_matches(names, seen, line, "read%s+.-([%a_][%w_]*)%s*$")
	end

	table.sort(names)
	return names
end

function M.complete(findstart, base)
	local line = vim.api.nvim_get_current_line()
	local col = vim.fn.col(".") - 1

	if findstart == 1 then
		local start = col
		while start > 0 and line:sub(start, start):match("[%w_]") do
			start = start - 1
		end

		local trigger = line:sub(start, start)
		local brace_trigger = trigger == "{" and start > 1 and line:sub(start - 1, start - 1) == "$"
		if trigger == "$" or brace_trigger then
			return start
		end

		return -2
	end

	local matches = {}
	for _, name in ipairs(collect_names()) do
		if name:find("^" .. vim.pesc(base)) then
			matches[#matches + 1] = {
				word = name,
				abbr = name,
				kind = "v",
				menu = "[vars]",
			}
		end
	end

	return matches
end

return M

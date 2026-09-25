-- Pull a color out of a highlight group, with a fallback if the theme skips it
local function hl_color(group, key, fallback)
	local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
	return (ok and hl[key]) or fallback
end

-- Some builtin themes (lunaperche) paint the split line and statusline as solid
-- slabs: a fat gray column between windows and a black bar at the bottom.
-- Repaint them so they blend into the buffer.
local function soften_chrome()
	local bg = hl_color("Normal", "bg", nil)
	local fg = hl_color("Normal", "fg", nil)
	local muted = hl_color("NonText", "fg", fg)
	local bar = hl_color("CursorLine", "bg", bg)

	vim.api.nvim_set_hl(0, "WinSeparator", { fg = muted, bg = bg })
	vim.api.nvim_set_hl(0, "StatusLine", { fg = fg, bg = bar })
	vim.api.nvim_set_hl(0, "StatusLineNC", { fg = muted, bg = bar })
	vim.api.nvim_set_hl(0, "MsgArea", { fg = fg, bg = bg })
end

local function apply()
	local is_dark = vim.system({ "defaults", "read", "-g", "AppleInterfaceStyle" }, { text = true }):wait().code == 0
	local theme = is_dark and "retrobox" or "lunaperche"

	vim.opt.background = is_dark and "dark" or "light"
	vim.cmd.colorscheme(theme)
end

-- Run on every colorscheme change, not just ours, so :colorscheme stays sane
vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		vim.api.nvim_set_hl(0, "FoldedInfo", { fg = "#7daea3", bold = true })
		soften_chrome()
	end,
})

vim.api.nvim_create_user_command("ThemeSystem", apply, {})

apply()

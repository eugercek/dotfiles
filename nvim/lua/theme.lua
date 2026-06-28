local function apply()
	local is_dark = vim.system({ "defaults", "read", "-g", "AppleInterfaceStyle" }, { text = true }):wait().code == 0
	local theme = is_dark and "retrobox" or "lunaperche"

	vim.opt.background = is_dark and "dark" or "light"
	vim.cmd.colorscheme(theme)
	vim.api.nvim_set_hl(0, "FoldedInfo", { fg = "#7daea3", bold = true })
end

vim.api.nvim_create_user_command("ThemeSystem", apply, {})

apply()

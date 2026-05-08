vim.pack.add({
	{ src = "https://github.com/okuuva/auto-save.nvim" },
})

require("auto-save").setup({
	debounce_delay = 2000,
	trigger_events = {
		immediate_save = { "BufLeave", "FocusLost", "QuitPre", "VimSuspend" },
		defer_save = { "InsertLeave", "TextChanged" },
		cancel_deferred_save = { "InsertEnter" },
	},
	condition = function(buf)
		if vim.fn.mode() == "i" then
			return false
		end

		return vim.api.nvim_buf_is_valid(buf)
			and vim.bo[buf].buftype == ""
			and vim.bo[buf].modifiable
			and not vim.bo[buf].readonly
			and vim.api.nvim_buf_get_name(buf) ~= ""
	end,
})

vim.pack.add({
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.*") },
})

require("blink.cmp").setup({
	enabled = function()
		return not vim.g.cmp_disabled
	end,
	keymap = {
		preset = "enter",
		["<Tab>"] = { "snippet_forward", "select_and_accept", "fallback" },
		["<S-Tab>"] = { "snippet_backward", "fallback" },
		["<C-j>"] = { "select_next", "fallback" },
		["<C-k>"] = { "select_prev", "fallback" },
	},
	appearance = {
		nerd_font_variant = "mono",
	},
	completion = {
		menu = {
			auto_show = function()
				return vim.bo.filetype ~= "markdown"
			end,
			-- auto_show_delay_ms = 300,
			border = "rounded",
			draw = {
				columns = {
					{ "kind_icon" },
					{ "label", "label_description", gap = 1 },
				},
			},
		},
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 200,
		},
	},
	signature = {
		enabled = true,
		window = { border = "rounded" },
	},
	sources = {
		default = function()
			if vim.bo.filetype == "sh" then
				return { "lsp", "shell_vars", "path", "snippets", "buffer" }
			end

			return { "lsp", "path", "snippets", "buffer" }
		end,
		providers = {
			lsp = {
				fallbacks = {},
			},
			shell_vars = {
				module = "blink.cmp.sources.complete_func",
				enabled = function()
					return vim.bo.filetype == "sh"
				end,
				opts = {
					complete_func = function()
						return "v:lua.require'config.bash_complete'.complete"
					end,
				},
			},
		},
	},
	snippets = { preset = "default" },
})

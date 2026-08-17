vim.pack.add({
	{ src = "https://github.com/echasnovski/mini.pairs" },
})

require("mini.pairs").setup()

-- satirda acik kalmis tirnak varsa ciftleme, tek tane bas yeter
for _, q in ipairs({ "'", '"', "`" }) do
	vim.keymap.set("i", q, function()
		local _, n = vim.api.nvim_get_current_line():gsub(q, "")
		if n % 2 == 1 then
			return q
		end
		return MiniPairs.closeopen(q .. q, q == "'" and "[^%a\\]." or "[^\\].")
	end, { expr = true, replace_keycodes = false })
end

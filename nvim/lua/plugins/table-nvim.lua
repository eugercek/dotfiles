vim.pack.add({
	{ src = "https://github.com/SCJangra/table-nvim" },
})

-- All mappings are buffer-local to markdown and prefixed with <localleader> (,)
-- so they never collide with the default <A-…>/<Tab> bindings.
--   r = row, c = column, t = table; lowercase inserts, uppercase moves.
require("table-nvim").setup({
	padd_column_separators = true,
	mappings = {
		next = "<Tab>",
		prev = "<S-Tab>",

		insert_row_up = "<localleader>rk", -- insert row above
		insert_row_down = "<localleader>rj", -- insert row below
		move_row_up = "<localleader>rK", -- move row up
		move_row_down = "<localleader>rJ", -- move row down

		insert_column_left = "<localleader>ch", -- insert column left
		insert_column_right = "<localleader>cl", -- insert column right
		move_column_left = "<localleader>cH", -- move column left
		move_column_right = "<localleader>cL", -- move column right
		delete_column = "<localleader>cd", -- delete column

		insert_table = "<localleader>tt", -- insert table
		insert_table_alt = "<localleader>tT", -- insert table (alt)
	},
})

vim.pack.add({
	{ src = "https://github.com/echasnovski/mini.surround" },
})

-- defaults: sa/sd/sr/sf/sF/sh/sn, and builtin s becomes <Nop> (cl does the same)
require("mini.surround").setup()

-- We must declare these before anythin else because <leader> needs to be defined
-- when it's used in vim.keymap.set
vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.g.have_nerd_font = true
vim.g.autoformat = true

_G.nmap = function(lhs, rhs, opts)
	vim.keymap.set("n", lhs, rhs, opts)
end

require("vim._core.ui2").enable({})

local function load_all(prefix)
	for name, type in vim.fs.dir(vim.fn.stdpath("config") .. "/lua/" .. prefix) do
		if type == "file" and name:sub(-4) == ".lua" then
			require(prefix .. "." .. name:sub(1, -5))
		end
	end
end

require("options")
require("theme")

load_all("plugins")
load_all("config")

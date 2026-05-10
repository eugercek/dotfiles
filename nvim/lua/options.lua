vim.opt.termguicolors = true
vim.opt.mouse = "a" -- Use mouse everywhere
vim.opt.showmode = false -- Don't show -- INSERT in statusline
vim.opt.undolevels = 10000
vim.opt.clipboard = "unnamedplus" -- Use the system clipboard

-- "foo" matches "Foo", but "Foo" only matches "Foo"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false -- Don't highlight search resulsts, no yellow

vim.opt.signcolumn = "yes" -- Keep the sign column visible
vim.opt.inccommand = "split" -- Preview substitutions while typing :%s

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.updatetime = 200
vim.opt.timeoutlen = 300

-- Keep some context visible while scrolling
vim.opt.scrolloff = 3
vim.opt.sidescrolloff = 8

vim.opt.confirm = true -- Ask me when something sould fail

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.wrap = false
vim.opt.linebreak = true

-- Tab defaults
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.shiftround = true
vim.opt.autoindent = true
vim.opt.breakindent = true

vim.opt.autoread = true -- Reload files changed outside Neovim when safe
vim.opt.cursorline = true
vim.opt.laststatus = 3
vim.opt.showtabline = 0
vim.opt.cmdheight = 0
vim.opt.pumheight = 15
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.fillchars = {
	foldopen = " ",
	foldclose = " ",
	fold = " ",
	foldsep = " ",
	diff = "╱",
	eob = " ",
}
vim.opt.shortmess:append("c")
vim.opt.hidden = true

-- Keep recovery files in Neovim's state dir so projects stay clean.
local state = vim.fn.stdpath("state")
vim.fn.mkdir(state .. "/swap", "p")
vim.fn.mkdir(state .. "/undo", "p")
vim.opt.directory = state .. "/swap//"
vim.opt.undodir = state .. "/undo//"
vim.opt.swapfile = true
vim.opt.backup = false
vim.opt.writebackup = true
vim.opt.undofile = true

-- Treesitter-powered folding, but start unfolded
vim.opt.foldlevelstart = 99
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.sessionoptions = {
	"buffers",
	"curdir",
	"folds",
	"globals",
	"help",
	"tabpages",
	"terminal",
	"winpos",
	"winsize",
}

vim.opt.background = "dark"

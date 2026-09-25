-- Putting most of the keymaps here
-- But have some keymaps in file specific places
--
-- Keymap rules:
-- - I never assign 2 keymaps for same action

-- Buffers
nmap("<leader>bd", "<cmd>bdelete<cr>", { desc = "Kill buffer" })
nmap("<leader>br", "<cmd>edit!<cr>", { desc = "Revert buffer" })
nmap("<leader>bs", "<cmd>enew<cr>", { desc = "Scratch buffer" })
nmap("<leader>`", "<cmd>e #<cr>", { desc = "Alternate buffer" })

-- Help
nmap("<leader>hi", "<cmd>help index<cr>", { desc = "Info" })
nmap("<leader>hm", "<cmd>checkhealth<cr>", { desc = "health" })

vim.cmd("packadd nvim.undotree")
vim.cmd("packadd nvim.difftool")

nmap("<leader>tl", function()
	vim.wo.number = not vim.wo.number
end, { desc = "Line numbers" })

nmap("<leader>tw", "<cmd>set wrap!<cr>", { desc = "Toggle Wrap", silent = true })
nmap("<leader>ts", function()
	vim.wo.spell = not vim.wo.spell
	if vim.wo.spell then
		vim.opt_local.spelllang = { "tr", "en_us" }
	end
end, { desc = "Toggle Spell" })
nmap("<leader>tu", "<cmd>Undotree<cr>", { desc = "Undotree" })
nmap("<leader>tc", function()
	vim.g.cmp_disabled = not vim.g.cmp_disabled
	vim.notify("Completion " .. (vim.g.cmp_disabled and "off" or "on"))
end, { desc = "Toggle completion" })
-- diffopt is global-only, so this applies to every diff window (diffview, :diffsplit, nvim -d)
nmap("<leader>ti", function()
	local on = vim.o.diffopt:find("iwhiteall") ~= nil
	vim.opt.diffopt[on and "remove" or "append"](vim.opt.diffopt, "iwhiteall")
	vim.cmd.diffupdate()
	vim.notify("Diff ignore whitespace (global) " .. (on and "off" or "on"))
end, { desc = "Toggle diff ignore whitespace (global)" })

nmap("<leader>oj", function()
	if vim.fn.getqflist({ winid = 0 }).winid ~= 0 then
		vim.cmd("cclose")
	else
		vim.cmd("copen")
	end
end, { desc = "Toggle quickfix, (J)ump" })

nmap("<leader>tL", function()
	local buf = vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_clients({ bufnr = buf })
	if #clients > 0 then
		for _, c in ipairs(clients) do
			vim.lsp.buf_detach_client(buf, c.id)
		end
		vim.notify("LSP off")
	else
		vim.cmd("edit")
		vim.notify("LSP on")
	end
end, { desc = "Toggle LSP" })

-- File
local utils = require("config.utils")

nmap("<leader>fn", utils.prompt_new_file, { desc = "New file" })
nmap("<leader>fs", "<cmd>write<cr>", { desc = "Save file" })
nmap("<leader>fd", utils.delete_file, { desc = "Delete file" })
nmap("<leader>fR", utils.rename_file, { desc = "Rename file" })

-- Swap gf/gF: gf honors a trailing :line, gF just opens the file
vim.keymap.set({ "n", "x" }, "gf", "gF", { desc = "Goto file (with line)" })
vim.keymap.set({ "n", "x" }, "gF", "gf", { desc = "Goto file (no line)" })
local function yank_path(suffix)
	local path = vim.fn.expand("%:.")
	if path == "" then
		vim.notify("No file", vim.log.levels.WARN)
		return
	end
	vim.fn.setreg("+", path .. (suffix or ""))
	vim.notify(path .. (suffix or ""))
end

nmap("<leader>fy", yank_path, { desc = "Yank relative path" })

nmap("<leader>fY", function()
	local path = vim.fn.expand("%:p")
	vim.fn.setreg("+", path)
	vim.notify(path)
end, { desc = "Yank absolute path" })

vim.keymap.set("x", "<leader>fy", function()
	local s, e = vim.fn.line("v"), vim.fn.line(".")
	if s > e then
		s, e = e, s
	end
	yank_path(s == e and ":" .. s or string.format(":%d-%d", s, e))
end, { desc = "Yank relative path with line(s)" })

vim.keymap.set("x", "<leader>nm", utils.box_table_to_markdown, { desc = "Box table -> markdown table" })

-- Quit
nmap("<leader>qq", "<cmd>wqa<cr>", { desc = "Close window" })

-- Compile / run
local last_cmd = nil

local function run(cmd)
	vim.cmd("write")
	vim.cmd("!" .. cmd)
end

local function compile(prompt)
	if prompt or not last_cmd then
		vim.ui.input({
			prompt = "Compile: ",
			default = last_cmd or "gcc -Wall -Wextra -g % -o %:r && ./%:r",
		}, function(input)
			if input and input ~= "" then
				last_cmd = input
				run(last_cmd)
			end
		end)
	else
		run(last_cmd)
	end
end

nmap("<leader>cr", function()
	compile(false)
end, { desc = "Run last compile cmd" })
nmap("<leader>cR", function()
	compile(true)
end, { desc = "Set compile cmd" })

-- QoL Improvements
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
vim.keymap.set("n", "gh", "^", { desc = "Go to start of line" })
vim.keymap.set("n", "gl", "$", { desc = "Go to end of line" })
vim.keymap.set("v", "<", "<gv", { desc = "Indent left" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right" })
vim.keymap.set("v", "p", '"_dP', { desc = "Paste without yanking replaced text" })
vim.keymap.set("i", "jk", "<Esc>", { desc = "Exit insert mode" })
-- no esc in insert, forcing myself to use jk
vim.keymap.set("i", "<Esc>", "<Nop>")
vim.keymap.set("i", ",", ",<C-g>u", { desc = "Comma undo breakpoint" })
vim.keymap.set("i", ".", ".<C-g>u", { desc = "Period undo breakpoint" })
vim.keymap.set("i", ";", ";<C-g>u", { desc = "Semicolon undo breakpoint" })

-- Swap ; and :, one less shift for command mode. f/t repeat moves to the shifted
-- side rather than disappearing, so d: is the old d;
vim.keymap.set({ "n", "x", "o" }, ";", ":", { desc = "Command mode" })
vim.keymap.set({ "n", "x", "o" }, ":", ";", { desc = "Repeat f/t" })

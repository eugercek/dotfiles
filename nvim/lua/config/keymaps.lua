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

-- Quit
nmap("<leader>qq", "<cmd>wqa<cr>", { desc = "Close window" })

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

-- Quit
nmap("<leader>qq", "<cmd>wqa<cr>", { desc = "Close window" })

-- Git
nmap("<leader>gc", function()
	local server = vim.v.servername
	if server == "" then
		vim.notify("No nvim server running", vim.log.levels.ERROR)
		return
	end
	local sentinel = vim.fn.tempname()
	local editor = ([[sh -c 'nvim --server %s --remote-tab "$0"; until [ -f %s ]; do sleep 0.1; done']]):format(
		server,
		sentinel
	)
	local ft_au = vim.api.nvim_create_autocmd("FileType", {
		pattern = "gitcommit",
		once = true,
		callback = function(args)
			vim.bo[args.buf].bufhidden = "wipe"
			vim.api.nvim_create_autocmd("BufWipeout", {
				buffer = args.buf,
				once = true,
				callback = function()
					vim.fn.writefile({}, sentinel)
				end,
			})
		end,
	})
	vim.system({ "git", "commit", "-v" }, {
		env = { GIT_EDITOR = editor },
	}, function(obj)
		vim.schedule(function()
			pcall(vim.api.nvim_del_autocmd, ft_au)
			vim.fn.delete(sentinel)
			if obj.code == 0 then
				vim.notify("Committed", vim.log.levels.INFO)
			else
				vim.notify((obj.stderr ~= "" and obj.stderr or obj.stdout) or "commit failed", vim.log.levels.WARN)
			end
		end)
	end)
end, { desc = "Git commit" })

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
vim.keymap.set("i", ",", ",<C-g>u", { desc = "Comma undo breakpoint" })
vim.keymap.set("i", ".", ".<C-g>u", { desc = "Period undo breakpoint" })
vim.keymap.set("i", ";", ";<C-g>u", { desc = "Semicolon undo breakpoint" })

vim.keymap.set("n", "<leader>tz", function()
	print(vim.wo.statuscolumn)
	if vim.wo.statuscolumn == "" then
		local width = vim.api.nvim_win_get_width(0)
		vim.wo.statuscolumn = string.rep(" ", 15) .. "  "
	else
		vim.wo.statuscolumn = "  "
	end
end, { desc = "Toggle centered buffer" })

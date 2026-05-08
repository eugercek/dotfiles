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
	vim.wo.relativenumber = not vim.wo.relativenumber
end, { desc = "Line numbers" })

nmap("<leader>tw", "<cmd>set wrap!<cr>", { desc = "Toggle Wrap", silent = true })
nmap("<leader>ts", function()
	vim.wo.spell = not vim.wo.spell
	if vim.wo.spell then
		vim.opt_local.spelllang = { "tr", "en_us" }
	end
end, { desc = "Toggle Spell" })
nmap("<leader>tu", "<cmd>Undotree<cr>", { desc = "Undotree" })

-- File
local utils = require("config.utils")

nmap("<leader>fn", utils.prompt_new_file, { desc = "New file" })
nmap("<leader>fs", "<cmd>write<cr>", { desc = "Save file" })

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

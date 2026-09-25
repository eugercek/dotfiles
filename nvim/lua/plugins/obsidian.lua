vim.pack.add({
	{ src = "https://github.com/obsidian-nvim/obsidian.nvim", version = vim.version.range("*") },
})

require("obsidian").setup({
	legacy_commands = false, -- use the new :Obsidian <sub> command
	workspaces = {
		{ name = "personal", path = "~/Desktop/Obsidian Vault" },
	},
	-- render-markdown.nvim already draws everything, so let it, not obsidian.
	ui = { enable = false },
	picker = { name = "telescope.nvim" },
	-- completion rides on the obsidian LSP; blink already has an lsp source
	footer = { enabled = false },
	-- default zettel_id ignores the title and spits out timestamp+random junk.
	-- title_id slugs the title instead: "C Pragma" -> c-pragma.md
	-- keep the title as-is like Obsidian does: "DNS Packet Internals" -> DNS Packet Internals.md
	note_id_func = function(title)
		return title or require("obsidian.builtin").zettel_id()
	end,
})

-- walk up to the nearest heading, open a new one a level deeper (capped at 6)
local function insert_subheading()
	local cur = vim.fn.line(".")
	local level = 0
	for l = cur, 1, -1 do
		local hashes = vim.fn.getline(l):match("^(#+)%s")
		if hashes then
			level = #hashes
			break
		end
	end
	local prefix = string.rep("#", math.min(level + 1, 6)) .. " "
	vim.api.nvim_put({ prefix }, "l", true, false) -- new line below, cursor at end
	vim.cmd("startinsert!")
end

-- Notes (<leader>n). nn was a hand-rolled telescope picker; quick_switch
-- already runs rg --files --sortr=modified, so it does the same job.
nmap("<leader>nn", "<cmd>Obsidian quick_switch<cr>", { desc = "Find note" })
nmap("<leader>nc", "<cmd>Obsidian new<cr>", { desc = "New note" })
nmap("<leader>ns", "<cmd>Obsidian search<cr>", { desc = "Search vault" })
nmap("<leader>nt", "<cmd>Obsidian tags<cr>", { desc = "Tags" })
nmap("<leader>nd", "<cmd>Obsidian today<cr>", { desc = "Daily note" })
nmap("<leader>nb", "<cmd>Obsidian backlinks<cr>", { desc = "Backlinks" })
nmap("<leader>nr", "<cmd>Obsidian rename<cr>", { desc = "Rename note" })
nmap("<leader>nh", insert_subheading, { desc = "Heading (one level deeper)" })

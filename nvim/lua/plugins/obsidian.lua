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
	-- don't use id/aliases/tags, so stop it stuffing frontmatter into every note
	frontmatter = { enabled = false },
	-- plain [[note#Heading]] like the app, default adds a |note ❯ Heading label
	link = {
		style = function(opts)
			local a, b = opts.anchor, opts.block
			local suffix = type(a) == "table" and "#" .. a.header or a or type(b) == "table" and "#" .. b.id or b or ""
			-- completion menu passes path = "", fall back to label or every item reads [[]]
			local name = opts.path ~= "" and opts.path or opts.label
			return ("[[%s%s]]"):format((tostring(name):gsub("%.md$", "")), suffix)
		end,
	},
	-- default zettel_id ignores the title and spits out timestamp+random junk.
	-- title_id slugs the title instead: "C Pragma" -> c-pragma.md
	-- keep the title as-is like Obsidian does: "DNS Packet Internals" -> DNS Packet Internals.md
	note_id_func = function(title)
		return title or require("obsidian.builtin").zettel_id()
	end,
})

-- obsidian-ls covers the vault, keep marksman out of it. With both answering,
-- telescope opens <leader>si twice and each picker feeds an "A" into the prompt
vim.lsp.config("marksman", {
	root_dir = function(buf, on_dir)
		if not vim.fs.relpath(vim.fn.expand("~/Desktop/Obsidian Vault"), vim.api.nvim_buf_get_name(buf)) then
			on_dir(vim.fs.root(buf, { ".marksman.toml", ".git" }))
		end
	end,
})

-- Notes (<leader>n). nn was a hand-rolled telescope picker; quick_switch
-- already runs rg --files --sortr=modified, so it does the same job.
nmap("<leader>nn", "<cmd>Obsidian quick_switch<cr>", { desc = "Find note" })
nmap("<leader>nc", "<cmd>Obsidian new<cr>", { desc = "New note" })
nmap("<leader>ns", "<cmd>Obsidian search<cr>", { desc = "Search vault" })
nmap("<leader>nt", "<cmd>Obsidian tags<cr>", { desc = "Tags" })
nmap("<leader>nd", "<cmd>Obsidian today<cr>", { desc = "Daily note" })
nmap("<leader>nb", "<cmd>Obsidian backlinks<cr>", { desc = "Backlinks" })
nmap("<leader>nr", "<cmd>Obsidian rename<cr>", { desc = "Rename note" })
nmap("<leader>no", "<cmd>edit ~/Desktop/Obsidian\\ Vault/today.md<cr>", { desc = "today.md" })

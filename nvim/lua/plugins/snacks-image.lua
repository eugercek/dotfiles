-- Inline images in the buffer, rendered with the kitty graphics protocol.
--
-- Needs a terminal that speaks the protocol (Ghostty does, including the
-- unicode placeholders that inline -- as opposed to floating -- rendering
-- requires), ImageMagick for the format conversion, and inside tmux
-- `allow-passthrough on` (already set in ~/.tmux.conf).
--
-- Only the `image` module of snacks.nvim is turned on; every other module
-- stays dormant unless it is given `enabled = true` here.

vim.pack.add({
	{ src = "https://github.com/folke/snacks.nvim" },
})

local vault = vim.fs.normalize("~/Desktop/Obsidian Vault")

-- Obsidian embeds look like `![[Pasted image 20251010191737.png | 750]]` and
-- every attachment lives in one vault-level `Media/` folder. Snacks strips the
-- `| 750` size hint but leaves the space that preceded it, and it only searches
-- next to the note and under the cwd -- so trim the source and add the vault
-- root to the search path.
local search_dirs = { ".", "Media", "attachments", "assets", "images", "img", "static" }

local function resolve(file, src)
	src = vim.trim(src)
	if src == "" or src:find("^%w%w+://") then
		return nil
	end

	local roots = { vim.fs.dirname(file), vim.uv.cwd() }
	if vim.startswith(file, vault) then
		table.insert(roots, 1, vault)
	end

	for _, root in ipairs(roots) do
		for _, dir in ipairs(search_dirs) do
			local path = vim.fs.joinpath(root, dir, src)
			if vim.fn.filereadable(path) == 1 then
				return path
			end
		end
	end
end

require("snacks").setup({
	image = {
		enabled = true,
		resolve = resolve,
		doc = {
			-- Draw in the buffer where the terminal allows it; the floating
			-- window is the fallback and what <leader>ii uses on demand.
			inline = true,
			float = true,
			max_width = 60,
			max_height = 25,
		},
	},
})

nmap("<leader>ii", function()
	Snacks.image.hover()
end, { desc = "Inspect image under cursor" })

-- Paste an image from the system clipboard into the buffer: the file is written
-- to disk and the matching markup is inserted at the cursor.
--
-- On macOS this shells out to pngpaste (brew install pngpaste).

vim.pack.add({
	{ src = "https://github.com/HakonHarnes/img-clip.nvim" },
})

local vault = vim.fs.normalize("~/Desktop/Obsidian Vault")

require("img-clip").setup({
	default = {
		dir_path = "assets", -- next to the file being edited
		relative_to_current_file = true,
		file_name = "%Y-%m-%d-%H-%M-%S",
		prompt_for_file_name = false,
		drag_and_drop = { insert_mode = true },
	},

	-- Inside the vault, imitate Obsidian exactly: attachments go to the single
	-- `Media/` folder named `Pasted image <timestamp>.png`, and the note gets a
	-- wiki embed. Notes written here stay identical to ones written in the app.
	dirs = {
		[vault] = {
			dir_path = vault .. "/Media",
			relative_to_current_file = false,
			file_name = "Pasted image %Y%m%d%H%M%S",
			template = "![[$FILE_NAME]]$CURSOR",
			url_encode_path = false,
		},
	},
})

nmap("<leader>ip", "<cmd>PasteImage<cr>", { desc = "Paste image from clipboard" })

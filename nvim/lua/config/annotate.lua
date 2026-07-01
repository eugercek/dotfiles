-- While developing: clearing package.loaded lets a re-:source pick up changes
package.loaded.annotate = nil
require("annotate").setup({ dir = "/Users/umut/Desktop/Obsidian Vault" })
--
-- Annotate the visual selection (or the current line in normal mode).
-- an: panel stays open until you close it. aN: panel closes when you leave it.
vim.keymap.set({ "n", "x" }, "<leader>an", ":AnnotateCode<CR>", { silent = true, desc = "Annotate (stays open)" })
vim.keymap.set({ "n", "x" }, "<leader>aN", ":AnnotateCode!<CR>", { silent = true, desc = "Annotate (auto-close)" })
--   <selected code>
-- Open the note file for the current repo (in config.dir, or REPO_ROOT/notes.md).
vim.keymap.set("n", "<leader>ao", function()
	require("annotate").open_notes()
end, { desc = "Open notes file" })
--
-- Jump the cursor between annotations in the current file (wraps at the ends).
vim.keymap.set("n", "<leader>aj", function()
	require("annotate").goto_annotation(1)
end, { desc = "Next annotation" })
vim.keymap.set("n", "<leader>ak", function()
	require("annotate").goto_annotation(-1)
end, { desc = "Previous annotation" })

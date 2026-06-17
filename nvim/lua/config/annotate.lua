-- While developing: clearing package.loaded lets a re-:source pick up changes
package.loaded.annotate = nil
require("annotate").setup()

-- Annotate the visual selection (or the current line in normal mode).
-- an: panel stays open until you close it. aN: panel closes when you leave it.
vim.keymap.set({ "n", "x" }, "<leader>an", ":AnnotateCode<CR>", { silent = true, desc = "Annotate (stays open)" })
vim.keymap.set({ "n", "x" }, "<leader>aN", ":AnnotateCode!<CR>", { silent = true, desc = "Annotate (auto-close)" })

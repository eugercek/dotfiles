vim.pack.add({
	{ src = "https://github.com/chrisbra/NrrwRgn" },
})

-- Emacs-style narrowing: <leader>nr on a visual selection (or as a normal mode
-- operator) opens the region in a scratch split, original buffer goes read-only,
-- :w writes the region back. <leader>Nr does it in the current window instead.
-- Both are the plugin's own defaults, kept as-is.

local nxmap = function(lhs, rhs, desc)
	vim.keymap.set({ "n", "x" }, lhs, rhs, { silent = true, desc = desc })
end

nxmap("<leader>nw", "<cmd>NW<cr>", "Narrow visible window")
nxmap("<leader>nl", "<cmd>NRL<cr>", "Narrow last region again")

-- Multi narrow: mark lines with NRP (takes a range, e.g. :v/^#/NRP), then NRM
-- collects them into one buffer; writing splices each block back to its origin.
nxmap("<leader>np", ":NRP<cr>", "Prepare region (multi)")
nxmap("<leader>nu", ":NRUnprepare<cr>", "Unprepare region (multi)")
nxmap("<leader>nm", "<cmd>NRM<cr>", "Narrow prepared regions")

-- Current chunk of a unified diff / merge conflict, side by side in diff mode
nxmap("<leader>nd", "<cmd>NUD<cr>", "Narrow diff chunk")

-- The narrowed window's zoom toggle defaults to <Leader><Space>, which would
-- shadow <leader><leader> (Telescope find_files). Claim the <Plug> map so
-- NrrwRgn skips its default (it checks hasmapto()).
vim.keymap.set("n", "<leader>nz", "<Plug>NrrwrgnWinIncr", { desc = "Zoom narrowed window" })

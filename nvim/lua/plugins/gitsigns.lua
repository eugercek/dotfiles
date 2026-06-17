vim.pack.add({
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
})

require("gitsigns").setup({
	signs = {
		add = { text = "+" },
		change = { text = "~" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
	},
	on_attach = function(bufnr)
		-- Don't enable gitsigns in markdown buffers.
		if vim.bo[bufnr].filetype == "markdown" then
			return false
		end

		local gs = require("gitsigns")
		local function hunk_range()
			local first = vim.fn.line(".")
			local last = vim.fn.line("v")

			if first > last then
				first, last = last, first
			end

			return { first, last }
		end

		nmap("<leader>gb", gs.blame_line, { buffer = bufnr, desc = "Blame line" })
		nmap("<leader>gB", gs.toggle_current_line_blame, { buffer = bufnr, desc = "Toggle line blame" })
		nmap("<leader>gh", gs.preview_hunk, { buffer = bufnr, desc = "Preview hunk" })
		nmap("<leader>gH", gs.diffthis, { buffer = bufnr, desc = "Diff buffer" })
		nmap("<leader>gl", gs.setloclist, { buffer = bufnr, desc = "Hunks to loclist" })
		nmap("<leader>gn", gs.next_hunk, { buffer = bufnr, desc = "Next hunk" })
		nmap("<leader>gp", gs.prev_hunk, { buffer = bufnr, desc = "Previous hunk" })
		nmap("<leader>gq", gs.setqflist, { buffer = bufnr, desc = "Hunks to qflist" })
		nmap("<leader>gR", gs.reset_buffer, { buffer = bufnr, desc = "Reset buffer" })
		nmap("<leader>gS", gs.stage_buffer, { buffer = bufnr, desc = "Stage buffer" })
		nmap("<leader>gs", gs.stage_hunk, { buffer = bufnr, desc = "Stage hunk" })
		nmap("<leader>gr", gs.reset_hunk, { buffer = bufnr, desc = "Reset hunk" })
		nmap("<leader>gu", gs.undo_stage_hunk, { buffer = bufnr, desc = "Undo stage hunk" })
		nmap("<leader>gw", gs.toggle_word_diff, { buffer = bufnr, desc = "Toggle word diff" })

		vim.keymap.set("v", "<leader>gs", function()
			gs.stage_hunk(hunk_range())
		end, { buffer = bufnr, desc = "Stage hunk" })

		vim.keymap.set("v", "<leader>gr", function()
			gs.reset_hunk(hunk_range())
		end, { buffer = bufnr, desc = "Reset hunk" })

		vim.keymap.set({ "o", "x" }, "ih", "<cmd>Gitsigns select_hunk<cr>", {
			buffer = bufnr,
			desc = "Git hunk",
		})
	end,
})

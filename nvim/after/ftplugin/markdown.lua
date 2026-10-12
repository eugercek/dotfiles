-- Insert a heading relative to the one above, like >> << == for indent
local insert_heading = require("config.utils").insert_heading
vim.keymap.set("n", "<localleader>=", function()
	insert_heading(0)
end, { buffer = true, desc = "Heading (same level)" })
vim.keymap.set("n", "<localleader>>", function()
	insert_heading(1)
end, { buffer = true, desc = "Heading (one level deeper)" })
vim.keymap.set("n", "<localleader><", function()
	insert_heading(-1)
end, { buffer = true, desc = "Heading (one level up)" })

-- Preview in browser via pandoc; re-renders on save, refresh the tab to update
local function render_preview()
	local out = vim.fn.tempname() .. ".html"
	vim.b.preview_html = vim.b.preview_html or out
	vim.system({
		"pandoc", "-f", "gfm", "-s", "-o", vim.b.preview_html,
		"--metadata", "pagetitle=" .. vim.fn.expand("%:t"),
		"-c", "https://cdn.jsdelivr.net/npm/github-markdown-css/github-markdown.min.css",
		-- base href so relative images resolve from the file's dir, not /tmp
		"-V", ('header-includes=<base href="file://%s/"><style>.markdown-body{max-width:980px;margin:0 auto;padding:45px}@media(prefers-color-scheme:dark){body{background:#0d1117}}</style>'):format(vim.fn.expand("%:p:h")),
		"-V", "include-before=<article class=\"markdown-body\">",
		"-V", "include-after=</article>",
	}, { stdin = vim.api.nvim_buf_get_lines(0, 0, -1, false) }):wait()
end
vim.keymap.set("n", "<localleader>p", function()
	render_preview()
	vim.ui.open(vim.b.preview_html)
	vim.api.nvim_create_autocmd("BufWritePost", {
		buffer = 0,
		group = vim.api.nvim_create_augroup("md_preview_" .. vim.api.nvim_get_current_buf(), {}),
		callback = render_preview,
	})
end, { buffer = true, desc = "Preview in browser" })

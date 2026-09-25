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

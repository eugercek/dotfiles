vim.pack.add({
	{ src = "https://github.com/echasnovski/mini-git" },
})

-- Only used for committing: nvim can't be git's editor itself (no --remote-wait yet),
-- mini.git makes :Git commit open the message in this nvim (:wq commits, :q! aborts)
require("mini.git").setup()

-- Commit message draft, lives in .git/ so it's never committed
local function draft_path()
	local git_dir = vim.trim(vim.fn.system("git rev-parse --absolute-git-dir"))
	return vim.v.shell_error == 0 and vim.fs.joinpath(git_dir, "COMMIT_DRAFT") or nil
end

nmap("<leader>ge", function()
	local path = draft_path()
	if not path then return vim.notify("Not a git repo", vim.log.levels.WARN) end
	vim.cmd("botright 10split " .. vim.fn.fnameescape(path))
	vim.bo.filetype = "gitcommit"
end, { desc = "Edit commit draft" })

nmap("<leader>gc", function()
	local path = draft_path()
	if path and vim.uv.fs_stat(path) then
		vim.cmd("Git commit --verbose --edit -F " .. vim.fn.fnameescape(path))
	else
		vim.cmd("Git commit --verbose")
	end
end, { desc = "Commit" })

-- Drop the draft once it's been committed
vim.api.nvim_create_autocmd("User", {
	pattern = "MiniGitCommandDone",
	callback = function(ev)
		if ev.data.git_subcommand ~= "commit" or ev.data.exit_code ~= 0 then return end
		local path = draft_path()
		if path then os.remove(path) end
	end,
})

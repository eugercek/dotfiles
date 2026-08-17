vim.pack.add({
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
})

-- stylua: ignore
local languages = {
	"bash",
	"c",
	"diff",
	"dockerfile",
	"editorconfig",
	"go", "gomod", "gosum", "gowork",
    -- I use git commit verbose and currently git commit does not have folding so don't install it
	"git_config", "git_rebase", "gitattributes", "gitignore",
	"javascript", "tsx", "typescript",
	"json",
	"lua",
	"markdown", "markdown_inline",
	"python",
	"query",
	"sql",
	"terraform",
	"toml",
	"tmux",
	"vim",
	"vimdoc",
	"asm",
	"regex", "comment", "printf", "luadoc", "luap",
	"make", "cmake",
	"yaml", "ini", "xml", "ssh_config", "hcl",
	"proto", "nginx", "promql", "gotmpl",
	"csv", "jq",
	"rust",
  "html",
  "latex",
}

local enabled = {}
for _, language in ipairs(languages) do
	enabled[language] = true
end

local treesitter = require("nvim-treesitter")

treesitter.setup({})
treesitter.install(languages)

vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function(args)
		local language = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
		if not enabled[language] then
			return
		end

		vim.treesitter.start(args.buf, language)
		vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})

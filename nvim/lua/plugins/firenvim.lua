-- Neovim inside browser textareas. This is only half the setup - the Firenvim
-- extension has to be installed in Brave too, otherwise nothing happens.
--
-- takeover = "never": no textarea turns into nvim on its own, I hit <C-e> in
-- the page when I actually want it.

vim.g.firenvim_config = {
	globalSettings = { alt = "all" },
	localSettings = {
		[".*"] = {
			cmdline = "neovim",
			content = "text",
			priority = 0,
			takeover = "never",
		},
	},
}

-- firenvim needs a post-install step that writes the native messaging
-- manifests. vim.pack has no build hook, so hang it off PackChanged.
--
-- Bug workaround: on macOS firenvim writes Brave's manifest into Chrome's
-- directory (get_brave_manifest_dir_path returns the Chrome path when
-- has('mac')), but Brave reads its own. Link it across by hand.
local function copy_brave_manifest()
	local support = vim.fs.normalize("~/Library/Application Support")
	local src = support .. "/Google/Chrome/NativeMessagingHosts/firenvim.json"
	local dst = support .. "/BraveSoftware/Brave-Browser/NativeMessagingHosts/firenvim.json"

	if vim.uv.fs_stat(src) == nil then
		vim.notify("firenvim: " .. src .. " missing, nothing to copy for Brave", vim.log.levels.WARN)
		return
	end

	-- a real copy, not a symlink: chromium doesn't reliably follow symlinked
	-- native messaging manifests
	vim.fn.mkdir(vim.fs.dirname(dst), "p")
	vim.uv.fs_unlink(dst)
	local ok, err = vim.uv.fs_copyfile(src, dst)
	if not ok then
		vim.notify("firenvim: copying manifest for Brave failed: " .. tostring(err), vim.log.levels.ERROR)
	end
end

vim.api.nvim_create_autocmd("PackChanged", {
	group = vim.api.nvim_create_augroup("firenvim_build", { clear = true }),
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if name ~= "firenvim" or (kind ~= "install" and kind ~= "update") then
			return
		end

		-- on "install" the plugin isn't sourced yet, so defer until it is
		vim.schedule(function()
			vim.fn["firenvim#install"](0)
			copy_brave_manifest()
		end)
	end,
})

vim.pack.add({
	{ src = "https://github.com/glacambre/firenvim" },
})

-- Everything below only applies to the nvim instances the browser spawns.
if not vim.g.started_by_firenvim then
	return
end

-- The canvas renderer only sees fonts installed system-wide, so ghostty's
-- app-bundled JetBrains Mono is out - this is the brew cask version
-- (font-jetbrains-mono-nerd-font), needed for the nerd font glyphs in blink's
-- completion menu. Menlo as a fallback in case the cask ever goes missing.
vim.o.guifont = "JetBrainsMono Nerd Font:h18,Menlo:h18"

vim.o.laststatus = 0
vim.o.number = false
vim.o.relativenumber = false
vim.o.signcolumn = "no"
vim.o.wrap = true
vim.o.linebreak = true

-- Give focus back to the page without closing the buffer
vim.keymap.set("n", "<Esc><Esc>", "<cmd>call firenvim#focus_page()<cr>", { desc = "Back to the page" })

-- Buffers are named <host>_<url>_<id>.txt, so match on the host
vim.api.nvim_create_autocmd({ "BufEnter", "BufNewFile" }, {
	group = vim.api.nvim_create_augroup("firenvim_filetypes", { clear = true }),
	pattern = { "github.com_*.txt", "gitlab.com_*.txt" },
	callback = function()
		vim.bo.filetype = "markdown"
	end,
})

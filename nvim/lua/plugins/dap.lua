vim.pack.add({
	{ src = "https://github.com/mfussenegger/nvim-dap" },
	{ src = "https://github.com/nvim-neotest/nvim-nio" },
	{ src = "https://github.com/rcarriga/nvim-dap-ui" },
})

local dap = require("dap")
local dapui = require("dapui")

-- lldb-dap ships with the Xcode Command Line Tools but isn't on PATH,
-- so fall back to resolving it through xcrun.
local lldb_dap = vim.fn.exepath("lldb-dap")
if lldb_dap == "" then
	lldb_dap = vim.trim(vim.fn.system({ "xcrun", "-f", "lldb-dap" }))
end

-- If macOS asks for a password on every debug start ("Developer Tools
-- Access..."), run `sudo DevToolsSecurity -enable` once and it stops.
dap.adapters.lldb = {
	type = "executable",
	command = lldb_dap,
	name = "lldb",
}

-- Remember: compile with `cc -g -O0 main.c -o main`.
-- No -g = breakpoints won't map to source lines, and anything
-- above -O0 steps weirdly because variables get optimized out.
dap.configurations.c = {
	{
		name = "Launch executable",
		type = "lldb",
		request = "launch",
		program = function()
			return vim.fn.input("Executable: ", vim.fn.getcwd() .. "/", "file")
		end,
		args = function()
			return vim.split(vim.fn.input("Args: "), " +", { trimempty = true })
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
	},
	{
		name = "Attach to process",
		type = "lldb",
		request = "attach",
		pid = require("dap.utils").pick_process,
	},
}
dap.configurations.cpp = dap.configurations.c

dapui.setup()

-- Open/close the UI automatically with the debug session.
dap.listeners.after.event_initialized["dapui"] = dapui.open
dap.listeners.before.event_terminated["dapui"] = dapui.close
dap.listeners.before.event_exited["dapui"] = dapui.close

vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn" })
vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticInfo", linehl = "CursorLine" })

nmap("<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
nmap("<leader>dB", function()
	dap.set_breakpoint(vim.fn.input("Condition: "))
end, { desc = "Conditional breakpoint" })
nmap("<leader>dc", dap.continue, { desc = "Start/continue" })
nmap("<leader>dC", dap.run_to_cursor, { desc = "Run to cursor" })
nmap("<leader>do", dap.step_over, { desc = "Step over" })
nmap("<leader>di", dap.step_into, { desc = "Step into" })
nmap("<leader>dO", dap.step_out, { desc = "Step out" })
nmap("<leader>dl", dap.run_last, { desc = "Run last" })
-- REPL cheatsheet: plain input is evaluated as a C expression (`u.x`),
-- lldb commands need a backtick prefix:
--   `p/x u.x                    hex
--   `p/t u.x                    binary
--   `frame variable -f b u     whole struct/union in binary
--   `memory read -f y -c 16 &u  raw hex dump
nmap("<leader>dr", dap.repl.toggle, { desc = "Toggle REPL" })
nmap("<leader>dq", dap.terminate, { desc = "Terminate" })
nmap("<leader>du", dapui.toggle, { desc = "Toggle UI" })
vim.keymap.set({ "n", "v" }, "<leader>dh", dapui.eval, { desc = "Evaluate expression" })

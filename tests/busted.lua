#!/usr/bin/env -S nvim -l

vim.env.LAZY_STDPATH = ".tests"
load(vim.fn.system("curl -s https://raw.githubusercontent.com/folke/lazy.nvim/main/bootstrap.lua"))()

require("lazy.minit").busted({
	spec = {
		{ "https://github.com/lunarmodules/luacov" },
		{ dir = "deps/nvim-surround", config = true },
		-- Not adding Which Key, because it is not possible to use it in tests.
	},
})

-- Trigger luacov to generate the report.
-- It seems necessary to call this function as it doesn’t trigger automatically.
local luacov_success, runner = pcall(require, "luacov.runner")
if luacov_success and runner.initialized then
	runner.shutdown()
end

local main = require("nvim-surround-neo")
local test_helpers = require("tests.helpers")

describe("nvim-surround-neo", function()
	-- it("deletes brackets", function()
	-- 	main.setup()
	-- 	local buf = test_helpers.create_buf({ "(foo)" })
	--
	-- 	test_helpers.execute_keys("llgsd)", "x")
	-- 	local lines = vim.api.nvim_buf_get_lines(buf, 0, 1, true)
	-- 	assert.are.same({ "foo" }, lines)
	--
	-- 	vim.api.nvim_buf_delete(buf, { force = true })
	-- end)
end)

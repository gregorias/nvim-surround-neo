--- Busted tests for nvim-surround-neo.table-utils.
local table_utils = require("nvim-surround-neo.table-utils")

describe("nvim-surround-neo.table-utils", function()
	describe("filter", function()
		local filter = table_utils.filter
		it("works", function()
			assert.are.same(
				{ "hello", bar = "hello" },
				filter(function(v)
					return v == "hello"
				end, { "hello", foo = "foo", bar = "hello" })
			)
		end)
	end)
end)

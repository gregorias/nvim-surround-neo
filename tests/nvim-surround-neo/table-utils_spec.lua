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

	describe("map", function()
		local map = table_utils.map
		it("maps over lists", function()
			assert.are.same(
				{ 3, 6, 9 },
				map(function(k, v)
					return v * 2 + k
				end, { 1, 2, 3 })
			)
		end)
		it("maps over key-value tables", function()
			assert.are.same(
				{ foo = 2, bar = 4 },
				map(function(_, v)
					return v * 2
				end, { foo = 1, bar = 2 })
			)
		end)
		it("returns empty table for empty input", function()
			assert.are.same(
				{},
				map(function(_, v)
					return v
				end, {})
			)
		end)
	end)
end)

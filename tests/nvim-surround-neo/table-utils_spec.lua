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

	describe("values", function()
		local values = table_utils.values
		it("returns only the values of an array-style table", function()
			assert.are.same({ 1, 2, 3 }, values({ 1, 2, 3 }))
		end)
		it("returns only the values of a key-value table", function()
			local t = { foo = 42, bar = 17 }
			local vals = values(t)
			table.sort(vals)
			assert.are.same({ 17, 42 }, vals)
		end)
		it("returns empty table for empty input", function()
			assert.are.same({}, values({}))
		end)
		it("returns all values regardless of keys", function()
			local t = { a = 1, b = 2, [10] = 3 }
			local vals = values(t)
			table.sort(vals)
			assert.are.same({ 1, 2, 3 }, vals)
		end)
	end)
end)

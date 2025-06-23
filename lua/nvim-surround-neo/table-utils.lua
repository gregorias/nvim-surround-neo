--- Table utilities.
local M = {}

--- Filters a table by its values.
---
---@generic V
---@param predicate fun(V): boolean
---@param t table<any, V>
---@return table<any, V>
M.filter = function(predicate, t)
	local result = {}
	for key, value in pairs(t) do
		if predicate(value) then
			result[key] = value
		end
	end
	return result
end

--- Maps a table to another table.
---
---@generic K, V, R
---@param func fun(K, V): R
---@param t table<K, V>
---@return table<K, R>
M.map = function(func, t)
	local result = {}
	for key, value in pairs(t) do
		result[key] = func(key, value)
	end
	return result
end

return M

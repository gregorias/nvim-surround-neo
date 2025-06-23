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

return M

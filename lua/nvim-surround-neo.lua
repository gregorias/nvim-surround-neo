local M = {}

-- TODO: Move to a dedicated module.
--- Gets the keys of a table.
---
---@param t table
---@return string[]
function get_keys(t)
	local keys = {}
	for key in pairs(t) do
		table.insert(keys, key)
	end
	return keys
end

function filter(t, predicate)
	local result = {}
	for key, value in pairs(t) do
		if predicate(key, value) then
			result[key] = value
		end
	end
	return result
end

function map(t, func)
	local result = {}
	for key, value in pairs(t) do
		result[key] = func(key, value)
	end
	return result
end

function map_to_list(t, func)
	local result = {}
	for key, value in pairs(t) do
		table.insert(result, func(key, value))
	end
	return result
end

local labels = {
	["("] = "( … )",
	[")"] = "(…)",
	["["] = "[ … ]",
	["]"] = "[…]",
	["{"] = "{ … }",
	["}"] = "{…}",
	["<"] = "< … >",
	[">"] = "<…>",
	['"'] = '"…"',
	["'"] = "'…'",
	["`"] = "`…`",
}

function get_labeled_chars(action)
	assert(action == "delete", "Only 'delete' action is supported for now.")

	local surround_config = require("nvim-surround.config")
	local surrounds = surround_config.get_opts().surrounds
	surrounds = filter(surrounds, function(key, surround)
		return surround.delete ~= nil
	end)

	return map(surrounds, function(key, _)
		local label = labels[key] or key
		return label
	end)
end

---@return wk.Spec[]
local expand_delete_surrounds = function()
	local surround_config = require("nvim-surround.config")
	-- TODO: Use aliases as well.
	local labeled_chars = get_labeled_chars("delete")

	return map_to_list(labeled_chars, function(key, label)
		return {
			key,
			function()
				local cache = require("nvim-surround.cache")
				cache.delete = { char = key, count = vim.v.count1 }
				vim.go.operatorfunc = "v:lua.require'nvim-surround'.delete_callback"
				vim.api.nvim_feedkeys("g@l", "in", false)
			end,
			desc = label,
			silent = true,
		}
	end)
end

M.setup = function()
	local which_key = require("which-key")
	local surround = require("nvim-surround")
	which_key.add({
		"gsD",
		group = "Delete a surrounding pair",
		expand = expand_delete_surrounds,
	})
end

return M

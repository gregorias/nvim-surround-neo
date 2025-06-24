local M = {}

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

---@return table<string, any>
function get_labeled_chars(action)
	assert(action == "delete", "Only 'delete' action is supported for now.")

	local filter = require("nvim-surround-neo.table-utils").filter

	local surround_config = require("nvim-surround.config")
	local surrounds = surround_config.get_opts().surrounds
	surrounds = filter(function(surround)
		return surround.delete ~= nil
	end, surrounds)

	local map = require("nvim-surround-neo.table-utils").map
	return map(function(key, _)
		local label = labels[key] or key
		return label
	end, surrounds)
end

---@return wk.Spec[]
local expand_delete_surrounds = function()
	-- TODO: Use aliases as well.
	local labeled_chars = get_labeled_chars("delete")

	local map = require("nvim-surround-neo.table-utils").map
	local values = require("nvim-surround-neo.table-utils").values

	return values(map(function(key, label)
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
	end, labeled_chars))
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

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
	["t"] = "<tag>…</tag>",
	["T"] = "<tag>…</tag>",
	["f"] = "foo(…)",
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
	return map(function(key, v)
		local label = labels[key] or key
		return label
	end, surrounds)
end

---@return nsn.KeymapSpec[]
local expand_delete_surrounds = function()
	-- TODO: Use aliases as well.
	local labeled_chars = get_labeled_chars("delete")

	local map = require("nvim-surround-neo.table-utils").map
	local values = require("nvim-surround-neo.table-utils").values

	return values(map(function(key, label)
		return {
			lhs = key,
			rhs = function()
				local cache = require("nvim-surround.cache")
				cache.delete = { char = key, count = vim.v.count1 }
				vim.go.operatorfunc = "v:lua.require'nvim-surround'.delete_callback"
				vim.api.nvim_feedkeys("g@l", "in", false)
			end,
			desc = label,
		}
	end, labeled_chars))
end

local default_opts = {
	keymaps = {
		delete = "gsd",
	},
}

--- Adds a label for an nvim-surround key.
---
---@param key string
---@param label string
---@return nil
M.add_surround_label = function(key, label)
	labels[key] = label
end

M.setup = function()
	local surround = require("nvim-surround")
	local wk_status, wk = pcall(require, "which-key")
	local keymap_registry = nil
	if wk_status then
		keymap_registry = require("nvim-surround-neo.keymaps").create_wk_registry(wk)
	else
		keymap_registry = require("nvim-surround-neo.keymaps").plain_registry
	end
	keymap_registry({
		lhs = default_opts.keymaps.delete,
		group = "Delete a surrounding pair",
		expand = expand_delete_surrounds,
	})
end

return M

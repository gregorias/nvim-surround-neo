--- A module with the keymap registry interface for defining keymaps.
---
--- Although this plugin requires Which Key, this is important for testability.

---@module "nvim-surround-neo.keymaps"
local M = {}

---@class nsn.KeymapSpec
---@field lhs string
---@field rhs function(): nil
---@field desc string

---@class nsn.KeymapGroupSpec
---@field lhs string
---@field group string
---@field expand fun(): nsn.KeymapSpec[]

---@alias nsn.KeymapRegistry fun(mappings: nsn.KeymapGroupSpec | nsn.KeymapGroupSpec[])

--- Replaces terminal keycodes in an input character.
---
---@param char string @The input character.
---@return string @The formatted character.
---@nodiscard
local replace_termcodes = function(char)
	-- Do nothing to ASCII or UTF-8 characters.
	if #char == 1 or char:byte() >= 0x80 then
		return char
	end
	-- Otherwise assume the string is a terminal keycode.
	return vim.api.nvim_replace_termcodes(char, true, true, true)
end

--- Gets a character input from the user.
---
---@return string|nil The input character, or nil if an escape character is pressed.
---@nodiscard
local get_char = function()
	local ok, char = pcall(vim.fn.getcharstr)
	-- Return nil if input is cancelled (e.g., <C-c> or <Esc>).
	if not ok or char == "\27" then
		return nil
	end
	return replace_termcodes(char)
end

---@param mapping nsn.KeymapSpec
---@return wk.Spec
local spec_to_wk_spec = function(mapping)
	return {
		lhs = mapping.lhs,
		rhs = mapping.rhs,
		desc = mapping.desc,
		silent = true,
	}
end

---@param mapping nsn.KeymapGroupSpec
---@return wk.Spec
local group_spec_to_wk_spec = function(mapping)
	return {
		lhs = mapping.lhs,
		group = mapping.group,
		expand = function()
			return vim.tbl_map(spec_to_wk_spec, mapping.expand())
		end,
	}
end

---@type nsn.KeymapRegistry
M.plain_registry = function(mappings)
	if mappings.lhs ~= nil then
		mappings = { mappings }
	end

	for _, mapping in ipairs(mappings) do
		vim.keymap.set("n", mapping.lhs, function()
			local chr = get_char()
			if not chr then
				return nil
			end

			local submappings = mapping.expand()
			for _, submapping in ipairs(submappings) do
				if submapping.lhs == chr then
					return submapping.rhs()
				end
			end
		end, { desc = mapping.group, silent = true })
	end
end

---@param wk any
---@return nsn.KeymapRegistry
M.create_wk_registry = function(wk)
	return function(mappings)
		if mappings.lhs ~= nil then
			mappings = { mappings }
		end

		wk.add(vim.tbl_map(group_spec_to_wk_spec, mappings))
	end
end

return M

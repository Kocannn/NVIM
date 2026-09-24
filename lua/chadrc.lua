-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.base46 = {
	theme = "solarized_dark",
	transparency = true,

	hl_override = {
		Comment = { italic = true },
		["@comment"] = { italic = true },
		MarkdownCode = { bg = "NONE" },
		MarkdownCodeBlock = { bg = "NONE" },
		["@markup.raw.block.markdown"] = { bg = "NONE" },
		["@markup.raw.markdown_inline"] = { bg = "NONE" },
	},
}

M.nvdash = {
	load_on_startup = true,
	header = function()
		return {
			"        _/      _/      _/_/_/_/_/    _/_/    _/_/_/    ",
			"       _/_/    _/          _/      _/    _/  _/    _/   ",
			"      _/  _/  _/          _/      _/    _/  _/    _/    ",
			"     _/    _/_/          _/      _/    _/  _/    _/     ",
			"   _/      _/          _/        _/_/    _/_/_/       ",
			"",
		}
	end,
}

M.ui = {
	tabufline = {
		lazyload = false,
	},
	-- statusline = {
	-- 	-- theme = "minimal",
	-- 	-- separator_style = "round",
	-- },
}

return M

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

		-- Floating windows & borders
		FloatBorder = { fg = "blue" },
		NormalFloat = { bg = "NONE" },

		-- Cursor line
		CursorLine = { bg = "one_bg" },
		CursorLineNr = { fg = "yellow", bold = true },

		-- Window separator berwarna
		WinSeparator = { fg = "blue", bold = true },

		-- Diagnostic virtual text lebih lembut
		DiagnosticVirtualTextError = { fg = "red", bg = "NONE", italic = true },
		DiagnosticVirtualTextWarn = { fg = "yellow", bg = "NONE", italic = true },
		DiagnosticVirtualTextInfo = { fg = "blue", bg = "NONE", italic = true },
		DiagnosticVirtualTextHint = { fg = "green", bg = "NONE", italic = true },
	},

	hl_add = {
		-- Custom highlight groups untuk statusline
		St_Mode = { fg = "black", bg = "blue", bold = true },
		St_ModeInsert = { fg = "black", bg = "green", bold = true },
		St_ModeVisual = { fg = "black", bg = "purple", bold = true },
		St_ModeCommand = { fg = "black", bg = "yellow", bold = true },
		St_ModeReplace = { fg = "black", bg = "red", bold = true },
	},
}

M.nvdash = {
	load_on_startup = true,
	header = function()
		return {
			"",
			"",
			"    ⣴⣶⣤⡤⠦⣤⣀⣤⠆     ⣈⣭⣿⣶⣿⣦⣼⣆         ",
			"     ⠉⠻⢿⣿⠿⣿⣿⣶⣦⠤⠶⣿⠿⣿⣿⣿⣿⣶⣾⣿⡿⠋       ",
			"      ⠈⢿⣿⣟⠦ ⣾⣿⣿⣷    ⠻�eli⠿⢿⣿⡧⠄      ",
			"       ⠈⠻⣿⣿⣦⣌⣡⣿⣷⣿⣿⢂    ⣿⣿⣿⣿⣿⡇      ",
			"         ⠻⣿⣿⣿⣿⣿⣿⣿⣿⡇  ⠄⠐ ⣿⣿⣿⡿⠄      ",
			"          ⠤⣌⣿⣿⣿⣿⣿⣿⡀           ",
			"        ⠁⠤⣤⣤⣤⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡀          ",
			"            ⠉⠻⣿⣿⣿⣿⣿⣿⣿⡇          ",
			"              ⠈⣿⣿⣿⣿⣿⣿⡇          ",
			"",
			"       ⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿        ",
			"         ⠈⠉⠛⠋⠉⠁   ⠈⠁⠉          ",
			"",
			"        N  T  O  D     N  V  I  M        ",
			"",
		}
	end,

	buttons = {
		{ txt = "  Find File", keys = "ff", cmd = "Telescope find_files" },
		{ txt = "  Recent Files", keys = "fo", cmd = "Telescope oldfiles" },
		{ txt = "󰈭  Find Word", keys = "fs", cmd = "Telescope live_grep" },
		{ txt = "  Bookmarks", keys = "ma", cmd = "Telescope marks" },
		{ txt = "  Themes", keys = "th", cmd = "lua require('nvchad.themes').open()" },
		{ txt = "  Mappings", keys = "ch", cmd = "NvCheatsheet" },

		{ txt = "─", hl = "NvDashFooter", no_gap = true, rep = true },

		{
			txt = function()
				local stats = require("lazy").stats()
				local ms = math.floor(stats.startuptime * 100 + 0.5) / 100
				return "  Loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms"
			end,
			hl = "NvDashFooter",
			no_gap = true,
		},
	},
}

M.ui = {
	tabufline = {
		lazyload = false,
	},
}

return M

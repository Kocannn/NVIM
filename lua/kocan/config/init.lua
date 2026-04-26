local M = {}

M.core = {
	mapleader = " ",
	base46_cache = vim.fn.stdpath("data") .. "/base46/",
}

M.plugins = {
	modules = {
		"kocan.plugins.specs.core",
		"kocan.plugins.specs.lsp",
		"kocan.plugins.specs.completion",
		"kocan.plugins.specs.ai",
		"kocan.plugins.specs.search",
		"kocan.plugins.specs.ui",
	},
}

return M

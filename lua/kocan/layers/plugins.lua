local M = {}

function M.setup()
	local lazy_config = require("kocan.plugins.configs.lazy")

	require("lazy").setup({
		{ import = "kocan.plugins" },
	}, lazy_config)

	dofile(vim.g.base46_cache .. "defaults")
	dofile(vim.g.base46_cache .. "statusline")
end

return M

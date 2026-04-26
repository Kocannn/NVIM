local M = {}

function M.setup()
	require("kocan.core.options")
	require("kocan.core.autocmds")

	vim.schedule(function()
		require("kocan.core.keymaps")
	end)
end

return M

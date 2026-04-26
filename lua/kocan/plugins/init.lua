local modules = require("kocan.config").plugins.modules

local plugins = {}

for _, module in ipairs(modules) do
	local ok, spec = pcall(require, module)
	if ok and type(spec) == "table" then
		vim.list_extend(plugins, spec)
	else
		vim.schedule(function()
			vim.notify("Failed loading plugin module: " .. module, vim.log.levels.WARN)
		end)
	end
end

return plugins

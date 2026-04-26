local modules = {
	"kocan.plugins.specs.core",
	"kocan.plugins.specs.lsp",
	"kocan.plugins.specs.completion",
	"kocan.plugins.specs.ai",
	"kocan.plugins.specs.search",
	"kocan.plugins.specs.ui",
}

local plugins = {}

for _, module in ipairs(modules) do
	vim.list_extend(plugins, require(module))
end

return plugins

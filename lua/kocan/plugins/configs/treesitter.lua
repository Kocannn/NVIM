pcall(function()
	dofile(vim.g.base46_cache .. "syntax")
	dofile(vim.g.base46_cache .. "treesitter")
end)

local M = {}

--- Incremental selection menggunakan vim.treesitter native API
--- Karena nvim-treesitter branch "main" tidak lagi support module incremental_selection
local node_stack = {}

local function get_node_range(node)
	local sr, sc, er, ec = node:range()
	return sr, sc, er, ec
end

local function select_node(node)
	if not node then
		return
	end
	local sr, sc, er, ec = get_node_range(node)
	-- Set visual selection
	vim.fn.setpos("'<", { 0, sr + 1, sc + 1, 0 })
	vim.fn.setpos("'>", { 0, er + 1, ec, 0 })
	vim.cmd("normal! gv")
end

local function init_selection()
	local node = vim.treesitter.get_node()
	if not node then
		return
	end
	node_stack = { node }
	select_node(node)
end

local function node_incremental()
	local current = node_stack[#node_stack]
	if not current then
		return init_selection()
	end
	local parent = current:parent()
	if parent then
		table.insert(node_stack, parent)
		select_node(parent)
	end
end

local function scope_incremental()
	local current = node_stack[#node_stack]
	if not current then
		return init_selection()
	end
	-- Naik terus sampai ketemu scope node (function, block, class, dll)
	local scope_types = {
		["function"] = true,
		["function_definition"] = true,
		["function_declaration"] = true,
		["method_definition"] = true,
		["method_declaration"] = true,
		["arrow_function"] = true,
		["if_statement"] = true,
		["for_statement"] = true,
		["for_in_statement"] = true,
		["while_statement"] = true,
		["do_statement"] = true,
		["block"] = true,
		["chunk"] = true,
		["program"] = true,
		["class_declaration"] = true,
		["class_definition"] = true,
		["module"] = true,
		["try_statement"] = true,
		["switch_statement"] = true,
		["match_expression"] = true,
	}
	local node = current:parent()
	while node do
		if scope_types[node:type()] then
			table.insert(node_stack, node)
			select_node(node)
			return
		end
		node = node:parent()
	end
end

local function node_decremental()
	if #node_stack > 1 then
		table.remove(node_stack)
		select_node(node_stack[#node_stack])
	end
end

function M.setup()
	-- Install parsers via nvim-treesitter
	local parsers = {
		"lua", "luadoc", "printf", "vim", "vimdoc",
		"go", "proto", "blade", "python",
		"markdown", "markdown_inline", "sql",
		"php", "php_only", "html", "css", "dockerfile",
		"javascript", "typescript", "tsx", "json", "yaml",
	}

	-- Auto-install missing parsers saja
	vim.schedule(function()
		local to_install = {}
		for _, p in ipairs(parsers) do
			local ok = pcall(vim.treesitter.language.inspect, p)
			if not ok then
				table.insert(to_install, p)
			end
		end
		if #to_install > 0 then
			pcall(vim.cmd, "TSInstall " .. table.concat(to_install, " "))
		end
	end)

	-- Blade parser config
	pcall(function()
		local parser_config = require("nvim-treesitter.parsers")
		if parser_config.get_parser_configs then
			local configs = parser_config.get_parser_configs()
			configs.blade = {
				install_info = {
					url = "https://github.com/EmranMR/tree-sitter-blade",
					files = { "src/parser.c" },
					branch = "main",
				},
				filetype = "blade",
			}
		end
	end)

	-- Enable treesitter highlight & indent via Neovim native API
	vim.api.nvim_create_autocmd("FileType", {
		callback = function()
			pcall(vim.treesitter.start)
		end,
	})

	-- Incremental selection keymaps
	vim.keymap.set("n", "<CR>", function()
		init_selection()
	end, { desc = "Treesitter: Start selection" })

	vim.keymap.set("v", "<CR>", function()
		node_incremental()
	end, { desc = "Treesitter: Expand to parent node" })

	vim.keymap.set("v", "<TAB>", function()
		scope_incremental()
	end, { desc = "Treesitter: Expand to scope" })

	vim.keymap.set("v", "<BS>", function()
		node_decremental()
	end, { desc = "Treesitter: Shrink selection" })
end

return M

local M = {}
local map = vim.keymap.set

-- export on_attach & capabilities
-- This section (M.on_attach, M.on_init, M.capabilities)
-- stays exactly the same.
M.on_attach = function(_, bufnr)
	local function opts(desc)
		return { buffer = bufnr, desc = "LSP " .. desc }
	end

	map("n", "gD", vim.lsp.buf.declaration, opts("Go to declaration"))
	map("n", "gd", vim.lsp.buf.definition, opts("Go to definition"))
	map("n", "gi", vim.lsp.buf.implementation, opts("Go to implementation"))
	map("n", "<leader>sh", vim.lsp.buf.signature_help, opts("Show signature help"))
	map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts("Add workspace folder"))
	map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts("Remove workspace folder"))

	map("n", "<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, opts("List workspace folders"))

	map("n", "<leader>D", vim.lsp.buf.type_definition, opts("Go to type definition"))
	map("n", "<leader>ra", require("nvchad.lsp.renamer"), opts("NvRenamer"))

	map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts("Code action"))
	map("n", "gr", vim.lsp.buf.references, opts("Show references"))
end

-- disable semanticTokens
M.on_init = function(client, _)
	if client.supports_method("textDocument/semanticTokens") then
		client.server_capabilities.semanticTokensProvider = nil
	end
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()

M.capabilities.textDocument.completion.completionItem = {
	documentationFormat = { "markdown", "plaintext" },
	snippetSupport = true,
	preselectSupport = true,
	insertReplaceSupport = true,
	labelDetailsSupport = true,
	deprecatedSupport = true,
	commitCharactersSupport = true,
	tagSupport = { valueSet = { 1 } },
	resolveSupport = {
		properties = {
			"documentation",
			"detail",
			"additionalTextEdits",
		},
	},
}

M.servers = {
	"html",
	"cssls",
	"buf_ls",
	"ts_ls",
	"lua_ls",
	"gopls",
	"pbls",
	-- "stimulus_ls",
	"prosemd_lsp",
	"golangci_lint_ls",
	"laravel_ls",
	"ast_grep",
	-- "intelephense",
}

---
-- REFACTORED SECTION
---
M.defaults = function()
	dofile(vim.g.base46_cache .. "lsp")
	require("nvchad.lsp").diagnostic_config()

	-- Shared/default configuration for all servers.
	local default_config = {
		on_attach = M.on_attach,
		on_init = M.on_init,
		capabilities = M.capabilities,
	}

	local configured_servers = {}

	local function enable_server(server_name, extra_config)
		if not server_name or configured_servers[server_name] then
			return
		end

		local config = default_config
		if extra_config then
			config = vim.tbl_deep_extend("force", default_config, extra_config)
		end

		vim.lsp.config(server_name, config)
		vim.lsp.enable(server_name)
		configured_servers[server_name] = true
	end

	-- lua_ls specific override.
	local lua_ls_config = {
		settings = {
			Lua = {
				diagnostics = {
					globals = { "vim" },
				},
				workspace = {
					library = {
						vim.fn.expand("$VIMRUNTIME/lua"),
						vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"),
						vim.fn.stdpath("data") .. "/lazy/ui/nvchad_types",
						vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy",
						"${3rd}/luv/library",
					},
					maxPreload = 100000,
					preloadFileSize = 10000,
				},
			},
		},
	}

	for _, lsp in ipairs(M.servers) do
		if lsp == "lua_ls" then
			enable_server(lsp, lua_ls_config)
		else
			enable_server(lsp)
		end
	end

	-- Also enable servers installed by Mason, including newly installed ones.
	local ok_registry, mason_registry = pcall(require, "mason-registry")
	local ok_mappings, mason_mappings = pcall(require, "mason-lspconfig.mappings.server")

	if not (ok_registry and ok_mappings) then
		return
	end

	local function enable_server_from_package(package_name)
		local server_name = mason_mappings.package_to_lspconfig[package_name]
		if not server_name then
			return
		end

		if server_name == "lua_ls" then
			enable_server(server_name, lua_ls_config)
		else
			enable_server(server_name)
		end
	end

	for _, pkg in ipairs(mason_registry.get_installed_packages()) do
		enable_server_from_package(pkg.name)
	end

	mason_registry:on("package:install:success", function(pkg)
		vim.schedule(function()
			enable_server_from_package(pkg.name)
		end)
	end)
end

return M

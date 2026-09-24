local M = {}
local map = vim.keymap.set

-- export on_attach & capabilities
-- This section (M.on_attach, M.on_init, M.capabilities)
-- stays exactly the same.
M.on_attach = function(client, bufnr)
	local function opts(desc)
		return { buffer = bufnr, desc = "LSP " .. desc }
	end

	-- Enable inlay hints if supported
	if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	end

	map("n", "<leader>lh", function()
		if vim.lsp.inlay_hint then
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
		end
	end, opts("Toggle Inlay Hints"))

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

-- Merge capabilities dari cmp-nvim-lsp jika tersedia
local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if ok then
	M.capabilities = vim.tbl_deep_extend("force", M.capabilities, cmp_lsp.default_capabilities())
end

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

-- Server yang di-manage oleh Mason (ensure_installed)
M.servers = {
	"html",
	"cssls",
	"buf_ls",
	"ts_ls",
	"lua_ls",
	"gopls",
	"golangci_lint_ls",
	"ast_grep",
	"phpantom_lsp",
}

-- Server kustom yang tidak di-manage Mason (setup manual)
M.custom_servers = {
	"laravel_lsp",
}

---
-- REFACTORED SECTION
---
M.defaults = function()
	vim.api.nvim_create_user_command("LspInfo", "checkhealth vim.lsp", {})
	vim.api.nvim_create_user_command("LspRestart", function()
		for _, client in ipairs(vim.lsp.get_clients()) do
			client:stop(true)
		end

		vim.defer_fn(function()
			vim.cmd("silent! edit")
			print("LSP Restarted!")
		end, 300)
	end, {})

	dofile(vim.g.base46_cache .. "lsp")
	require("nvchad.lsp").diagnostic_config()

	-- NOTE: vim.lsp.handlers deprecated di Neovim 0.11+
	-- Border untuk hover/signatureHelp sudah di-handle via vim.lsp.buf config

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

		local config = vim.tbl_deep_extend("force", default_config, extra_config or {})

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

	local laravel_lsp_config = {
		cmd = { "laravel-lsp" },
		filetypes = { "php", "blade" },
		root_dir = function(bufnr, on_dir)
			local root = vim.fs.root(bufnr, "artisan")
			if root then
				on_dir(root)
			end
		end,
	}

	-- Enable semua Mason-managed servers
	for _, lsp in ipairs(M.servers) do
		if lsp == "lua_ls" then
			enable_server(lsp, lua_ls_config)
		else
			enable_server(lsp)
		end
	end

	-- Enable custom servers (tidak di-manage Mason)
	for _, lsp in ipairs(M.custom_servers) do
		if lsp == "laravel_lsp" then
			enable_server(lsp, laravel_lsp_config)
		else
			enable_server(lsp)
		end
	end
end

return M

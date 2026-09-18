dofile(vim.g.base46_cache .. "cmp")
local cmp = require("cmp")

local options = {
	completion = { completeopt = "menu,menuone,noselect" },
	preselect = cmp.PreselectMode.None,

	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},

	mapping = {
		["<C-k>"] = cmp.mapping.select_prev_item(),
		["<C-j>"] = cmp.mapping.select_next_item(),
		["<C-u>"] = cmp.mapping.scroll_docs(-4),
		["<C-d>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.close(),

		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Insert,
			select = false,
		}),

		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif require("luasnip").expand_or_jumpable() then
				require("luasnip").expand_or_jump()
			else
				fallback()
			end
		end, { "i", "s" }),

		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif require("luasnip").jumpable(-1) then
				require("luasnip").jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	},

	formatting = {
		format = function(entry, item)
			-- Get NvChad's default formatting (includes lspkind icons and colors)
			local nvchad_fmt = require("nvchad.cmp").formatting.format(entry, item)

			-- Custom AI and Source Icons
			local source_icons = {
				copilot = " Copilot",
				supermaven = " Supermaven",
				codeium = " Codeium",
				nvim_lsp = "λ LSP",
				luasnip = "⋗ Snippet",
				buffer = "Ω Buffer",
				path = "🖫 Path",
				nvim_lua = "Π Lua",
			}

			local source = entry.source.name
			local source_text = source_icons[source] or source

			if nvchad_fmt.menu then
				nvchad_fmt.menu = string.format("%s  [%s]", nvchad_fmt.menu, source_text)
			else
				nvchad_fmt.menu = string.format("  [%s]", source_text)
			end

			return nvchad_fmt
		end,
	},

	window = {
		completion = cmp.config.window.bordered({
			border = "rounded",
			winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
		}),
		documentation = cmp.config.window.bordered({
			border = "rounded",
			winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
		}),
	},

	experimental = {
		ghost_text = true,
	},

	sources = cmp.config.sources({
		{ name = "copilot", priority = 1000 },
		{ name = "supermaven", priority = 950 },
		{ name = "codeium", priority = 900 },
		{ name = "nvim_lsp", priority = 800 },
		{ name = "luasnip", priority = 700 },
		{ name = "nvim_lua", priority = 600 },
		{ name = "path", priority = 500 },
		{ name = "buffer", priority = 400 },
	}),

	sorting = {
		priority_weight = 2,
		comparators = {
			cmp.config.compare.offset,
			cmp.config.compare.exact,
			cmp.config.compare.score,
			cmp.config.compare.recently_used,
			cmp.config.compare.locality,
			cmp.config.compare.kind,
			cmp.config.compare.sort_text,
			cmp.config.compare.length,
			cmp.config.compare.order,
		},
	},
}

return vim.tbl_deep_extend("force", require("nvchad.cmp"), options)

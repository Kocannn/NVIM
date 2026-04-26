return {
	"nvim-lua/plenary.nvim",
	{
		"nvchad/base46",
		build = function()
			require("base46").load_all_highlights()
		end,
	},
	{
		"nvchad/ui",
		lazy = false,
		config = function()
			require("nvchad")
		end,
	},
	"nvzone/volt",
	"nvzone/menu",
	{ "nvzone/minty", cmd = { "Huefy", "Shades" } },
	{
		"nvim-tree/nvim-web-devicons",
		opts = function()
			dofile(vim.g.base46_cache .. "devicons")
			return { override = require("nvchad.icons.devicons") }
		end,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		event = "User FilePost",
		opts = {
			indent = { char = "│", highlight = "IblChar" },
			scope = { char = "│", highlight = "IblScopeChar" },
		},
		config = function(_, opts)
			dofile(vim.g.base46_cache .. "blankline")
			local hooks = require("ibl.hooks")
			hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
			require("ibl").setup(opts)
			dofile(vim.g.base46_cache .. "blankline")
		end,
	},
	{
		"nvim-tree/nvim-tree.lua",
		cmd = { "NvimTreeToggle", "NvimTreeFocus" },
		opts = function()
			return require("kocan.plugins.configs.nvimtree")
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		event = "VeryLazy",
		branch = "main",
		opts = function()
			return require("kocan.plugins.configs.gitsigns")
		end,
	},
	{
		"folke/which-key.nvim",
		keys = { "<leader>", "<c-w>", '"', "'", "`", "c", "v", "g" },
		cmd = "WhichKey",
		opts = function()
			dofile(vim.g.base46_cache .. "whichkey")
			return {}
		end,
	},
	{
		"stevearc/conform.nvim",
		event = "BufWritePre",
		opts = require("kocan.plugins.configs.conform"),
	},
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = {},
		keys = {
			{
				"s",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump()
				end,
				desc = "Flash",
			},
			{
				"S",
				mode = { "n", "x", "o" },
				function()
					require("flash").treesitter()
				end,
				desc = "Flash Treesitter",
			},
			{
				"r",
				mode = "o",
				function()
					require("flash").remote()
				end,
				desc = "Remote Flash",
			},
			{
				"R",
				mode = { "o", "x" },
				function()
					require("flash").treesitter_search()
				end,
				desc = "Treesitter Search",
			},
			{
				"<c-s>",
				mode = { "c" },
				function()
					require("flash").toggle()
				end,
				desc = "Toggle Flash Search",
			},
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
		lazy = false,
		config = function()
			require("kocan.plugins.configs.treesitter").setup()
		end,
	},
	{
		"akinsho/toggleterm.nvim",
		lazy = false,
		config = function()
			require("toggleterm").setup({
				open_mapping = [[<c-\>]],
				direction = "float",
			})
		end,
	},
	{
		"rmagatti/auto-session",
		lazy = false,
		opts = {
			suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
		},
	},
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = "cd app && yarn install",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
	},
}

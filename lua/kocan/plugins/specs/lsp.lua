return {
	{
		"williamboman/mason.nvim",
		cmd = { "Mason", "MasonInstall", "MasonUpdate" },
		opts = function()
			return require("kocan.plugins.configs.mason")
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },
		opts = function()
			return require("kocan.plugins.configs.mason-lspconfig")
		end,
	},
	{
		"neovim/nvim-lspconfig",
		event = "User FilePost",
		dependencies = { "williamboman/mason-lspconfig.nvim" },
		config = function()
			require("kocan.plugins.configs.lspconfig").defaults()
		end,
	},
}

return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
			},
			"nvim-telescope/telescope-file-browser.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		cmd = "Telescope",
		keys = {
			{
				";r",
				function()
					require("telescope.builtin").live_grep({ additional_args = { "--hidden" } })
				end,
				desc = "Search for a string in your current working directory and get results live as you type, respects .gitignore",
			},
			{
				"\\\\",
				function()
					require("telescope.builtin").buffers()
				end,
				desc = "Lists open buffers",
			},
			{
				"sf",
				function()
					local telescope = require("telescope")
					local function telescope_buffer_dir()
						return vim.fn.expand("%:p:h")
					end
					telescope.extensions.file_browser.file_browser({
						path = "%:p:h",
						cwd = telescope_buffer_dir(),
						respect_gitignore = false,
						hidden = true,
						grouped = true,
						previewer = false,
						initial_mode = "normal",
						layout_config = { height = 40 },
					})
				end,
				desc = "Open File Browser with the path of the current buffer",
			},
		},
		opts = function()
			return require("kocan.plugins.configs.telescope")
		end,
		config = function(_, opts)
			require("telescope").setup(opts)
			local status_ok, _ = pcall(require("telescope").load_extension, "fzf")
			if not status_ok then
				vim.notify(
					"FZF extension not loaded. Run 'cd ~/.local/share/nvim/lazy/telescope-fzf-native.nvim && make' to build it.",
					vim.log.levels.WARN
				)
			end
			require("telescope").load_extension("file_browser")
		end,
	},
	{
		"ibhagwan/fzf-lua",
		dependencies = { "echasnovski/mini.icons" },
		opts = {},
		keys = {
			{
				"<leader>fg",
				function()
					require("fzf-lua").live_grep()
				end,
				desc = "Find by grepping in project directory",
			},
			{
				"<leader>fc",
				function()
					require("fzf-lua").files({ cwd = vim.fn.stdpath("config") })
				end,
				desc = "Find in neovim configuration",
			},
			{
				"<leader>fk",
				function()
					require("fzf-lua").keymaps()
				end,
				desc = "[F]ind [K]eymaps",
			},
			{
				"<leader>fb",
				function()
					require("fzf-lua").builtin()
				end,
				desc = "[F]ind [B]uiltin FZF",
			},
			{
				"<leader>fw",
				function()
					require("fzf-lua").grep_cword()
				end,
				desc = "[F]ind current [W]ord",
			},
			{
				"<leader>fW",
				function()
					require("fzf-lua").grep_cWORD()
				end,
				desc = "[F]ind current [W]ORD",
			},
			{
				"<leader>fd",
				function()
					require("fzf-lua").diagnostics_document()
				end,
				desc = "[F]ind [D]iagnostics",
			},
		},
	},
}

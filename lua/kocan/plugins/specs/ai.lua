return {
	{
		"supermaven-inc/supermaven-nvim",
		lazy = false,
		event = "InsertEnter",
		disable_inline_completion = true,
		config = function()
			require("supermaven-nvim").setup({
				keymaps = {
					accept_suggestion = "<Tab>",
					clear_suggestion = "<C-]>",
					accept_word = "<C-j>",
				},
				color = {
					suggestion_color = "#ffffff",
					cterm = 244,
				},
				log_level = "info",
				disable_inline_completion = true,
				disable_keymaps = true,
				condition = function()
					return false
				end,
			})
		end,
	},
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		build = ":Copilot auth",
		event = "InsertEnter",
		config = function()
			require("copilot").setup(require("kocan.plugins.configs.copilot"))
		end,
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		branch = "main",
		cmd = "CopilotChat",
		opts = function()
			local user = vim.env.USER or "User"
			user = user:sub(1, 1):upper() .. user:sub(2)
			return {
				auto_insert_mode = true,
				question_header = " Yang Mulia Maha Raja " .. user .. " ",
				answer_header = "  Copilot ",
				window = { width = 0.4 },
			}
		end,
		keys = {
			{ "<c-s>", "<CR>", ft = "copilot-chat", desc = "Submit Prompt", remap = true },
			{ "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
			{
				"<leader>aa",
				function()
					return require("CopilotChat").toggle()
				end,
				desc = "Toggle (CopilotChat)",
				mode = { "n", "v" },
			},
			{
				"<leader>ax",
				function()
					return require("CopilotChat").reset()
				end,
				desc = "Clear (CopilotChat)",
				mode = { "n", "v" },
			},
			{
				"<leader>aq",
				function()
					vim.ui.input({ prompt = "Quick Chat: " }, function(input)
						if input ~= "" then
							require("CopilotChat").ask(input)
						end
					end)
				end,
				desc = "Quick Chat (CopilotChat)",
				mode = { "n", "v" },
			},
			{
				"<leader>ap",
				function()
					require("CopilotChat").select_prompt()
				end,
				desc = "Prompt Actions (CopilotChat)",
				mode = { "n", "v" },
			},
		},
		config = function(_, opts)
			local chat = require("CopilotChat")
			vim.api.nvim_create_autocmd("BufEnter", {
				pattern = "copilot-chat",
				callback = function()
					vim.opt_local.relativenumber = false
					vim.opt_local.number = false
				end,
			})
			chat.setup(opts)
		end,
	},
	{
		"Exafunction/codeium.nvim",
		cmd = "Codeium",
		event = "InsertEnter",
		build = ":Codeium Auth",
		opts = {
			enable_cmp_source = true,
			virtual_text = {
				enabled = false,
				key_bindings = {
					accept = false,
					next = "<M-]>",
					prev = "<M-[>",
				},
			},
		},
	},
	{
		"ravitemer/mcphub.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		lazy = false,
		build = "npm install -g mcp-hub@latest",
		opts = function()
			return require("kocan.plugins.configs.mcp")
		end,
	},
}

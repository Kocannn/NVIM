return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			picker = { ui_select = { enable = true } },
			input = {
				backdrop = false,
				position = "float",
				border = "rounded",
				title_pos = "center",
				height = 1,
				width = 60,
				relative = "editor",
				noautocmd = true,
				row = 2,
				wo = {
					winhighlight = "NormalFloat:SnacksInputNormal,FloatBorder:SnacksInputBorder,FloatTitle:SnacksInputTitle",
					cursorline = false,
				},
				bo = {
					filetype = "snacks_input",
					buftype = "prompt",
				},
				b = { completion = false },
				keys = {
					n_esc = { "<esc>", { "cmp_close", "cancel" }, mode = "n", expr = true },
					i_esc = { "<esc>", { "cmp_close", "stopinsert" }, mode = "i", expr = true },
					i_cr = { "<cr>", { "cmp_accept", "confirm" }, mode = { "i", "n" }, expr = true },
					i_tab = { "<tab>", { "cmp_select_next", "cmp" }, mode = "i", expr = true },
					i_ctrl_w = { "<c-w>", "<c-s-w>", mode = "i", expr = true },
					i_up = { "<up>", { "hist_up" }, mode = { "i", "n" } },
					i_down = { "<down>", { "hist_down" }, mode = { "i", "n" } },
					q = "cancel",
				},
			},
			-- Smooth scrolling animation
			scroll = { enabled = false },
			-- Indentation guides with animation
			indent = {
				enabled = true,
				animate = {
					enabled = true,
					style = "out",
					easing = "linear",
					duration = { step = 20, total = 200 },
				},
			},
			-- Notification system
			notifier = {
				enabled = true,
				timeout = 3000,
				style = "compact",
			},
			-- Scope highlighting
			scope = { enabled = true },
			-- Word highlighting under cursor
			words = { enabled = true },
			-- Zen mode
			zen = { enabled = true },
		},
		config = function(_, opts)
			require("snacks").setup(opts)
		end,
		keys = {
			{
				"<leader>z",
				function()
					require("snacks").zen()
				end,
				desc = "Toggle Zen Mode",
			},
			{
				"<leader>n",
				function()
					require("snacks").notifier.show_history()
				end,
				desc = "Notification History",
			},
		},
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		lazy = false,
		config = function()
			local lualine = require("lualine")

			local colors = {
				bg = "#202328",
				fg = "#bbc2cf",
				yellow = "#ECBE7B",
				cyan = "#008080",
				darkblue = "#081633",
				green = "#98be65",
				orange = "#FF8800",
				violet = "#a9a1e1",
				magenta = "#c678dd",
				blue = "#51afef",
				red = "#ec5f67",
				teal = "#1abc9c",
			}

			local conditions = {
				buffer_not_empty = function()
					return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
				end,
				hide_in_width = function()
					return vim.fn.winwidth(0) > 80
				end,
				check_git_workspace = function()
					local filepath = vim.fn.expand("%:p:h")
					local gitdir = vim.fn.finddir(".git", filepath .. ";")
					return gitdir and #gitdir > 0 and #gitdir < #filepath
				end,
			}

			-- Mode names for display
			local mode_names = {
				n = "NORMAL",
				i = "INSERT",
				v = "VISUAL",
				[""] = "V-BLOCK",
				V = "V-LINE",
				c = "COMMAND",
				no = "N-OP",
				s = "SELECT",
				S = "S-LINE",
				[""] = "S-BLOCK",
				ic = "INS-COMP",
				R = "REPLACE",
				Rv = "V-REPLACE",
				cv = "VIM-EX",
				ce = "EX",
				r = "PROMPT",
				rm = "MORE",
				["r?"] = "CONFIRM",
				["!"] = "SHELL",
				t = "TERMINAL",
			}

			local mode_color = {
				n = colors.blue,
				i = colors.green,
				v = colors.magenta,
				[""] = colors.magenta,
				V = colors.magenta,
				c = colors.yellow,
				no = colors.red,
				s = colors.orange,
				S = colors.orange,
				[""] = colors.orange,
				ic = colors.yellow,
				R = colors.red,
				Rv = colors.red,
				cv = colors.red,
				ce = colors.red,
				r = colors.cyan,
				rm = colors.cyan,
				["r?"] = colors.cyan,
				["!"] = colors.red,
				t = colors.teal,
			}

			local config = {
				options = {
					component_separators = "",
					section_separators = "",
					globalstatus = true,
					theme = {
						normal = { c = { fg = colors.fg, bg = colors.bg } },
						inactive = { c = { fg = colors.fg, bg = colors.bg } },
					},
					disabled_filetypes = {
						statusline = { "NvimTree", "nvdash" },
					},
				},
				sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_y = {},
					lualine_z = {},
					lualine_c = {},
					lualine_x = {},
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_y = {},
					lualine_z = {},
					lualine_c = {},
					lualine_x = {},
				},
			}

			local function ins_left(component)
				table.insert(config.sections.lualine_c, component)
			end

			local function ins_right(component)
				table.insert(config.sections.lualine_x, component)
			end

			-- Left edge
			ins_left({
				function()
					return "▊"
				end,
				color = function()
					return { fg = mode_color[vim.fn.mode()] or colors.blue }
				end,
				padding = { left = 0, right = 1 },
			})

			-- Mode indicator with text
			ins_left({
				function()
					local mode = vim.fn.mode()
					return "  " .. (mode_names[mode] or mode)
				end,
				color = function()
					return { fg = mode_color[vim.fn.mode()] or colors.blue, gui = "bold" }
				end,
				padding = { right = 1 },
			})

			-- File info
			ins_left({
				"filetype",
				icon_only = true,
				padding = { left = 1, right = 0 },
			})
			ins_left({
				"filename",
				cond = conditions.buffer_not_empty,
				color = { fg = colors.magenta, gui = "bold" },
				symbols = {
					modified = " ●",
					readonly = " 󰌾",
					unnamed = "[No Name]",
					newfile = "[New]",
				},
			})

			-- Git branch
			ins_left({
				"branch",
				icon = "",
				color = { fg = colors.violet, gui = "bold" },
			})

			-- Diff
			ins_left({
				"diff",
				symbols = { added = " ", modified = " ", removed = " " },
				diff_color = {
					added = { fg = colors.green },
					modified = { fg = colors.orange },
					removed = { fg = colors.red },
				},
				cond = conditions.hide_in_width,
			})

			-- Center separator
			ins_left({
				function()
					return "%="
				end,
			})

			-- LSP server info (center)
			ins_left({
				function()
					local clients = vim.lsp.get_clients({ bufnr = 0 })
					if #clients == 0 then
						return "󰒏 No LSP"
					end
					local names = {}
					for _, client in ipairs(clients) do
						table.insert(names, client.name)
					end
					return "󰒋 " .. table.concat(names, ", ")
				end,
				color = function()
					local clients = vim.lsp.get_clients({ bufnr = 0 })
					if #clients == 0 then
						return { fg = "#6c7086", gui = "italic" }
					end
					return { fg = colors.teal, gui = "bold" }
				end,
			})

			-- Diagnostics
			ins_right({
				"diagnostics",
				sources = { "nvim_diagnostic" },
				symbols = { error = " ", warn = " ", info = " ", hint = "󰌵 " },
				diagnostics_color = {
					error = { fg = colors.red },
					warn = { fg = colors.yellow },
					info = { fg = colors.cyan },
					hint = { fg = colors.green },
				},
			})

			-- Copilot status
			ins_right({
				function()
					local ok, copilot = pcall(require, "copilot.api")
					if not ok then
						return ""
					end
					local status = copilot.status.data
					if status.status == "Normal" then
						return " "
					elseif status.status == "InProgress" then
						return " "
					else
						return " "
					end
				end,
				color = function()
					local ok, copilot = pcall(require, "copilot.api")
					if ok and copilot.status.data.status == "Normal" then
						return { fg = colors.green }
					end
					return { fg = "#6c7086" }
				end,
				cond = function()
					local ok = pcall(require, "copilot.api")
					return ok
				end,
			})

			-- MCP Hub status
			ins_right({
				function()
					if not vim.g.loaded_mcphub then
						return "󰐻 -"
					end
					local count = vim.g.mcphub_servers_count or 0
					local status = vim.g.mcphub_status or "stopped"
					local executing = vim.g.mcphub_executing

					if status == "stopped" then
						return "󰐻 -"
					end
					if executing or status == "starting" or status == "restarting" then
						local frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
						local frame = math.floor(vim.uv.now() / 100) % #frames + 1
						return "󰐻 " .. frames[frame]
					end
					return "󰐻 " .. count
				end,
				color = function()
					if not vim.g.loaded_mcphub then
						return { fg = "#6c7086" }
					end
					local status = vim.g.mcphub_status or "stopped"
					if status == "ready" or status == "restarted" then
						return { fg = "#50fa7b" }
					elseif status == "starting" or status == "restarting" then
						return { fg = "#ffb86c" }
					else
						return { fg = "#ff5555" }
					end
				end,
			})

			-- Encoding + format (compact)
			ins_right({
				function()
					local enc = vim.bo.fileencoding ~= "" and vim.bo.fileencoding or vim.o.encoding
					local fmt = vim.bo.fileformat
					return enc:upper() .. " [" .. fmt:upper() .. "]"
				end,
				cond = conditions.hide_in_width,
				color = { fg = colors.green },
			})

			-- Location & progress (compact)
			ins_right({
				function()
					local cur = vim.fn.line(".")
					local total = vim.fn.line("$")
					local pct = math.floor(cur / total * 100)
					return string.format("󰉸 %d:%d (%d%%%%)", cur, vim.fn.col("."), pct)
				end,
				color = { fg = colors.fg, gui = "bold" },
			})

			-- Right edge
			ins_right({
				function()
					return "▊"
				end,
				color = function()
					return { fg = mode_color[vim.fn.mode()] or colors.blue }
				end,
				padding = { left = 1 },
			})

			lualine.setup(config)
		end,
	},
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		event = "User FilePost",
		opts = {
			signs = true,
		},
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
		opts = {
			lsp = {
				signature = { enabled = false },
				-- override markdown rendering so that cmp and other plugins use Treesitter
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
			},
			presets = {
				bottom_search = true, -- use a classic bottom cmdline for search
				command_palette = true, -- position the cmdline and popupmenu together
				long_message_to_split = true, -- long messages will be sent to a split
				inc_rename = false, -- enables an input dialog for inc-rename.nvim
				lsp_doc_border = true, -- add a border to hover docs and signature help
			},
			views = {
				cmdline_popup = {
					border = { style = "rounded" },
					position = { row = "40%", col = "50%" },
					size = { width = 60, height = "auto" },
				},
				popupmenu = {
					relative = "editor",
					position = { row = "45%", col = "50%" },
					size = { width = 60, height = 10 },
					border = { style = "rounded" },
				},
			},
		},
	},
	-- CSS/Tailwind color previewer
	{
		"NvChad/nvim-colorizer.lua",
		event = "User FilePost",
		opts = {
			user_default_options = {
				tailwind = true,
				css = true,
				css_fn = true,
				mode = "virtualtext",
				virtualtext = "■",
				virtualtext_inline = true,
			},
			filetypes = {
				"*",
				"!lazy",
				"!mason",
			},
		},
	},
}

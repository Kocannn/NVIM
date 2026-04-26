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
		},
		config = function(_, opts)
			require("snacks").setup(opts)
		end,
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

			local config = {
				options = {
					component_separators = "",
					section_separators = "",
					theme = {
						normal = { c = { fg = colors.fg, bg = colors.bg } },
						inactive = { c = { fg = colors.fg, bg = colors.bg } },
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

			ins_left({
				function()
					return "▊"
				end,
				color = { fg = colors.blue },
				padding = { left = 0, right = 1 },
			})

			ins_left({
				function()
					return ""
				end,
				color = function()
					local mode_color = {
						n = colors.red,
						i = colors.green,
						v = colors.blue,
						["\22"] = colors.blue,
						V = colors.blue,
						c = colors.magenta,
						no = colors.red,
						s = colors.orange,
						S = colors.orange,
						["\19"] = colors.orange,
						ic = colors.yellow,
						R = colors.violet,
						Rv = colors.violet,
						cv = colors.red,
						ce = colors.red,
						r = colors.cyan,
						rm = colors.cyan,
						["r?"] = colors.cyan,
						["!"] = colors.red,
						t = colors.red,
					}
					return { fg = mode_color[vim.fn.mode()] }
				end,
				padding = { right = 1 },
			})

			ins_left({ "filesize", cond = conditions.buffer_not_empty })
			ins_left({ "filename", cond = conditions.buffer_not_empty, color = { fg = colors.magenta, gui = "bold" } })
			ins_left({ "location" })
			ins_left({ "progress", color = { fg = colors.fg, gui = "bold" } })
			ins_left({
				"diagnostics",
				sources = { "nvim_diagnostic" },
				symbols = { error = " ", warn = " ", info = " " },
				diagnostics_color = {
					error = { fg = colors.red },
					warn = { fg = colors.yellow },
					info = { fg = colors.cyan },
				},
			})

			ins_left({
				function()
					return "%="
				end,
			})

			ins_left({
				function()
					local msg = "No Active Lsp"
					local buf_ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
					local clients = vim.lsp.get_clients()
					if next(clients) == nil then
						return msg
					end
					for _, client in ipairs(clients) do
						local filetypes = client.config.filetypes
						if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
							return client.name
						end
					end
					return msg
				end,
				icon = " LSP:",
				color = { fg = "#ffffff", gui = "bold" },
			})

			ins_right({
				"o:encoding",
				fmt = string.upper,
				cond = conditions.hide_in_width,
				color = { fg = colors.green, gui = "bold" },
			})

			ins_right({
				"fileformat",
				fmt = string.upper,
				icons_enabled = false,
				color = { fg = colors.green, gui = "bold" },
			})

			ins_right({
				"branch",
				icon = "",
				color = { fg = colors.violet, gui = "bold" },
			})

			ins_right({
				"diff",
				symbols = { added = " ", modified = "󰝤 ", removed = " " },
				diff_color = {
					added = { fg = colors.green },
					modified = { fg = colors.orange },
					removed = { fg = colors.red },
				},
				cond = conditions.hide_in_width,
			})

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
						local frame = math.floor(vim.loop.now() / 100) % #frames + 1
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

			ins_right({
				function()
					return "▊"
				end,
				color = { fg = colors.blue },
				padding = { left = 1 },
			})

			lualine.setup(config)
		end,
	},
}

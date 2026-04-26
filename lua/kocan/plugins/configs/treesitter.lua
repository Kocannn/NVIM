pcall(function()
	dofile(vim.g.base46_cache .. "syntax")
	dofile(vim.g.base46_cache .. "treesitter")
end)

local M = {}

function M.setup()
  local ok, configs = pcall(require, "nvim-treesitter.configs")
  if not ok then
    return
  end

  configs.setup({
    ensure_installed = {
      "lua",
      "luadoc",
      "printf",
      "vim",
      "vimdoc",
      "go",
      "proto",
      "blade",
      "python",
      "markdown",
      "markdown_inline",
      "sql",
      "php",
      "html",
      "css",
      "dockerfile",
    },
    auto_install = true,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    indent = {
      enable = true,
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<CR>",
        node_incremental = "<CR>",
        scope_incremental = false,
        node_decremental = "<BS>",
      },
    },
  })
end

return M

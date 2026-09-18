local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    css = { "prettier" },
    html = { "prettier" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    javascriptreact = { "prettier" },
    typescriptreact = { "prettier" },
    json = { "prettier" },
    yaml = { "prettier" },
    markdown = { "prettier" },
    go = { "goimports", "gofmt" },
    python = { "isort", "black" },
    php = { "pint" },
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 1000, -- increased timeout for slower formatters like black/pint
    lsp_fallback = true,
  },
}

return options

dofile(vim.g.base46_cache .. "nvimtree")

local function custom_on_attach(bufnr)
  local api = require("nvim-tree.api")
  -- Panggil default keybindings dulu
  api.config.mappings.default_on_attach(bufnr)

  -- Override key yang tidak diinginkan
  vim.keymap.set("n", "s", "", { buffer = bufnr })
  vim.keymap.set("n", "l", api.node.open.edit, { buffer = bufnr, desc = "Open" })
  vim.keymap.set("n", "h", api.node.navigate.parent_close, { buffer = bufnr, desc = "Close parent" })
end

return {

  filters = { dotfiles = false },
  disable_netrw = true,
  hijack_cursor = true,
  sync_root_with_cwd = true,
  update_focused_file = {
    enable = true,
    update_root = false,
  },
  view = {
    width = 30,
    preserve_window_proportions = true,
  },
  renderer = {
    root_folder_label = false,
    highlight_git = true,
    indent_markers = { enable = true },
    icons = {
      glyphs = {
        default = "󰈚",
        folder = {
          default = "",
          empty = "",
          empty_open = "",
          open = "",
          symlink = "",
        },
        git = { unmerged = "" },
      },
    },
  },
  on_attach = custom_on_attach,
}

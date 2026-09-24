vim.cmd('e test.blade.php')
require("lazy").load({ plugins = { "nvim-treesitter" } })
local ok, parser = pcall(vim.treesitter.get_parser, 0, "blade")
print("Parser ok: " .. tostring(ok))
if ok then
  print("Parser: " .. tostring(parser ~= nil))
else
  print("Error: " .. tostring(parser))
end

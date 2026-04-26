# NTOD

NTOD adalah konfigurasi Neovim berbasis NvChad dengan fokus pada:
- UI bersih dan ringan
- workflow coding modern (LSP + format + fuzzy finder)
- AI-assisted completion
- setup yang praktis untuk multi-bahasa

## Highlights

- Theme: tokyodark + transparansi
- Plugin manager: lazy.nvim
- LSP: nvim-lspconfig + mason.nvim + mason-lspconfig.nvim
- Formatter: conform.nvim
- Completion: nvim-cmp + LuaSnip + copilot-cmp + supermaven + codeium
- Treesitter: auto install parser + highlight + indent + incremental selection
- Finder: telescope.nvim + fzf-native + file-browser + fzf-lua
- Git: gitsigns + lazygit (via snacks)

## Requirements

Pastikan tools ini tersedia:
- Neovim 0.10+ (direkomendasikan terbaru)
- Git
- Node.js + npm
- GCC/Clang atau build tools setara (untuk plugin native seperti telescope-fzf-native)
- Opsional: lazygit

## Install

1. Backup config lama jika ada:

   mv ~/.config/nvim ~/.config/nvim.bak

2. Clone repo/config ini ke folder Neovim:

   git clone <repo-anda> ~/.config/nvim

3. Jalankan Neovim:

   nvim

4. Sinkronkan plugin:

   :Lazy sync

## Struktur Folder

- init.lua: entrypoint Neovim
- lua/chadrc.lua: konfigurasi UI base46/NvChad
- lua/kocan/core: options, keymaps, autocmd
- lua/kocan/plugins/init.lua: aggregator module plugin
- lua/kocan/plugins/specs: daftar plugin per kategori (core, lsp, completion, ai, search, ui)
- lua/kocan/plugins/configs: konfigurasi per-plugin

## LSP + Mason (Auto Enable)

Konfigurasi ini sudah menghubungkan Mason ke LSP agar lebih otomatis:
- server pada daftar default akan di-enable saat startup
- server yang sudah terpasang di Mason akan ikut di-enable otomatis
- server baru yang di-install dari Mason akan langsung didaftarkan dan di-enable

Cara pakai:
1. Buka Mason

   :Mason

2. Install server, contoh:

   :MasonInstall lua-language-server

3. Buka file sesuai bahasa, lalu cek:

   :LspInfo

## Treesitter

Treesitter aktif dengan:
- ensure_installed untuk parser umum
- auto_install parser saat butuh
- highlight dan indent aktif
- incremental selection aktif

Cek status parser:

:TSInstallInfo

## AI Completion

Sumber completion diprioritaskan seperti ini:
1. copilot
2. supermaven
3. codeium
4. nvim_lsp dan source standar lain

Tujuannya agar saran AI tetap kuat, tapi fallback LSP/snippet tetap stabil.

## Keymap Penting

- Leader: Space
- Simpan file: Ctrl+s
- Format file: <leader>fm
- Explorer: <leader>e
- Find files: <leader>ff
- Live grep: <leader>fs
- Buffer next/prev: Tab / Shift+Tab
- Close buffer: <leader>x
- Toggle terminal float: Alt+i
- Toggle terminal horizontal: Alt+h
- Toggle terminal vertical: Alt+v
- Lazygit (jika terinstall): <leader>gg

## Troubleshooting

Jika ada masalah setelah update:
- Jalankan :Lazy sync
- Jalankan :MasonUpdate
- Jalankan :checkhealth
- Hapus cache plugin jika perlu lalu buka ulang Neovim

## Catatan

Anda bisa menambah server LSP default di file:
- lua/kocan/plugins/configs/lspconfig.lua

Dan menambah parser Treesitter di file:
- lua/kocan/plugins/configs/treesitter.lua

local M = {}

function M.setup()
	local cfg = require("kocan.config")

	vim.g.base46_cache = cfg.core.base46_cache
	vim.g.mapleader = cfg.core.mapleader

	local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
	if not vim.uv.fs_stat(lazypath) then
		local repo = "https://github.com/folke/lazy.nvim.git"
		vim.fn.system({ "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath })
	end

	vim.opt.rtp:prepend(lazypath)
end

return M

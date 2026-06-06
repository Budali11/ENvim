vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.mouse = "a"
opt.showmode = false
opt.signcolumn = "yes"
opt.termguicolors = true
opt.cursorline = true
opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.splitright = true
opt.splitbelow = true
opt.ignorecase = true
opt.smartcase = true
opt.smartindent = true
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
opt.undofile = true
opt.updatetime = 200
opt.timeout = true
opt.timeoutlen = 300
opt.completeopt = { "menu", "menuone", "noselect", "popup" }
opt.clipboard = "unnamedplus"

require("envim.config.statusline").setup()

vim.diagnostic.config({
  severity_sort = true,
  float = { border = "rounded" },
  underline = true,
  update_in_insert = false,
  virtual_text = {
    spacing = 2,
    source = "if_many",
  },
})

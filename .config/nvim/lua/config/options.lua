local g = vim.g

g.mapleader = ' '
g.maplocalleader = ' '

g.have_nerd_font = true

local opt = vim.opt

opt.number = true
opt.relativenumber = true

opt.mouse = 'a'

opt.showmode = false

vim.schedule(function()
  opt.clipboard = 'unnamedplus'
end)

opt.breakindent = true

opt.undofile = true

opt.ignorecase = true
opt.smartcase = true

opt.signcolumn = 'yes'

opt.updatetime = 250

opt.timeoutlen = 300

opt.splitright = true
opt.splitbelow = true

opt.list = true
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

opt.inccommand = 'split'

opt.cursorline = true

opt.scrolloff = 10

opt.confirm = true

opt.tabstop = 2
opt.shiftwidth = 2
opt.shiftround = true
opt.expandtab = true

opt.guicursor = ''

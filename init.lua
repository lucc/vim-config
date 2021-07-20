-- init.vim file by luc

require "options"
require "plugins"
require "maps"
require "colors"

-- Arch linux compatibility: makes it possible to load plugins installed via
-- pacman
vim.opt.runtimepath:append{"/usr/share/vim/vimfiles"}

-- recmpile the packer file on each change to the plugin spec files
vim.cmd [[
  augroup LucPluginSetup
  autocmd!
  autocmd BufWritePost ~/.config/nvim/lua/plugins/*.lua PackerCompile
  augroup END

  command! PackerInstall packadd packer.nvim | lua require('plugins.all').install()
  command! PackerUpdate packadd packer.nvim | lua require('plugins.all').update()
  command! PackerSync packadd packer.nvim | lua require('plugins.all').sync()
  command! PackerClean packadd packer.nvim | lua require('plugins.all').clean()
  command! PackerCompile packadd packer.nvim | lua require('plugins.all').compile('~/.config/nvim/plugin/packer_load.vim')
  command! -nargs=+ -complete=customlist,v:lua.require'packer'.loader_complete PackerLoad | lua require('packer').loader(<q-args>)
]]

-- Set colors for the terminal.

vim.opt.background = "dark"
if vim.opt.termguicolors then
  -- FIXME it is currently very slow to do this is lua directly and it yields
  -- false results for me
  vim.cmd[[
  colorscheme NeoSolarized
  highlight! VertSplit guifg=#657b83 guibg=#657b83
  highlight! MatchParen gui=italic,bold guibg=none
  ]]
else
  vim.cmd[[
  colorscheme solarized
  highlight! SignColumn ctermfg=10 ctermbg=0
  ]]
end

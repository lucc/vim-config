" Set colors for the terminal.  If the GUI is running the colorscheme will be
" set in ginit.vim.
if ! has('gui_running')
  set background=dark
  if &termguicolors
    colorscheme NeoSolarized
    highlight! VertSplit guifg=#657b83 guibg=#657b83
    highlight! MatchParen gui=italic,bold guibg=none
  else
    colorscheme solarized
    highlight! SignColumn ctermfg=10 ctermbg=0
  endif
endif

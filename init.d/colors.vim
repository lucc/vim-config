" Set colors for the terminal.  If the GUI is running the colorscheme will be
" set in ginit.vim.
if ! has('gui_running')
  set background=dark
  if &termguicolors
    colorscheme NeoSolarized
  else
    colorscheme solarized
  endif
  highlight! SignColumn ctermfg=10 ctermbg=0 guibg=#073642
endif

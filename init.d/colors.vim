" Set colors for the terminal.  If the GUI is running the colorscheme will be
" set in ginit.vim.
if ! has('gui_running')
  set background=dark
  colorscheme solarized
  highlight! SignColumn ctermfg=10 ctermbg=0
endif

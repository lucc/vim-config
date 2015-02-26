" Set colors for the terminal.  If the GUI is running the colorscheme will be
" set in gvimrc.
if ! has('gui_running')
  set background=dark
  colorscheme solarized
endif

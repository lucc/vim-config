" Settings and plugins for the look and feel/user interface (graphics only)

scriptencoding utf-8

" colors
Plug 'iCyMind/NeoSolarized'
Plug 'altercation/vim-colors-solarized'
let g:solarized_menu = 0

" statusline
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
let g:airline_theme = 'solarized'
let g:airline_powerline_fonts = 1
let g:airline#extensions#whitespace#mixed_indent_algo = 2
let g:airline#extensions#whitespace#checks = ['indent', 'trailing', 'long']
let g:airline#extensions#vimtex#enabled = 1

" vim options related to the statusline
set noshowmode   " do not display the current mode in the command line
set laststatus=2 " always display the statusline

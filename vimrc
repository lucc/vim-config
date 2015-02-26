" vimrc file by luc
" vim: spelllang=en

" fix the runtimepath to conform to XDG a little bit
set runtimepath+=~/.config/vim
call luc#xdg#runtimepath()
let $MYGVIMRC = substitute($MYVIMRC, 'vimrc$', 'gvimrc', '')
let $GVIMINIT = 'source $MYGVIMRC'

" set up python
call luc#setup#python()

" user defined variables
let mapleader = ','

" setup for server vim
call luc#setup#viminfo(!luc#server#running())

" source subfiles
execute 'source' . luc#xdg#config . '/vimrc.d/options.vim'
execute 'source' . luc#xdg#config . '/vimrc.d/autocmds.vim'
execute 'source' . luc#xdg#config . '/vimrc.d/maps.vim'
execute 'source' . luc#xdg#config . '/vimrc.d/commands.vim'
execute 'source' . luc#xdg#config . '/vimrc.d/plugins.vim'
execute 'source' . luc#xdg#config . '/vimrc.d/colors.vim'

" switch on filetype detection after defining all Bundles
syntax enable
filetype plugin indent on

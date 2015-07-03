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
runtime vimrc.d/options.vim
runtime vimrc.d/autocmds.vim
runtime vimrc.d/maps.vim
runtime vimrc.d/commands.vim
runtime vimrc.d/plugins.vim
runtime vimrc.d/colors.vim

" switch on filetype detection after defining all Bundles
syntax enable
filetype plugin indent on

if has('nvim') && has('gui_running')
  augroup LucNvimGuiInit
    autocmd VimEnter * source $MYGVIMRC
  augroup end
endif

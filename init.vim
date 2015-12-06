" vimrc file by luc
" vim: spelllang=en

" set up python
call luc#setup#python()

" user defined variables
let mapleader = ','

" setup for server vim
call luc#setup#viminfo(luc#server#running() ? 'client' : 'server')

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

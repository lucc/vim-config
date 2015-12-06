" init.vim file by luc
" vim: spelllang=en

" set up python
call luc#setup#python()

" user defined variables
let mapleader = ','

" setup for server vim
call luc#setup#viminfo(luc#server#running() ? 'client' : 'server')

" source subfiles
runtime init.d/options.vim
runtime init.d/autocmds.vim
runtime init.d/maps.vim
runtime init.d/commands.vim
runtime init.d/plugins.vim
runtime init.d/colors.vim

" switch on filetype detection after defining all Bundles
syntax enable
filetype plugin indent on

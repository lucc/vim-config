" a simple vimrc file to read text files with gvim

set nocompatible
set guioptions+=M
set guioptions-=m
set runtimepath+=~/.config/vim
set laststatus=0
set noloadplugins
call luc#xdg#runtimepath()
call luc#setup#vim_plug()
runtime vimrc.d/plugins/colors.vim
call plug#end()
call luc#xdg#runtimepath()
set background=light
colorscheme solarized

nnoremap q :quit<CR>
nnoremap <Space> <C-F><C-G>
nnoremap <S-space> <C-B><C-G>
nnoremap <C-F> <C-F><C-G>
nnoremap <C-B> <C-B><C-G>

" some generic functions to set up vim

function! luc#setup#viminfo(type) abort
  " default: '100,<50,s10,h
  " the flag ' is for filenames for marks
  " the flag < is the nummber of lines saved per register
  " the flag s is the max size saved for registers in kb
  " the flag h is to disable hlsearch
  " the flag % is to remember (whole) buffer list
  " the flag n is the name of the viminfo file
  if a:type == 'server'
    set viminfo='100,<50,s10,h,%
  elseif a:type == 'client'
    " if we are not running as the server do not use the viminfo file.  We
    " probably only want to edit one file quickly from the command line.
    set viminfo=
  elseif a:type == 'pager'
    set viminfo='0,<50,s10,h
    let &viminfo .= ',n' . g:luc#xdg#cache . '/viminfo/pager.shada'
  endif
endfunction

function! luc#setup#python() abort
  python import vim
  pyfile ~/.config/nvim/init.py
endfunction

function! luc#setup#vundle() abort
  " https://github.com/gmarik/Vundle.vim
  filetype off
  let path = expand(g:luc#xdg#data . '/plugins')
  execute 'set runtimepath+=' . path . '/Vundle.vim'
  call vundle#begin(path)
  Plugin 'gmarik/Vundle.vim'
endfunction

function! luc#setup#vim_plug() abort
  " https://github.com/junegunn/vim-plug
  let path = expand(g:luc#xdg#data . '/plugins')
  "execute 'set runtimepath+=' . path . '/vim-plug'
  execute 'source' path . '/vim-plug/plug.vim'
  call plug#begin(path)
  command! -bar -nargs=+ Plugin Plug <args>
  Plug 'junegunn/vim-plug'
endfunction

function! luc#setup#delfunction(pattern) abort
  " Delete all functions matching the given pattern.
  redir => functions
  execute 'silent function /'.a:pattern
  redir END
  for fun in split(functions, "\n")
    execute 'del'.substitute(fun, '(.*)$', '', '')
  endfor
  let @a = old
endfunction

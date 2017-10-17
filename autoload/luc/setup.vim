" some generic functions to set up vim

function! luc#setup#python() abort
  python import vim
  pyfile ~/.config/nvim/init.py
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

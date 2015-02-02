" fix the runtimepath to conform to XDG a little bit

function! luc#xdg#vars()
  let g:luc#xdg#config = ($XDG_CONFIG_HOME != '' ? $XDG_CONFIG_HOME : '~/.config') . '/vim'
  let g:luc#xdg#data = ($XDG_DATA_HOME != '' ? $XDG_DATA_HOME : '~/.local/share') . '/vim'
  let g:luc#xdg#cache = ($XDG_CACHE_HOME != '' ? $XDG_CACHE_HOME : '~/.cache') .'/vim'
endfunction

function! luc#xdg#init_files()
  let $MYGVIMRC = substitute($MYVIMRC, 'vimrc$', 'gvimrc', '')
  let $GVIMINIT = 'source $MYGVIMRC'
endfunction

function! luc#xdg#runtimepath()
  set runtimepath-=~/.vim
  set runtimepath-=~/.vim/after
  execute 'set runtimepath-=' . g:luc#xdg#config
  execute 'set runtimepath-=' . g:luc#xdg#config . '/after'
  execute 'set runtimepath^=' . g:luc#xdg#config
  execute 'set runtimepath+=' . g:luc#xdg#config . '/after'
endfunction

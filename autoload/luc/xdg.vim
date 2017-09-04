" fix the runtimepath to conform to XDG a little bit

let luc#xdg#config =
      \ ($XDG_CONFIG_HOME != '' ? $XDG_CONFIG_HOME : '~/.config') . '/nvim'
let luc#xdg#data =
      \ ($XDG_DATA_HOME != '' ? $XDG_DATA_HOME : '~/.local/share') . '/nvim'
let luc#xdg#cache =
      \ ($XDG_CACHE_HOME != '' ? $XDG_CACHE_HOME : '~/.cache') .'/nvim'

function! luc#xdg#runtimepath() abort
  set runtimepath-=~/.vim
  set runtimepath-=~/.vim/after
  execute 'set runtimepath-=' . g:luc#xdg#config
  execute 'set runtimepath-=' . g:luc#xdg#config . '/after'
  execute 'set runtimepath^=' . g:luc#xdg#config
  execute 'set runtimepath+=' . g:luc#xdg#config . '/after'
endfunction

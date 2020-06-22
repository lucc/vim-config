set expandtab
set foldmethod=indent
compiler stack

"autocmd BufWritePost <buffer> InteroReload

"InteroEnableTypeOnHover

" start intero after "stack path --config-location" did complete once (for
" chaching reasons)
function! s:start_intero(a,b,c) abort
  InteroStart
endfunction
"call jobstart(['stack', 'path', '--config-location'],
"      \ {'on_exit': function('s:start_intero')})

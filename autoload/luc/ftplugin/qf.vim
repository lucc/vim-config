function! luc#ftplugin#qf#open() abort
  let l:info = getwininfo(win_getid())[0]
  if l:info.loclist
    .ll
    lclose
  elseif l:info.quickfix
    .cc
    cclose
  else
    echoerr 'This function must be called from a quickfix or location list window.'
    return
  endif
  silent! %foldclose!
  silent! .foldopen!
endfunction

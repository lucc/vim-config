function! luc#ftplugin#qf#open() abort
  let l:refold = 0
  let l:info = getwininfo(win_getid())[0]
  if l:info.loclist
    "if len(getloclist(TODO)) != 0
      .ll
      let l:refold = 1
    "endif
    lclose
  elseif l:info.quickfix
    if len(getqflist()) != 0
      .cc
      let l:refold = 1
    endif
    cclose
  else
    echoerr 'This function must be called from a quickfix or location list window.'
    return
  endif
  if l:refold
    silent! %foldclose!
    silent! .foldopen!
  endif
endfunction

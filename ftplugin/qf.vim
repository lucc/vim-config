" custom filetype settings by luc

setlocal nowrap cursorline
nnoremap <buffer> <ENTER> :call <SID>open_switch()<CR>
vnoremap <buffer> <ENTER> :<C-U>call <SID>open_switch()<CR>
nnoremap <buffer> <2-leftmouse> :call <SID>open_switch()<CR>

nnoremap <buffer> <C-v> :call <SID>open_vsplit()<CR>
nnoremap <buffer> <C-s> :call <SID>open_split()<CR>

let s:split_no = 0
let s:split_hor = 1
let s:split_vert = 2

function! s:open_switch() abort
  return s:open(s:split_no)
endfunction
function! s:open_split() abort
  return s:open(s:split_hor)
endfunction
function! s:open_vsplit() abort
  return s:open(s:split_vert)
endfunction

function! s:open(split) abort
  " Save the current setting to restore it after switching to the correct
  " window.
  let l:save_switchbuf = &switchbuf

  " select the correct switching behaviour given the argument
  if a:split == s:split_no
    set switchbuf=useopen
  elseif a:split == s:split_hor
    set switchbuf=split
  elseif a:split == s:split_vert
    set switchbuf=vsplit
  endif

  let l:refold = 0
  let l:info = getwininfo(win_getid())[0]
  if l:info.loclist
    " FIXME: how can I find out which window a locationlist window points to?
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
    " Restore the switchbuf settings.
    let &switchbuf = l:save_switchbuf
    return
  endif
  if l:refold
    silent! %foldclose!
    silent! .foldopen!
  endif

  " Restore the switchbuf settings.
  let &switchbuf = l:save_switchbuf
endfunction

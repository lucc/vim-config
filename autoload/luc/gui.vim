" gui specific functions by luc

function! s:resize_gui()
  " function to put the gvim window on the left of the screen
  set nofullscreen
  set guioptions-=T
  winpos 0 0
  let &guifont = s:normalfonts
  set lines=999
  set columns=85
  "redraw!
endfunction

function! luc#gui#toggle_fullscreen()
  " function to toggle fullscreen mode
  if &fullscreen
    call s:resize_gui()
  else
    set fullscreen
  endif
endfunction

function! luc#gui#toggle_font_size()
  if &guifont == s:normalfonts
    let &guifont = s:bigfonts
  elseif &guifont == s:bigfonts
    let &guifont = s:normalfonts
  else
    echoerr 'Can not toggle font.'
  endif
endfunction

" user defined mappings by luc

nmap ß :windo set rightleft!<CR>

" idea from Matze
map <ESC> :nohlsearch<BAR>redraw<CR><C-G>

nmap <F12>       :call luc#gui#toggle_font_size()<CR>
imap <F12>  <C-O>:call luc#gui#toggle_font_size()<CR>

if has('gui_macvim')
  " tabs
  nmap <S-D-CR>      <C-W>T
  imap <S-D-CR> <C-O><C-W>T
  " fullscreen
  nmap <D-CR>      :call luc#gui#toggle_fullscreen()<CR>
  imap <D-CR> <C-O>:call luc#gui#toggle_fullscreen()<CR>
  " copy and paste like the mac osx default
  nmap <silent> <D-v>       "*p
  imap <silent> <D-v>  <C-r>*
  nmap <silent> <D-c>       "*yy
  imap <silent> <D-c>  <C-o>"*yy
  vmap <silent> <D-c>       "*ygv
  " mouse gestures
  nmap <silent> <SwipeLeft>  :pop<CR>
  nmap <silent> <SwipeRight> :tag<CR>
endif

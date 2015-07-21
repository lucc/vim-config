function! luc#ftplugin#qf#open()
  if
	\ w:quickfix_title == ':setloclist()' ||
	\ w:quickfix_title == ":        lgetexpr ''"
    .ll
    lclose
  else
    .cc
    cclose
  endif
  silent %foldclose!
  silent! .foldopen!
endfunction

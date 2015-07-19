function! luc#ftplugin#qf#open()
  if
	\ w:quickfix_title == ':setloclist()' ||
	\ w:quickfix_title == ":        lgetexpr ''"
    .ll
    lclose
  elseif 0 " no quickfix things up till now
    .cc
    cclose
  else
    echoerr "Unknown quickfix type: ".w:quickfix_title
  endif
  %foldclose!
  silent! .foldopen!
endfunction

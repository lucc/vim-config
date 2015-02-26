" user defined autocommands by luc

augroup LucRemoveWhiteSpaceAtEOL "{{{2
  autocmd!
  autocmd BufWrite *
	\ let s:position = getpos('.')          |
	\ silent keepjumps %substitute/\s\+$//e |
	\ call setpos('.', s:position)          |
augroup END

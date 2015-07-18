" user defined autocommands by luc

augroup LucRemoveWhiteSpaceAtEOL "{{{1
  autocmd!
  autocmd BufWrite *
	\ let s:position = getpos('.')          |
	\ silent keepjumps %substitute/\s\+$//e |
	\ call setpos('.', s:position)          |
augroup END

augroup LucNvimContribStuff "{{{1
  autocmd!
  autocmd FileType c nnoremap <buffer> <silent> <C-]> :YcmCompleter GoTo<cr>
augroup END

augroup LucNeoMake "{{{1
  autocmd!
  autocmd BufWritePost * Neomake
augroup END

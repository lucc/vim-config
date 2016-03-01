" user defined autocommands by luc

augroup LucRemoveWhiteSpaceAtEOL
  autocmd!
  autocmd BufWrite *
	\ if ! (expand('<afile>') =~? '.*\.patch' ||
        \       expand('<afile>') =~? '.*\.diff') |
	\   let s:position = getpos('.')          |
	\   silent keepjumps %substitute/\s\+$//e |
	\   call setpos('.', s:position)          |
	\ endif
augroup END

augroup LucNeoMake
  autocmd!
  "autocmd BufWritePost * Neomake
  autocmd BufWritePost ~/vcs/n{,eo}vim/test/functional/**/*_spec.lua Neomake!
augroup END

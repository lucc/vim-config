" user defined autocommands by luc

augroup LucRemoveWhiteSpaceAtEOL
  autocmd!
  autocmd BufWrite *
	\ if ! (expand('<afile>') =~? '.*\.patch' ||
        \       expand('<afile>') =~? '.*\.diff') |
	\   let s:position = getpos('.')          |
	\   silent keepjumps %snomagic/\s\+$//e   |
	\   call setpos('.', s:position)          |
	\ endif
augroup END

augroup LucNeoMake
  autocmd!
  autocmd BufWritePost * Neomake
  autocmd BufEnter *.py
	\ let b:neomake_python_enabled_makers =
	\   filter(neomake#makers#ft#python#EnabledMakers(),
	\          {i, v -> executable(v)}) + ['unittest']
augroup END

augroup LucApplications
  autocmd!
  "autocmd BufWritePost ~/apply/*.tex exe 'echo "NeomakeSh make ' <afile>:t:r.pdf   '"'
  "autocmd BufWritePost ~/apply/*.tex !echo NeomakeSh make <afile>:t:r.pdf
  "autocmd BufWritePost ~/apply/*.tex NeomakeSh make <afile>:t:r.pdf
  "autocmd BufWritePost ~/apply/*.tex execute 'NeomakeSh make' expand('<afile>:t:r.pdf')
  autocmd BufWritePost ~/apply/current.tex NeomakeSh make
  autocmd BufEnter ~/apply/*.tex
	\ let b:neomake_tex_enabled_makers =
	\   filter(neomake#makers#ft#tex#EnabledMakers() + ['make'],
	\          'executable(v:val)')
augroup END

augroup LucNewScripts
  autocmd!
  " from https://unix.stackexchange.com/a/39995/88313
  autocmd BufWritePost *
	\ if getline(1) =~# '^#!.*/bin/' && ! executable(expand('<afile>')) |
	\   call jobstart(['chmod', '+x', expand('<afile>')]) |
	\ endif
augroup END

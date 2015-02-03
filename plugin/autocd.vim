" plugin providing an autocd command

command! AutoCd cd %:h

"augroup LucLocalAutoCd
"  autocmd!
"  autocmd BufEnter ~/uni/**     lcd ~/uni
"  autocmd BufEnter ~/.config/** lcd ~/.config
"  autocmd BufEnter ~/src/**     lcd ~/src
"augroup END

"augroup LucLocalWindowCD
"  autocmd!
"  " FIXME: still buggy
"  autocmd BufWinEnter,WinEnter,BufNew,BufRead,BufEnter *
"	\ execute 'lcd' pyeval('backup_base_dir_vim_reapper()')
"augroup END

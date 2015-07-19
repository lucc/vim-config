" custom filetype settings by luc
setlocal nowrap cursorline
nnoremap <buffer> <ENTER> :call luc#ftplugin#qf#open()<CR>
vnoremap <buffer> <ENTER> :<C-U>call luc#ftplugin#qf#open()<CR>
nnoremap <buffer> <2-leftmouse> :call luc#ftplugin#qf#open()<CR>

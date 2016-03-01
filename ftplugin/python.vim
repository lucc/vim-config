" custom filetype settings by luc
setlocal tabstop=8
setlocal expandtab
setlocal shiftwidth=4
setlocal softtabstop=4
setlocal textwidth=79
nnoremap <buffer> gd :YcmCompleter GoToDefinition<CR>
augroup LucPythonFileType
  autocmd!
  autocmd BufWritePost <buffer> Neomake
augroup END

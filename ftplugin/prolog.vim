"autocmd BufWritePost <buffer> IronSend prolog make.
nnoremap <buffer> K <CMD>execute 'IronSend prolog help('. expand('<cword>') .').'<CR>

set foldmethod=indent

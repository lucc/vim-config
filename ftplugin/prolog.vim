autocmd BufWritePost <buffer> IronSend prolog make.
nnoremap <buffer> K :execute 'IronSend prolog help('. expand('<cword>') .').'<CR>

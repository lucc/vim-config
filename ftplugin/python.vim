" custom filetype settings by luc
setlocal tabstop=8
setlocal expandtab
setlocal shiftwidth=4
setlocal softtabstop=4
setlocal textwidth=79
nnoremap <buffer> gd :call pymode#rope#goto_definition()<CR>
let b:easytags_auto_highlight = 0
setlocal path+=/usr/lib/python3.*/**
setlocal path+=/usr/lib/python2.7/**
setlocal path+=/usr/lib/pygtk/**
setlocal path+=~/.local/lib/python3.*/**
setlocal path+=~/.local/lib/python2.7/**

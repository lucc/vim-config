" custom filetype settings by luc
setlocal tabstop=8
setlocal expandtab
setlocal shiftwidth=4
setlocal softtabstop=4
setlocal textwidth=79
setlocal includeexpr=(v:fname[0]=='.'?expand('%:p:h'):'').substitute(v:fname,'\\.','/','g')
let b:easytags_auto_highlight = 0
setlocal path+=/usr/lib/python3.*/**
setlocal path+=/usr/lib/python2.7/**
setlocal path+=/usr/lib/pygtk/**
setlocal path+=~/.local/lib/python3.*/**
setlocal path+=~/.local/lib/python2.7/**

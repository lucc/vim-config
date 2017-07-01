" custom filetype settings by luc
setlocal tabstop=8
setlocal expandtab
setlocal shiftwidth=4
setlocal softtabstop=4
setlocal textwidth=79
nnoremap <buffer> gd :call pymode#rope#goto_definition()<CR>
let b:easytags_auto_highlight = 0

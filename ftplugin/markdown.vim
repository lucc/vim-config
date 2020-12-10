" custom filetype settings by luc
setlocal spell
command! -buffer PandocSetNeomake       setlocal makeprg=pandoc\ %\ -o\ %:r.html
command! -buffer PandocSetNeomakePdf    setlocal makeprg=pandoc\ %\ -o\ %:r.pdf\ -t\ latex
command! -buffer PandocSetNeomakeBeamer setlocal makeprg=pandoc\ %\ -o\ %:r.pdf\ -t\ beamer

" Add "portable" comments like discribed in
" https://stackoverflow.com/a/20885980/4102092
setlocal comments+=b:[//]:\ #

" Add a special syntax match for "portable markdown line comments" like
" described in https://stackoverflow.com/a/20885980/4102092
syntax match LucPandocComment /\v^\[\/\/\]: # .*$/
"containedin=pandocReferenceLabel,pandocOperator
highlight link LucPandocComment Comment

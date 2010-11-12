"""""""""""""""""
" Unused stuff: "
"""""""""""""""""
"  this is not used b/c i could not figure out how to open all folds on startup
"+ automatically (zR does not seem to work here).
"set fdm=syntax
"zR

"set transparency=15

"set enc=utf-8


"""""""""""""""""""""""""""""""""""""""""""""""""
" Autoformating text and indicating long lines: "
"""""""""""""""""""""""""""""""""""""""""""""""""

" usfull for coding
set autoindent

" brake lines after 80 chars
"set textwidth=80

" brake text and comments but do not reformat lines where no input occures
"set formatoptions=tc

"  i dont understand how but this highlights the part of the line which is 
"+ longer then 80 char in grey (blue in a terminal).
augroup vimrc_autocmds
  au!
  autocmd BufRead * highlight OverLength ctermbg=blue ctermfg=white guibg=grey "guibg=#592929 
  autocmd BufRead * match OverLength /\%81v.*/
augroup END


"""""""""""""""""""""""""""
" Aperance of the editor: "
"""""""""""""""""""""""""""

" higlight syntax automatically
syntax on

"line numbers
set number


""""""""""""""""""
" for terminals: "
""""""""""""""""""

"make the mouse usable in a terminal
set mouse=a


"""""""""""""""""""""""""""
" Behavior of the editor: "
"""""""""""""""""""""""""""

" go to ``insert'' mode
start


"  gvimrc file by luc {{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vi:fdm=marker:fdl=0
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

" {{{ GENERAL
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" guioptions (default: egmrLtT)
set guioptions+=cegv
set guioptions-=rT

set guifont=
set columns=85
set lines=999
set fullscreen

"set bg=dark

if has("gui_macvim")
  set tabpagemax=30
  set fuoptions=maxvert,maxhorz
  set antialias
endif

command Resize winpos 0 0 | set guioptions-=T lines=999 columns=85


" fix $PATH if not started from a terminal
if ! ($PATH =~ expand($HOME) . '/bin')
  let $PATH .= ':' . expand($HOME) . '/bin'
endif
"if ! ($PATH =~ '/usr/local/bin')
  let $PATH = '/usr/local/bin:' . substitute($PATH, ':\?/usr/local/bin:\?', ':', 'g')
  let $PATH = substitute($PATH, '^:', '', '')
"endif

" }}}

" {{{ use the gui for displaying manpages
function! ConqueMan()
    let cmd = &keywordprg . ' '
    if cmd ==# 'man ' || cmd ==# 'man -s '
        if v:count > 0
            let cmd .= v:count . ' '
        else
            let cmd = 'man '
        endif
    endif
    let cmd .= expand('<cword>')
    execute 'ConqueTermSplit' cmd
endfunction
map K :<C-U>call ConqueMan()<CR>
ounmap K
" }}}

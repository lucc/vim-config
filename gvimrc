"  gvimrc file by luc {{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vi:fdm=marker:fdl=0
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" {{{ variables and functions

let s:font="menlo"
let s:normalfontsize=12
let s:bigfontsize=25

" other possibility
"let s:font="inconsolata"
"let s:normalfontsize=14
"let s:bigfontsize=30

function LucResizeFunction ()
  " function to put the gvim window on the left of the screen
  set nofullscreen
  set guioptions-=T
  winpos 0 0
  let &guifont=s:font . ":h12"
  set lines=999
  set columns=85
endfunction

function LucFullscreenFunction (size)
  " function to go to fullscreen mode with aspesific fontsize
  set fullscreen
  let &guifont=s:font . ":h" . a:size
endfunction

" }}}
" {{{ options

if has("gui_macvim")
  " use the macvim colorscheme, but slightly modify it.
  colorscheme macvim
  set background=light
  "hi Normal  guifg=Grey50 guibg=#1f1f1f
  "hi LineNr  guifg=Grey50 guibg=#1f1f1f
  "hi Comment guifg=#3464A4
  set tabpagemax=30
  set fuoptions=maxvert,maxhorz
  set antialias
endif

" guioptions (default: egmrLtT)
set guioptions+=cegv
set guioptions-=rT
set fullscreen
let &guifont=s:font . ":h" . s:normalfontsize

" }}}
" {{{ user commands and mappings

command Resize          call LucResizeFunction()
command Fullscreen      call LucFullscreenFunction(s:normalfontsize)
command PlainFullscreen call LucFullscreenFunction(s:bigfontsize)

" mappings to view man pages in gvim
"map K :<C-U>call ConqueMan()<CR>
"ounmap K
nmap ß :windo set rightleft!<CR>

" }}}
" {{{ OTHER
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" fix $PATH if not started from a terminal
if ! ($PATH =~ expand($HOME) . '/bin')
  let $PATH .= ':' . expand($HOME) . '/bin'
endif
"if ! ($PATH =~ '/usr/local/bin')
  let $PATH = '/usr/local/bin:' . substitute($PATH, ':\?/usr/local/bin:\?', ':', 'g')
  let $PATH = substitute($PATH, '^:', '', '')
"endif

" }}}

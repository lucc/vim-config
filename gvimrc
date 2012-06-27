"  gvimrc file by luc {{{1
" vim: foldmethod=marker

" {{{1 variables and functions

" {{{2 fonts

let s:font="menlo"
let s:normalfontsize=12
let s:bigfontsize=25

" other possibility
"let s:font="inconsolata"
"let s:normalfontsize=14
"let s:bigfontsize=30

function! LucResizeFunction () " {{{2
  " function to put the gvim window on the left of the screen
  set nofullscreen
  set guioptions-=T
  winpos 0 0
  let &guifont=s:font . ":h12"
  set lines=999
  set columns=85
  "redraw!
endfunction

function! LucFullscreenFunction (big) " {{{2
  " function to go to fullscreen mode with a spesific fontsize
  set fullscreen
  let &guifont=s:font . ":h" . (a:big ? s:bigfontsize : s:normalfontsize)
  redraw!
endfunction

" {{{1 user commands and mappings

nmap ß :windo set rightleft!<CR>
nmap <D-F10> :call LucResizeFunction()<CR>
nmap <D-F11> :call LucFullscreenFunction(0)<CR>
nmap <D-F12> :call LucFullscreenFunction(1)<CR>
if has("gui_macvim")
  nmap <silent> <D-F3> :call LucOpenPdfOrPreview(1, '', 1)<CR>
  imap <silent> <D-F3> <C-O>:call LucOpenPdfOrPreview(1, '', 1)<CR>
  nmap <silent> <D-F4> :call LucOpenPdfOrPreview(0, '', 1)<CR>
  imap <silent> <D-F4> <C-O>:call LucOpenPdfOrPreview(0, '', 1)<CR>
endif

" {{{1 options

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
"set fullscreen
let &guifont=s:font . ":h" . s:normalfontsize

" {{{1 other

" fix $PATH (may be necessary if not started from a terminal)
if ! ($PATH =~ expand($HOME) . '/bin')
  let $PATH .= ':' . expand($HOME) . '/bin'
endif
"if ! ($PATH =~ '/usr/local/bin')
  let $PATH = '/usr/local/bin:' . substitute($PATH, ':\?/usr/local/bin:\?', ':', 'g')
  let $PATH = substitute($PATH, '^:', '', '')
"endif

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

function! LucOpenPdfOrPreview (check, file, go_back) " {{{2
  " function to check if a pdf file is open in Preview.app and bring it to the
  " foreground.  a:go_back is used to return to vim or not.  When a:file is
  " empty the stem of the current file is used with '.pdf' appended.

  " The command to switch to the pdf program or open a pdf file.
  "let l:switch  = '!open -ga Preview'
  let l:switch  = '!open -a Preview'
  let l:open    = '!open -a Preview '
  let l:command = ''
  let l:msg     = ''
  let l:go_back = a:go_back

  " find a suitable filename
  "let l:file = expand('%') =~ '.*\.tex' ? expand('%:r') . '.pdf' : ''
  let l:file = &filetype == 'tex' ? expand('%:r') . '.pdf' : ''
  let l:file = a:file ? a:file : l:file
  if l:file == ''
    echoerr 'No suitable filename found.'
    return
  endif

  " find the right command to execute and do so
  if a:check
    " collect the output from 'lsof'
    let l:result = system('lsof ' . l:file)
    " parse the output (FIXME: system specific)
    let l:result = match(get(split(l:result, '\n'), 1, ''), '^Preview')
    " if the file was not opend, do so, else only switch the application
    if v:shell_error || l:result == -1
      let l:command = l:open . l:file
      let l:msg = 'Opening file "' . l:file . '" ...'
    else
      let l:command = l:switch
      let l:msg = 'Switching to viewer ...'
    endif
  else
    let l:command = l:switch
    let l:msg = 'Switching to viewer ...'
    "let l:go_back = 0
  endif
  echo l:msg
  silent execute l:command

  " return to vim if desired
  if l:go_back
    " wait for the pdf-viewer to update its display
    sleep 1000m
    " bring vim to the foreground again
    call foreground()
  endif
endfunction

" {{{1 user commands and mappings

nmap ß :windo set rightleft!<CR>
nmap <D-F10> :call LucResizeFunction()<CR>
nmap <D-F11> :call LucFullscreenFunction(0)<CR>
nmap <D-F12> :call LucFullscreenFunction(1)<CR>
if has("gui_macvim")
  nmap <silent> <D-v> "*p
  imap <silent> <D-v> <C-r>*
  nmap <silent> <D-c> "*yy
  imap <silent> <D-c> <C-o>"*yy
  vmap <silent> <D-c> "*y
  nmap <silent> <F3> :call LucOpenPdfOrPreview(0, '', 1)<CR>
  imap <silent> <F3> <C-O>:call LucOpenPdfOrPreview(0, '', 1)<CR>
  nmap <silent> <D-F3> :call LucOpenPdfOrPreview(1, '', 1)<CR>
  imap <silent> <D-F3> <C-O>:call LucOpenPdfOrPreview(1, '', 1)<CR>
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

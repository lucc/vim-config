" gvimrc file by luc {{{1
" vim: foldmethod=marker

" user defined variables {{{1

"set guifont=DejaVu\ Sans\ Mono\ 9

" TODO
let s:fonts = [
      \ ['menlo',                    12, 25],
      \ ['monospace',                10, 25],
      \ ['inconsolata',              14, 30],
      \ ['bitstream vera sans mono', 12, 20],
      \ ['dejavu sans mono',         12, 20]
      \ ]

let s:delim = ''
if has('gui_macvim')
  let s:delim = ':h'
elseif has('gui_gtk2')
  let s:delim = ' '
endif

let s:normalfonts = join(map(copy(s:fonts),
      \ 'join(v:val[0:1], s:delim)'), ',')
let s:bigfonts = join(map(copy(s:fonts),
      \ '(remove(v:val, 1) . join(v:val, s:delim))[2:-1]'), ',')
if system('uname') == 'Linux'
  s:normalfonts = 'DejaVu Sans Mono 9'
endif

" user defined functions {{{1
function! LucSelectFont (big) "{{{2
  " Select a font and set it
  let delim = ''
  if has('gui_macvim')
    let s:delim = ':h'
  elseif has('gui_gtk2')
    let s:delim = ' '
  endif
  " TODO
endfunction

function! LucResizeFunction () " {{{2
  " function to put the gvim window on the left of the screen
  set nofullscreen
  set guioptions-=T
  winpos 0 0
  let &guifont = s:normalfonts
  set lines=999
  set columns=85
  "redraw!
endfunction

function! LucFullscreenFunction (big) " {{{2
  " function to go to fullscreen mode with a spesific fontsize
  set fullscreen
  let &guifont = a:big ? s:bigfonts : s:normalfonts
  "redraw!
endfunction

function! LucToggleFullscreenFunction (big) " {{{2
  " function to toggle fullscreen mode with specific fontsize
  if &fullscreen
    call LucResizeFunction()
  else
    call LucFullscreenFunction(a:big)
  endif
endfunction


function! LucOpenPdfOrPreview (check, file, go_back) " {{{2
  " function to check if a pdf file is open in Preview.app and bring it to the
  " foreground.  a:go_back is used to return to vim or not.  When a:file is
  " empty the stem of the current file is used with '.pdf' appended.
  "
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
  " find the right command to execute
  " this version is for mac os x wih Preview.app
  if 0 " don't use Preview.app on macosx
    if a:check
      " collect the output from 'lsof'
      let l:result = system('lsof ' . l:file)
      " parse the output (FIXME system specific)
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
  else " use mupdf instead (on all systems)
    let l:command = 'killall -HUP mupdf || mupdf ' . l:file . ' &'
    let l:msg = l:command
  endif
  " display a message and execute the command
  echo l:msg
  "silent execute l:command
  call system(l:command)
  " return to vim if desired
  if l:go_back
    " wait for the pdf-viewer to update its display
    sleep 1000m
    " bring vim to the foreground again
    call foreground()
  endif
endfunction

" user defined commands and mappings {{{1

nmap ß :windo set rightleft!<CR>
if has("gui_macvim")
  " tabs
  nmap <S-D-CR> <C-W>T
  imap <S-D-CR> <C-O><C-W>T
  " fullscreen
  nmap <D-CR> :call LucToggleFullscreenFunction(0)<CR>
  imap <D-CR> <C-O>:call LucToggleFullscreenFunction(0)<CR>
  nmap <D-F12> :call LucFullscreenFunction(1)<CR>
  " copy and paste like the mac osx default
  nmap <silent> <D-v>  "*p
  imap <silent> <D-v>  <C-r>*
  nmap <silent> <D-c>  "*yy
  imap <silent> <D-c>  <C-o>"*yy
  vmap <silent> <D-c>  "*y
  " open pdfs for tex files
  nmap <silent> <F3>   :call LucOpenPdfOrPreview(0, '', 1)<CR>
  imap <silent> <F3>   <C-O>:call LucOpenPdfOrPreview(0, '', 1)<CR>
  nmap <silent> <D-F3> :call LucOpenPdfOrPreview(1, '', 1)<CR>
  imap <silent> <D-F3> <C-O>:call LucOpenPdfOrPreview(1, '', 1)<CR>
  " mouse gestures
  nmap <silent> <SwipeLeft>  :pop<CR>
  nmap <silent> <SwipeRight> :tag<CR>
endif

" options: gui {{{1

" guioptions (default: egmrLtT)
set guioptions+=cegv
set guioptions-=rT
set tabpagemax=30
" TODO
let &guifont = s:normalfonts

if has("gui_macvim")
  set fuoptions=maxvert,maxhorz
  set antialias
endif

" colorscheme {{{1
let s:colorscheme = 'sol'
if s:colorscheme == 'mv'
  " use the macvim colorscheme, but slightly modify it
  colorscheme macvim
  set background=light
  "hi Normal  guifg=Grey50 guibg=#1f1f1f
  "hi LineNr  guifg=Grey50 guibg=#1f1f1f
  "hi Comment guifg=#3464A4
elseif s:colorscheme == 'sol'
  " switching to solarized
  set bg=light
  colorscheme solarized
elseif s:colorscheme == 'pp'
  " switching to peachpuff because of a bug in (mac?)vim
  colorscheme peachpuff
endif

cal LucSelectRandomColorscheme()

" other {{{1

if has('gui_macvim')
  " fix $PATH on Mac OS X
  for item in readfile(expand('~/.config/env/PATH'))
    let item = expand(item)
    if !($PATH =~ item)
      let $PATH = item . ':' . $PATH
    endif
  endfor
endif

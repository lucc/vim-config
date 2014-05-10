" gvimrc file by luc {{{1
" vim: foldmethod=marker

" user defined variables {{{1

"set guifont=DejaVu\ Sans\ Mono\ 9

" TODO
let s:fonts = [
      \ ['menlo for powerline',      12, 25],
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
if system('uname') == "Linux\n"
  s:normalfonts = 'DejaVu Sans Mono 9'
endif

" user defined functions {{{1
function! <SID>toggle_fullscreen() " {{{2
  " function to toggle fullscreen mode
  if &fullscreen
    call luc#resize_gui()
  else
    set fullscreen
  endif
endfunction

function! <SID>toggle_font_size() "{{{2
  if &guifont == s:normalfonts
    let &guifont = s:bigfonts
  elseif &guifont == s:bigfonts
    let &guifont = s:normalfonts
  else
    echoerr 'Can not toggle font.'
  endif
endfunction

" user defined autocommands {{{1

augroup LucDelMenus "{{{2
  autocmd!
  autocmd VimEnter * aunmenu *
augroup END

" user defined commands and mappings {{{1

nmap ß :windo set rightleft!<CR>
if has("gui_macvim")
  " tabs
  nmap <S-D-CR> <C-W>T
  imap <S-D-CR> <C-O><C-W>T
  " fullscreen
  nmap <D-CR> :call <SID>toggle_fullscreen()<CR>
  imap <D-CR> <C-O>:call <SID>toggle_fullscreen()<CR>
  nmap <F12> :call <SID>toggle_font_size()<CR>
  imap <F12> <C-O>:call <SID>toggle_font_size()<CR>
  " copy and paste like the mac osx default
  nmap <silent> <D-v>  "*p
  imap <silent> <D-v>  <C-r>*
  nmap <silent> <D-c>  "*yy
  imap <silent> <D-c>  <C-o>"*yy
  vmap <silent> <D-c>  "*ygv
  " open pdfs for tex files
  "nmap <silent> <F3>   :call LucOpenPdfOrPreview(0, '', 1)<CR>
  "imap <silent> <F3>   <C-O>:call LucOpenPdfOrPreview(0, '', 1)<CR>
  "nmap <silent> <D-F3> :call LucOpenPdfOrPreview(1, '', 1)<CR>
  "imap <silent> <D-F3> <C-O>:call LucOpenPdfOrPreview(1, '', 1)<CR>
  nmap <silent> <F3>   :python activate_preview()<CR>
  imap <silent> <F3>   <C-O>:python activate_preview()<CR>
  nmap <silent> <D-F3>   <D-F2>:python activate_preview()<CR>
  imap <silent> <D-F3>   <C-O><D-F2>:python activate_preview()<CR>
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
if strftime('%H%M') > 700 && strftime('%H%M') < 2100
  set background=light
else
  set background=dark
endif
colorscheme solarized


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

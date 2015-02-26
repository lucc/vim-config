" font setup for gvim by luc

let s:fonts = [
      \ ['meslo lg s for powerline', 8, 25],
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
let g:my_fonts__ = [copy(s:normalfonts), copy(s:bigfonts)]
"if system('uname') == "Linux\n"
"  let s:normalfonts = 'DejaVu Sans Mono 9'
"endif

let &guifont = s:normalfonts

nmap <F12>       :call luc#gui#toggle_font_size()<CR>
imap <F12>  <C-O>:call luc#gui#toggle_font_size()<CR>

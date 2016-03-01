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
if has('gui_macvim') || has('nvim')
  let s:delim = ':h'
elseif has('gui_gtk2')
  let s:delim = ' '
endif

let g:luc#gui#normalfonts = join(map(copy(s:fonts),
      \ 'join(v:val[0:1], s:delim)'), ',')
let g:luc#gui#bigfonts = join(map(copy(s:fonts),
      \ '(remove(v:val, 1) . join(v:val, s:delim))[2:-1]'), ',')

let &guifont = g:luc#gui#normalfonts

command -nargs=? Guifont call luc#gui#nvim_qt_guifont(<q-args>)
augroup LucNvimGUIFont
  autocmd VimEnter *
	\ if has('nvim') && has('gui_running')                |
	\   execute 'Guifont' s:fonts[0][0].':h'.s:fonts[0][1] |
	\ endif
augroup END

" custom filetype settings by luc

execute 'py3file ' . expand('<sfile>:h:h') . '/init.py'

nmap <buffer> go <plug>(vimtex-toc-open)
nmap <buffer> gO <plug>(vimtex-toc-toggle)
" deactivate the default mapping
map <buffer>  <foobar> <plug>(vimtex-context-menu)

setlocal spell
" This doesn't work
"setlocal dictionary+=%:h/**/*.bib,%:h/**/*.tex
setlocal grepprg=grep\ -nH\ $*
" This is currently handled by latex-suite
"setlocal makeprg=latexmk\ -silent\ -pv\ -pdf\ $*

" otherwise I will go crazy with the flickering signcolumn from LC.
setlocal signcolumn=yes

if py3eval('check_for_english_babel()')
  let b:Tex_SmartQuoteOpen = '“'
  let b:Tex_SmartQuoteClose = '”'
endif

let b:surround_99 = "\\\1command\1{\r}"

let b:delimitMate_quotes = "' ` *"
let b:neomake_echo_current_error = 0

" TODO we could put this into the status line
let s:timer = -1
function! s:count(id)
  VimtexCountLetters
endfunction

augroup LucFileTypeTex
  autocmd! * <buffer>
  autocmd BufWritePost,CursorHold,CursorHoldI <buffer> Neomake!
  autocmd BufWritePost <buffer>
	\ if timer_info(s:timer) == []
	\ | let s:timer = timer_start(3000, function('s:count'))
	\ | endif
  "CursorHold,CursorHoldI,FocusGained,FocusLost
augroup END

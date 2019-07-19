" custom filetype settings by luc

execute 'py3file ' . expand('<sfile>:h:h') . '/init.py'

nnoremap <buffer> K
      \ :call py3eval('tex.doc("""'.expand('<cword>').'""") or 1')<CR>
nnoremap <buffer> gGG :python3 tex_count_vim_wrapper()<CR>
vnoremap <buffer> gGG :python3 tex_count_vim_wrapper()<CR>
nnoremap <buffer> gG :python3 tex_count_vim_wrapper(wait=True)<CR>
vnoremap <buffer> gG :python3 tex_count_vim_wrapper(wait=True)<CR>

setlocal spell
" This doesn't work
"setlocal dictionary+=%:h/**/*.bib,%:h/**/*.tex
setlocal grepprg=grep\ -nH\ $*
" This is currently handled by latex-suite
"setlocal makeprg=latexmk\ -silent\ -pv\ -pdf\ $*

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
  autocmd BufWritePost,CursorHold,CursorHoldI          <buffer> Neomake!
  "autocmd CursorHold,CursorHoldI,FocusGained,FocusLost <buffer> if timer_info(s:timer) == [] | let s:timer = timer_start(3000, function('s:count')) | endif
  autocmd BufWritePost <buffer> if timer_info(s:timer) == [] | let s:timer = timer_start(3000, function('s:count')) | endif
augroup END

" custom filetype settings by luc

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

" inccmd is very slow in tex files for some reason
setlocal inccommand=

" vimtex supports some conceals
setlocal conceallevel=2

let b:surround_99 = "\\\1command\1{\r}"

let b:delimitMate_quotes = "' ` *"
let b:neomake_echo_current_error = 0

augroup LucFileTypeTex
  autocmd! * <buffer>
  "autocmd BufWritePost <buffer> silent VimtexCompile
  autocmd BufWritePost <buffer> silent Make!
  " TODO we could put this into the status line
  "let s:timer = -1
  "autocmd BufWritePost <buffer>
  "      \ if timer_info(s:timer) == []
  "      \ | let s:timer = timer_start(3000, {->nvim_command("VimtexCountLetters")})
  "      \ | endif
  "CursorHold,CursorHoldI,FocusGained,FocusLost
augroup END


"let g:vimtex_compiler_latexrun  = {'options': ['--verbose-cmds', '--latex-args="-synctex=1 -shell-escape"', '--bibtex-cmd=biber'], 'build_dir': 'latex.out'}
let g:vimtex_compiler_method = "generic"
let g:vimtex_compiler_generic  = {"command":"make"}
map <buffer> <leader>v <plug>(vimtex-view)

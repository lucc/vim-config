" custom filetype settings by luc

function! s:tex_buffer_maps()
  " Some maps for tex buffers.  They are collected in a function because
  " putting :map into autocmds is error prone.
  nnoremap <buffer> K
	\ :call pyeval('tex.doc("""'.expand('<cword>').'""") or 1')<CR>
  nnoremap <buffer> gGG :python tex_count_vim_wrapper()<CR>
  vnoremap <buffer> gGG :python tex_count_vim_wrapper()<CR>
  nnoremap <buffer> gG :python tex_count_vim_wrapper(wait=True)<CR>
  vnoremap <buffer> gG :python tex_count_vim_wrapper(wait=True)<CR>
endfunction

setlocal spell
setlocal dictionary+=%:h/**/*.bib,%:h/**/*.tex
setlocal grepprg=grep\ -nH\ $*
" This is currently handled by latex-suite
"setlocal makeprg=latexmk\ -silent\ -pv\ -pdf\ $*

call s:tex_buffer_maps()

if pyeval('check_for_english_babel()')
  let b:Tex_SmartQuoteOpen = '“'
  let b:Tex_SmartQuoteClose = '”'
endif

let b:surround_99 = "\\\1command\1{\r}"

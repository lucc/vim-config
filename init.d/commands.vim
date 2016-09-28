" user defined commands by luc

" interactive fix for latex quotes in English files
command! UnsetLaTeXQuotes unlet g:Tex_SmartQuoteOpen g:Tex_SmartQuoteClose

" From the example vimrc file.
command! DiffOrig call s:DiffOrig()

function! s:DiffOrig()
  vertical new
  set buftype=nofile
  read ++edit #
  0delete _
  diffthis
  wincmd p
  diffthis
endfunction

" Open the file under the cursor or the current file with xdg-open.
command! -bang O call s:open("<bang>")

function! s:open(bang)
  if empty(a:bang)
    !xdg-open <cfile> &
    redraw
  else
    !xdg-open % &
    redraw
  endif
endfunction

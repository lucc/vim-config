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

cabbrev man vertical Man

command! -nargs=* SSH call s:ssh(<q-args>)

function! s:ssh(args)
  if empty(a:args)
    echoerr "You must give a remote path to edit."
    return 1
  endif
  let [host; path] = split(a:args, '/')
  execute 'edit scp://' . host . '//' . join(path, '/')
endfunction

command! -nargs=* Alot call s:alot(<f-args>)
command! -nargs=* AlotSearch call s:alot_search_at_cursor()
function! s:alot(...)
  tabnew
  call termopen([expand('~/src/alot/alot.nix')]+a:000)
  autocmd TermClose <buffer> ++once close!
  startinsert
endfunction
function! s:alot_search_at_cursor()
  let l:isk = &isk
  set isk=@,:,@-@,-,48-57,.
  let l:cword = expand("<cword>")
  let &isk = l:isk
  call s:alot('search', l:cword)
  return ""
endfunction

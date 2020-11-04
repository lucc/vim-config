" Autoload functions for commands that I defined myself

" From the example vimrc file.
function! luc#commands#DiffOrig()
  vertical new
  set buftype=nofile
  read ++edit #
  0delete _
  diffthis
  wincmd p
  diffthis
endfunction

function! luc#commands#open(bang)
  if empty(a:bang)
    !xdg-open <cfile> &
    redraw
  else
    !xdg-open % &
    redraw
  endif
endfunction

function! luc#commands#ssh(args)
  if empty(a:args)
    echoerr "You must give a remote path to edit."
    return 1
  endif
  let [host; path] = split(a:args, '/')
  execute 'edit scp://' . host . '//' . join(path, '/')
endfunction

function! luc#commands#alot(...)
  tabnew
  call termopen([expand('~/src/alot/alot.nix')]+a:000)
  autocmd TermClose <buffer> ++once close!
  startinsert
endfunction

function! luc#commands#alot_search_at_cursor()
  let l:isk = &isk
  set isk=@,:,@-@,-,48-57,.
  let l:cword = expand("<cword>")
  let &isk = l:isk
  call luc#commands#alot('search', l:cword)
  return ""
endfunction

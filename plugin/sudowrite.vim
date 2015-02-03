" Write a file with sudo previleges without restarting vim.

function! s:sudo_write() "{{{2
  " danke an Matze
  write ! sudo dd of="%"
  edit!
  redraw
endfunction

command! Suw :call s:sudo_write()

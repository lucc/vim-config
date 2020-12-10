" Write a file with sudo previleges without restarting vim.

" neovim does not provide a terminal for !
" We can use SUDO_ASKPASS to still query the password
if has("nvim") && $SSH_ASKPASS != ""
  let $SUDO_ASKPASS = $SSH_ASKPASS
endif

function! s:sudo_write() "{{{2
  " danke an Matze
  silent write ! sudo dd of="%"
  edit!
  redraw
endfunction

command! Suw :call s:sudo_write()

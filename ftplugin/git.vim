" settings for the git status and git diff buffers of fugitive

if nvim_win_get_height(0) >= nvim_buf_line_count(0)
  setlocal nofoldenable
endif

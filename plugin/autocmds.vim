" user defined autocommands by luc

augroup LucRemoveWhiteSpaceAtEOL
  autocmd!
  autocmd BufWrite *
	\ if ! (expand('<afile>') =~? '.*\.patch' ||
        \       expand('<afile>') =~? '.*\.diff') |
	\   let s:position = getpos('.')          |
	\   silent keepjumps %snomagic/\s\+$//e   |
	\   call setpos('.', s:position)          |
	\ endif
augroup END

augroup LucNeoMake
  autocmd!
  autocmd BufWritePost *
	\ if ! v:lua.vim.lsp.buf.server_ready() |
	\   Neomake |
	\ endif
augroup END

augroup LucAsamSettings
  autocmd!
  autocmd BufReadPost *.php,*.inc,*.func setlocal tw=85 sw=4 ts=4 et
  "autocmd BufWritePost    *.php,*.inc,*.func Neomake php
  autocmd BufWritePre    *.php,*.inc,*.func set fileencoding=utf8
augroup END

augroup LucNewScripts
  autocmd!
  " from https://unix.stackexchange.com/a/39995/88313
  autocmd BufWritePost *
	\ if getline(1) =~# '^#!.*/bin/' && ! executable(expand('<afile>')) |
	\   call jobstart(['chmod', '+x', expand('<afile>')]) |
	\ endif
augroup END

augroup LucPrivateFiles
  autocmd!
  autocmd BufWritePre /tmp/*,/dev/shm/* setlocal noundofile
augroup END

augroup LucNixOSConfig
  autocmd!
  autocmd BufEnter ~/src/nixos/*.nix compiler nixos
augroup END

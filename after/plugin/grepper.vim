" Overwrite the Ag command from fzf.vim.
command! -nargs=* -complete=file Ag Grepper! -tool ag -query <args>

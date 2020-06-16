" Overwrite the Ag command from fzf.vim.
command! -nargs=* -complete=file Ag Grepper -jump -tool rg -query <args>

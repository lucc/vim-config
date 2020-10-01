" Overwrite the Ag command from fzf.vim.
command! -nargs=* -complete=file Ag Grepper -jump -tool rg -query <args>
" Overwrite fugitive command
command! -nargs=* -complete=file Gr Grepper -jump -tool rg -query <args>

" make git searches case insensitive
let g:grepper.git.grepprg .= 'i'

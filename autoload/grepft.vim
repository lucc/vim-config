" safe this file as autoload/grepft.vim in your runtimepath

" Search all files of the current file type.
function! grepft#search(query)
  " can be changed to 'grep', 'Ack' or 'Ag':
  let command = 'vimgrep'
  let command .= ' ' . a:query . ' **/*.'
  " for shell scripts without suffix:
  let command .= expand('%:e') != '' ? expand('%:e') : &filetype
  " debugging:
  echo ':'.command
  execute command
endfunction

" To use, define a command like this in your .vimrc (not here)
"command -nargs=1 Hans call grepft#search(<q-args>)

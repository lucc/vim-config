function! luc#server#running() abort
  " Check if another vim server is already running.
  return !empty(has('clientserver') ? serverlist() :
	\ system('vim --serverlist 2>/dev/null'))
endfunction

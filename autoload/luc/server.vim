function! luc#server#running()
  " Check if another vim server is already running.
  return !empty(has('clientserver') ? serverlist() :
	\ system('vim --serverlist'))
endfunction

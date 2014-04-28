function! luc#server#setup() "{{{2
  call s:viminfo_setup(!s:running())
  "if has('neovim')
  "  call LucServerViminfoSetup()
  "elseif has('gui_running')
  "  " try to be the server
  "  call LucServerViminfoSetup(!LucServerRunning())
  "else
  "  " don't try to be the server
  "  call LucServerViminfoSetup(0)
  "endif
endfunction

function! s:running() "{{{2
  " check if another vim server is already running
  return !empty(has('clientserver') ? serverlist() : system('vim --serverlist'))
endfunction

function! s:viminfo_setup(server) "{{{2
  if a:server
    " options: viminfo
    " default: '100,<50,s10,h
    set viminfo='100,<50,s10,h,%,n~/.vim/viminfo
    " the flag ' is for filenames for marks
    set viminfo='100
    " the flag < is the nummber of lines saved per register
    set viminfo+=<50
    " max size saved for registers in kb
    set viminfo+=s10
    " disable hlsearch
    set viminfo+=h
    " remember (whole) buffer list
    set viminfo+=%
    " name of the viminfo file
    set viminfo+=n~/.vim/viminfo
    " load a static viminfo file with a file list
    rviminfo ~/.vim/default-buffer-list.viminfo
  else
    " if we are not running as the server do not use the viminfo file.  We
    " probably only want to edit one file quickly from the command line.
    set viminfo=
  endif
endfunction


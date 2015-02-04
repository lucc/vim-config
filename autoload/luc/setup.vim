" some generic functions to set up vim

function! luc#setup#viminfo(server)
  if a:server
    " options: viminfo
    " default: '100,<50,s10,h
    set viminfo='100,<50,s10,h,%
    let &viminfo .= ',n' . g:luc#xdg#cache . '/viminfo'
    " the flag ' is for filenames for marks
    " the flag < is the nummber of lines saved per register
    " the flag s is the max size saved for registers in kb
    " the flag h is to disable hlsearch
    " the flag % is to remember (whole) buffer list
    " the flag n is the name of the viminfo file
    " load a static viminfo file with a file list
    rviminfo ~/.config/vim/default-buffer-list.viminfo
    " set up an argument list to prevent the empty buffer at start up
    "if argc() == 0
    "  execute 'args' bufname(2)
    "endif
  else
    " if we are not running as the server do not use the viminfo file.  We
    " probably only want to edit one file quickly from the command line.
    set viminfo=
  endif
endfunction

function! luc#setup#python()
  if has('nvim')
    "runtime! python_setup.vim
    python import vim
    pyfile ~/.config/vim/vimrc.py
  elseif has('python')
    python import vim
    "python if vim.VIM_SPECIAL_PATH not in sys.path: sys.path.append(vim.VIM_SPECIAL_PATH)
    pyfile ~/.config/vim/vimrc.py
  endif
endfunction

function! luc#setup#vundle()
  " https://github.com/gmarik/Vundle.vim
  filetype off
  let path = expand(g:luc#xdg#data . '/bundle')
  execute 'set runtimepath+=' . path . '/Vundle.vim'
  call vundle#begin(path)
endfunction
